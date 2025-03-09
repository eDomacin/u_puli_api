import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class InkPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();

    final Page page = await browser.newPage();

    // goes to helper fucntions
    await page.goto('https://www.ink.hr/');

    final scheduleNavItemSelector =
        'a.header-nav-link[href="https://www.ink.hr/raspored/"]';
    await page.waitForSelector(scheduleNavItemSelector);
    await page.click(scheduleNavItemSelector);

    final scheduleMonthBlockSelector = "div.schedule-month-block";

    // TODO maybe not needed
    // await Future.delayed(Duration(seconds: 1));

    await page.waitForSelector(scheduleMonthBlockSelector);

    // await _takeScreenshot(page, 1);

    final scheduleMonthBlocks = await page.$$(scheduleMonthBlockSelector);

    for (final monthBlock in scheduleMonthBlocks) {
      // now need to select all events in this block
      final blockEventsSelector = "li.schedule-list-item";
      final blockEvents = await monthBlock.$$(blockEventsSelector);

      print("blockEvents.length: ${blockEvents.length}");

      for (final blockEvent in blockEvents) {
        final titleSelector = "a.title-3";
        final titleElement = await blockEvent.$(titleSelector);

        final title = await titleElement.evaluate(
          '(element) => element.textContent',
        );
        final url = await titleElement.evaluate('(element) => element.href');

        print("title: $title");
        print("url: $url");

        final dateSelector = "div.schedule-item-day";
        final dateElement = await blockEvent.$(dateSelector);
        final dateString = await dateElement.evaluate(
          '(element) => element.textContent',
        );

        print("dateString: $dateString");

        final dateStringRegex = RegExp(
          r'(\d{1,2})\.\s+([A-Za-zčćđšž]+)\s+(\d{4})\.',
        );
        final dateStringRegexpMatch = dateStringRegex.firstMatch(dateString);

        if (dateStringRegexpMatch == null) {
          throw Exception('No match found');
        }

        final dayString = dateStringRegexpMatch.group(1);
        final monthString = dateStringRegexpMatch.group(2);
        final yearString = dateStringRegexpMatch.group(3);

        final day = int.parse(dayString!);
        final month = monthString!.toINKMonthIndex;
        final year = int.parse(yearString!);

        print("dayString: $dayString");

        final timeSelector = "div.schedule-item-time";
        final timeElement = await blockEvent.$(timeSelector);

        final timeString = await timeElement.evaluate(
          '(element) => element.textContent',
        );
        final timeSections = timeString.split(":");
        final hours = int.parse(timeSections[0]);
        final minutes = int.parse(timeSections[1]);

        print("hours: $hours");

        final date = DateTime(year, month, day, hours, minutes);

        final event = ScrapedEventEntity(
          title: title,
          date: date,
          uri: Uri.parse(url),
          venue: "Istarsko Narodno Kazalište",
          // TODO temp placegholder
          imageUri: Uri.parse("https://picsum.photos/300/200"),
        );

        allEvents.add(event);
      }
    }

    // end of helper functions

    await page.close();
    await browser.close();

    return allEvents.toSet();
  }

  @override
  // TODO: implement name
  String get name => "Istarsko narodno kazalište";

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse("https://www.ink.hr/");
}

extension on String {
  int get toINKMonthIndex {
    return switch (this) {
      "siječnja" => 1,
      "veljače" => 2,
      "ožujka" => 3,
      "travnja" => 4,
      "svibnja" => 5,
      "lipnja" => 6,
      "srpnja" => 7,
      "kolovoza" => 8,
      "rujna" => 9,
      "listopada" => 10,
      "studenog" => 11,
      "prosinca" => 12,
      _ => throw Exception("Invalid month name"),
    };
  }
}
