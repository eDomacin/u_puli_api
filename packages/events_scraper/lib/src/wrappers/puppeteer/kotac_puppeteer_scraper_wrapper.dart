import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class KotacPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  // TODO clean up
  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final Set<ScrapedEventEntity> allEvents = <ScrapedEventEntity>{};

    final Browser browser = await getBrowser();
    final Page page = await browser.newPage();

    await page.goto(uri.toString());

    final programNavItemSelector =
        "a.hfe-menu-item[href='https://kotac.eu/program-2/']";
    await page.waitForSelector(programNavItemSelector);
    await page.click(programNavItemSelector);

    final blockEventsWrapperSelector =
        "div.tt-event-list.tt-entity-list-container";
    await page.waitForSelector(blockEventsWrapperSelector);

    final blockEventsWrapper = await page.$(blockEventsWrapperSelector);

    print("KotacScraper: blockEventsWrapper: $blockEventsWrapper");

    final blockEventsSelector = "div.tt-evt-li";
    final blockEvents = await blockEventsWrapper.$$(blockEventsSelector);

    for (final blockEvent in blockEvents) {
      print("KotacScraper: blockEvent: $blockEvent");

      final imageUrlSelector = "img.tt-evt-li__img";
      final imageUrlElement = await blockEvent.$(imageUrlSelector);
      final imageUrl = await imageUrlElement.evaluate(
        '(element) => element.src',
      );

      print("KotacScraper: imageUrl: $imageUrl");

      final dateInfoSelector = "div.tt-evt-li__sub-info--BeginDate";
      final dateInfoElement = await blockEvent.$(dateInfoSelector);
      final dateInfo = await dateInfoElement.evaluate(
        '(element) => element.textContent',
      );

      print("KotacScraper: dateInfo: $dateInfo");

      final dateInfoRegex = RegExp(
        r'(\d{1,2})\.(\d{1,2})\.(\d{4})\s*@(\d{1,2}):(\d{2})',
      );
      final dateInfoRegexMatch = dateInfoRegex.firstMatch(dateInfo);

      if (dateInfoRegexMatch == null) {
        throw Exception(
          "KotacScraper: dateInfo: $dateInfo does not match the regex",
        );
      }

      final day = int.parse(dateInfoRegexMatch.group(1)!);
      final month = int.parse(dateInfoRegexMatch.group(2)!);
      final year = int.parse(dateInfoRegexMatch.group(3)!);
      final hour = int.parse(dateInfoRegexMatch.group(4)!);
      final minute = int.parse(dateInfoRegexMatch.group(5)!);

      final date = DateTime(year, month, day, hour, minute);

      print("KotacScraper: date: $date");

      final titleAndUrlSelector = "a.tt-evt-li__name";
      final titleAndUrlElement = await blockEvent.$(titleAndUrlSelector);
      final title = await titleAndUrlElement.evaluate(
        '(element) => element.text',
      );
      final url = await titleAndUrlElement.evaluate(
        '(element) => element.href',
      );

      print("KotacScraper: title: $title");
      print("KotacScraper: url: $url");

      final location = "Klub Kotač";

      final event = ScrapedEventEntity(
        title: title,
        date: date,
        venue: location,
        uri: Uri.parse(url),
        // TODO temp placegholder
        imageUri: Uri.parse("https://picsum.photos/300/200"),
      );

      print("KotacScraper: event: $event");
      allEvents.add(event);
    }

    //
    await page.close();
    await browser.close();

    return allEvents;
  }

  @override
  String get name => "Klub Kotač";

  @override
  Uri get uri => Uri.parse("https://kotac.eu/");
}
