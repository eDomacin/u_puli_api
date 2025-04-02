import 'dart:io';

import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class NarancaPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  const NarancaPuppeteerScraperWrapper() : super();

  // TODO this needs cleanup
  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    print("before getBrowser");
    final Browser browser = await getBrowser();

    print("before newPage");
    final Page page = await browser.newPage();

    try {
      print("before navigateToCalendarPage");
      await _navigateToCalendarPage(page);

      print("before delayed");
      await Future.delayed(Duration(seconds: 1));
      // await _takeScreenshot(page, 0);

      print("before closeCookiesConsent");
      await _closeCookiesConsent(page);

      print("before delayed2");
      await Future.delayed(Duration(seconds: 1));

      print("before switchToMonthView");
      await _switchToMonthView(page);

      for (int i = 0; i <= 3; i++) {
        print("before scrapeMonthEvents: $i");
        final pageEvents = await _scrapeMonthEvents(page: page);

        print("before allEvents.addAll");
        allEvents.addAll(pageEvents);

        // we only want to scrape 4 months
        if (i == 3) continue;

        print("before navigateToNextMonth");
        await _navigateToNextMonth(page);
      }
    } catch (e) {
      print("NarancaScraper: error: $e");
    }

    print("before close");
    await page.close();

    print("before browser.close");
    await browser.close();

    print("before return");
    return allEvents.toSet();
  }

  Future<void> _closeCookiesConsent(Page page) async {
    final closeButtonSelector = "div.cmplz-close";
    await page.waitForSelector(closeButtonSelector);

    final closeButton = await page.$(closeButtonSelector);
    await closeButton.click();
  }

  Future<void> _navigateToCalendarPage(Page puppeteerPage) async {
    await puppeteerPage.goto(uri.toString(), wait: Until.networkIdle);

    final calendarNavItemSelector = "#menu-item-7852";
    await puppeteerPage.waitForSelector(calendarNavItemSelector);
    await puppeteerPage.click(calendarNavItemSelector);
  }

  Future<void> _switchToMonthView(Page puppeteerPage) async {
    final calendarMonthOptionSelector = ".fc-dayGridMonth-button";
    await puppeteerPage.waitForSelector(calendarMonthOptionSelector);
    await puppeteerPage.click(calendarMonthOptionSelector);

    final calendarMonthTableSelector = ".fc-dayGridMonth-view";
    await puppeteerPage.waitForSelector(calendarMonthTableSelector);
  }

  Future<void> _navigateToNextMonth(Page page) async {
    final nextButtonSelector = "span.fc-icon-chevron-right";
    final nextButton = await page.$$(nextButtonSelector);

    await nextButton.first.click(delay: Duration(milliseconds: 500));
  }

  Future<List<ScrapedEventEntity>> _scrapeMonthEvents({
    required Page page,
  }) async {
    final events = <ScrapedEventEntity>[];

    final tableDayCellSelector = ".fc-daygrid-day";
    final tableDayCells = await page.$$(tableDayCellSelector);

    for (final cell in tableDayCells) {
      final cellDaySelector = ".fc-daygrid-day-top ";
      final cellDateSelector = ".fc-daygrid-day-top > .fc-daygrid-day-number";
      final cellEventSelector = ".fc-daygrid-day-events";

      final cellEventString = await (await cell.$(
        cellEventSelector,
      )).evaluate("e => e.textContent");
      if (cellEventString.isEmpty) {
        continue;
      }

      final dateString = await (await cell.$(
        cellDateSelector,
      )).evaluate("e => e.getAttribute('aria-label')");

      // TODO extract this to a function
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
      final month = monthString!.toNarancaMonthIndex;
      final year = int.parse(yearString!);

      final timeSelector = ".fc-event-time";
      final eventSelector = ".fc-event-title";

      final timeString =
          (await (await cell.$(
            timeSelector,
          )).evaluate("e => e.textContent")).toString().trim();
      final eventString =
          (await (await cell.$(
            eventSelector,
          )).evaluate("e => e.textContent")).toString().trim();

      final timeSections = timeString.split(":");
      final hours = int.parse(timeSections[0]);
      final minutes = int.parse(timeSections[1]);

      // TODO for some reason, we have issue with timezone here when we run this in docker or locally
      final date = DateTime(year, month, day, hours, minutes);

      final regex = RegExp(r'^(.*),\s([^,]+)$');

      final match = regex.firstMatch(eventString);
      if (match == null) throw Exception('No match found');

      final title = match.group(1);
      final venue = match.group(2);

      final popupHrefSelector = "a.fc-daygrid-event";
      final popupHref = await cell.$(popupHrefSelector);
      await popupHref.click();

      final detailsHrefSelector = ".eaelec-event-details-link";
      final detailsHref = await page.waitForSelector(detailsHrefSelector);

      if (detailsHref == null) {
        throw Exception("No details href found");
      }

      final url = await detailsHref.evaluate("e => e.href");

      final closeModalButtonSelector = ".eaelec-modal-close";
      final closeModalButton = await page.$(closeModalButtonSelector);
      await closeModalButton.click();

      final event = ScrapedEventEntity(
        title: title!,
        venue: venue!,
        date: date,
        uri: Uri.parse(url),
        // TODO temp placegholder
        imageUri: Uri.parse("https://picsum.photos/300/200"),
      );

      events.add(event);
    }

    return events;
  }

  @override
  String get name => "Teatar Naranča";

  @override
  Uri get uri => Uri.parse('https://www.teatarnaranca.hr/');

  // TODO this is only for testing - do not use it
  // ignore: unused_element, non_constant_identifier_names
  Future<void> _TAKE_SCREENSHOT(Page page, int index) async {
    final screenshot = await page.screenshot();
    final path =
        "/Users/karlo/development/mine/scraper_test/scraper_test_v1/bin";

    await File("$path/image$index.png").writeAsBytes(screenshot);
  }
}

extension on String {
  int get toNarancaMonthIndex {
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
