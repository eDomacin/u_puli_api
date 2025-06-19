import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class RojcPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  // TODO clean up

  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final Set<ScrapedEventEntity> allEvents = <ScrapedEventEntity>{};

    final Browser browser = await getBrowser();
    final Page page = await browser.newPage();

    try {
      await page.goto(uri.toString());

      final calendartNavItemSelector =
          "a[href='http://rojcnet.pula.org/kalendar-dogadanja/']";
      await page.waitForSelector(calendartNavItemSelector);
      await page.click(calendartNavItemSelector);

      for (int i = 0; i < 4; i++) {
        final pageEvents = await _scrapeMonth(page: page);
        allEvents.addAll(pageEvents);

        // await page.click("a.evo_month_next");
        final nextMonthSelector = "main span#evcal_next";
        await page.waitForSelector(nextMonthSelector);
        await page.click(nextMonthSelector);
      }
    } catch (e) {
      print("RojcScraper: error: $e");
    }

    await page.close();
    await browser.close();

    print("RocScraper: allEvents.length: ${allEvents.length}");

    return allEvents.toSet();
  }

  Future<Set<ScrapedEventEntity>> _scrapeMonth({required Page page}) async {
    final allEvents = <ScrapedEventEntity>[];

    final singleMainEventsListSelector = "main div.eventon_events_list";
    await page.waitForSelector(singleMainEventsListSelector);

    final singleMainEventsList = await page.$(singleMainEventsListSelector);
    final singleMainEventItemSelector =
        "main div.eventon_events_list div.eventon_list_event";
    await page.waitForSelector(singleMainEventItemSelector);

    final singleMainEventItems = await singleMainEventsList.$$(
      singleMainEventItemSelector,
    );

    print(
      "RojcScraper: singleMainEventItems.length: ${singleMainEventItems.length}",
    );

    for (int i = 0; i < singleMainEventItems.length; i++) {
      final singleMainEventItem = singleMainEventItems[i];

      final schemaSelector = "main div.evo_event_schema";
      final eventSchema = await singleMainEventItem.$(schemaSelector);

      final eventUrlSelector = "main div.evo_event_schema a[itemprop='url']";
      final eventUrl = await eventSchema.$(eventUrlSelector);

      final url = await eventUrl.evaluate('(element) => element.href');
      final uri = Uri.tryParse(url);
      if (uri == null) {
        // TODO probably better to continue here
        // throw Exception("No uri found");
        print("There was an issue with the uri");
        continue;
      }

      final startDateSelector =
          "main div.evo_event_schema meta[itemprop='startDate']";
      final startDate = await eventSchema.$(startDateSelector);

      final startDateContent =
          ((await startDate.evaluate('(element) => element.content')) as String)
              .trim();

      print("RojcScraper: eventSchema: $eventSchema");
      print("RojcScraper: eventUrl: $eventUrl");
      print("RojcScraper: url: $url");
      print("RojcScraper: startDate: $startDateContent");

      final regex = RegExp(r"(\d{4})-(\d{1,2})-(\d{1,2})T(\d{1,2}):(\d{2})");
      final match = regex.firstMatch(startDateContent);

      if (match == null) {
        // TODO probably better to continue here
        // throw Exception("No match found");
        // TODO maybe better to first get title here, so we know what we are skipping
        print("There was an issue with the date format");
        continue;
      }

      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minutes = int.parse(match.group(5)!);

      final eventDate = DateTime(year, month, day, hour, minutes);
      print("RojcScraper: eventDate: $eventDate");

      final titleSelector = "main span.evoet_title";
      final title = await singleMainEventItem.$(titleSelector);
      final titleContent = await title.evaluate(
        '(element) => element.textContent',
      );

      print("RojcScraper: title: $titleContent");

      final event = ScrapedEventEntity(
        title: titleContent as String,
        venue: "DC Rojc",
        date: eventDate,
        uri: uri,
        // TODO temp placegholder
        imageUri: Uri.parse("https://picsum.photos/300/200"),
      );

      allEvents.add(event);
    }

    return allEvents.toSet();
  }

  @override
  String get name => "DC Rojc";

  @override
  Uri get uri => Uri.parse("https://rojcnet.pula.org/");
}
