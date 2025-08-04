import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/timezone/timezone_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

/* TODO shoukld not be using this - this is also an agregator - better use direct sources  */

class PulainfoPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  @override
  // TODO: implement name
  String get name => "Pula info";

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse('https://pulainfo.hr/hr/pula-events/');

  const PulainfoPuppeteerScraperWrapper();

  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();

    // scrape concerts
    final concertsEvents = await _scrapeEvents(
      browser: browser,
      eventType: EventType.concerts,
    );
    allEvents.addAll(concertsEvents);

    // scrape festivals
    final festivalsEvents = await _scrapeEvents(
      browser: browser,
      eventType: EventType.festivals,
    );
    allEvents.addAll(festivalsEvents);

    // scrape theatre
    final theatreEvents = await _scrapeEvents(
      browser: browser,
      eventType: EventType.theatre,
    );
    allEvents.addAll(theatreEvents);
    // scrape exhibitions
    final exhibitionsEvents = await _scrapeEvents(
      browser: browser,
      eventType: EventType.exhibitions,
    );
    allEvents.addAll(exhibitionsEvents);
    // scrape other events
    final otherEvents = await _scrapeEvents(
      browser: browser,
      eventType: EventType.other,
    );
    allEvents.addAll(otherEvents);

    await browser.close();

    return allEvents.toSet();
  }

  Future<Set<ScrapedEventEntity>> _scrapeEvents({
    required Browser browser,
    required EventType eventType,
  }) async {
    final List<ScrapedEventEntity> events = <ScrapedEventEntity>[];

    final eventsTypeUri = uri.replace(
      queryParameters: {"_event_type": eventType.name},
    );

    final page = await browser.newPage();

    try {
      await page.goto(eventsTypeUri.toString(), wait: Until.networkIdle);

      final eventsContainerSelector = "div.row.facetwp-template";
      final eventsContainer = await page.$(eventsContainerSelector);

      final eventContainerSelector = "div.col-reset";
      final eventContainers = await eventsContainer.$$(eventContainerSelector);

      for (final eventContainer in eventContainers) {
        // final eventArticleSelector = "article.list-article";
        // final eventArticle = await eventContainer.$(eventArticleSelector);

        final urlSelector = "a";
        final urlElement = await eventContainer.$(urlSelector);
        final url =
            (await urlElement.evaluate(
              '(element) => element.href',
            )).toString().trim();

        final imgUrlSelector = "img.wp-post-image";
        final imgUrlElement = await eventContainer.$(imgUrlSelector);
        final imgUrl =
            (await imgUrlElement.evaluate(
              '(element) => element.src',
            )).toString().trim();

        final eventInfoSelector = "article.list-article > div:nth-child(3)";
        final eventInfoElement = await eventContainer.$(eventInfoSelector);

        final titleSelector = "h2";
        final titleElement = await eventInfoElement.$(titleSelector);
        final title =
            (await titleElement.evaluate(
              '(element) => element.textContent',
              // )).toString().replaceFirst("Lokacija", "").trim();
            )).toString().trim();

        final locationSelector = "p.box-location";
        final locationElement = await eventInfoElement.$OrNull(
          locationSelector,
        );
        final location =
            locationElement == null
                ? "Pula"
                : (await locationElement.evaluate(
                  '(element) => element.textContent',
                )).toString().replaceFirst("Lokacija", "").trim();

        final dateSelector = 'p[style="margin-bottom:0; float:left;"]';
        final dateElement = await eventInfoElement.$(dateSelector);
        final dateString =
            (await dateElement.evaluate(
              '(element) => element.textContent',
            )).toString().replaceFirst("Datum", "").trim();

        final timeSelector = "div.clear + p";
        final timeElement = await eventInfoElement.$(timeSelector);
        final timeString =
            (await timeElement.evaluate(
              '(element) => element.textContent',
            )).toString().replaceFirst("Vrijeme", "").trim();

        final date = _getDateElementsFromDateString(
          dateString: dateString,
          timeString: timeString,
        );

        String description = await _getEventDescription(browser, url);

        // end of extracted function

        final event = ScrapedEventEntity(
          title: title,
          venue: location,
          date: date,
          uri: Uri.parse(url),
          imageUri: Uri.parse(imgUrl),
          description: description,
        );

        events.add(event);
      }
    } catch (e) {
      print(
        "PulainfoScraper: error while scraping '${eventType.name}' events: $e",
      );
    }

    await page.close();

    return events.toSet();
  }

  Future<String> _getEventDescription(Browser browser, String url) async {
    // extract this into a function
    // NOTE: not extracting date and time and location, because that way it would overwrite the date and time and location, and would not show you multi-day events as happening today
    final detailsPage = await browser.newPage();
    await detailsPage.goto(url, wait: Until.networkIdle);

    final detailsContainerSelector = "main#main.site-main";
    final detailsContainer = await detailsPage.$(detailsContainerSelector);

    final descriptionContainerSelector = "div.entry-content";
    final descriptionContainer = await detailsContainer.$(
      descriptionContainerSelector,
    );
    // final dirtyDescription =
    //     (await descriptionContainer.evaluate(
    //       '(element) => element.textContent',
    //     )).toString().trim();

    final descriptionParagraphSelector = "div.entry-content > p";
    final descriptionParagraphs = await descriptionContainer.$$(
      descriptionParagraphSelector,
    );

    final description = await _getDescriptionFromElements(
      descriptionParagraphs,
    );

    await detailsPage.close();

    return description;
  }
}

Future<String> _getDescriptionFromElements(List<ElementHandle> elements) async {
  if (elements.isEmpty) return "";

  final descriptions = await Future.wait(
    elements.map((e) async {
      final text = await e.evaluate('(element) => element.textContent');
      return text.toString().trim();
    }),
  );

  return descriptions.join("\n").trim();
}

DateTime _getDateElementsFromDateString({
  required String dateString,
  required String timeString,
}) {
  RegExp dateRegExp = RegExp(r'(\d{2})/(\d{2})/(\d{4})');
  final dateMatch = dateRegExp.firstMatch(dateString);
  if (dateMatch == null) {
    throw Exception("No match found in date string: $dateString");
  }

  final day = int.parse(dateMatch.group(1)!);
  final month = int.parse(dateMatch.group(2)!);
  final year = int.parse(dateMatch.group(3)!);

  RegExp regExp = RegExp(r'(\d{2}):(\d{2})');
  final timeMatch = regExp.firstMatch(timeString);

  final hours = int.parse(timeMatch?.group(1) ?? '0');
  final minutes = int.parse(timeMatch?.group(2) ?? '0');

  final date = TimezoneWrapper.toLocationDateInUTC(
    TimezoneLocation.croatia,
    year: year,
    month: month,
    day: day,
    hours: hours,
    minutes: minutes,
  );

  return date;
}

enum EventType {
  concerts._("koncerti"),
  festivals._("festivali"),
  theatre._("kazaliste"),
  exhibitions._("izlozbe"),
  other._("ostala-dogadanja")
  // festivals,
  // theatre,
  // exhibitions,
  // other;
  ;

  const EventType._(this.name);
  final String name;
}
