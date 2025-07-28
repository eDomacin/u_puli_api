import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/timezone/timezone_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class PDPUPuppeteerScrapperWrapper extends PuppeteerScraperWrapper {
  @override
  // TODO: implement uri
  Uri get uri => Uri.parse("https://www.pd-glasistre.hr/godisnji-plan-izleta/");

  const PDPUPuppeteerScrapperWrapper();

  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final Set<ScrapedEventEntity> allEvents = <ScrapedEventEntity>{};

    final Browser browser = await getBrowser();
    final page = await browser.newPage();

    try {
      await page.goto(uri.toString(), wait: Until.networkIdle);

      // get year
      final excursionsPageYearTitleSelector =
          "section.section.mcb-section.the_content.has_content p strong";
      await page.waitForSelector(excursionsPageYearTitleSelector);

      final excursionsPageYearTitleElement = await page.$(
        excursionsPageYearTitleSelector,
      );
      final excursionsPageYearTitle = await excursionsPageYearTitleElement
          .evaluate('(element) => element.textContent');

      final excurionsPageYearTitleRegex = RegExp(
        r"PLAN PLANINARSKIH IZLETA ZA (\d{4})\. GODINU",
      );
      final match = excurionsPageYearTitleRegex.firstMatch(
        excursionsPageYearTitle!,
      );
      if (match == null) {
        throw Exception(
          "PD Pula: excursionsPageYearTitle: $excursionsPageYearTitle does not match the regex",
        );
      }

      final year = int.parse(match.group(1)!);

      // get events

      final excurionsTableSelector = "table.wptb-preview-table";
      await page.waitForSelector(excurionsTableSelector);

      final excursionsTable = await page.$(excurionsTableSelector);

      final tableRowSelector = "tr.wptb-row";
      final tableRows = await excursionsTable.$$(tableRowSelector);

      // TODO we dont care about the first row - it is the header
      for (int i = 1; i < tableRows.length; i++) {
        final tableRow = tableRows[i];

        final tableRowCellSelector = "td.wptb-cell";
        final tableRowCells = await tableRow.$$(tableRowCellSelector);

        final dateCell = tableRowCells[1];
        final titleCell = tableRowCells[3];

        final dateContent = await dateCell.evaluate(
          '(element) => element.textContent',
        );
        final titleContent = await titleCell.evaluate(
          '(element) => element.textContent',
        );

        final isDateRange = dateContent.contains("-");

        final date =
            isDateRange
                ? _getDateFromRangeDateString(dateContent, year)
                : _getDateFromSingleDateString(dateContent, year);

        final event = ScrapedEventEntity(
          title: titleContent.toString().trim(),
          date: date,
          uri: Uri.parse("https://www.pd-glasistre.hr/godisnji-plan-izleta/"),
          venue: "Planinarsko društvo Pula",
          imageUri: Uri.parse(
            "https://www.pd-glasistre.hr/wp-content/uploads/2022/06/PD-Glas-Istre-LOGO-000000001.png",
          ),
          /* TODO return to this once scraper works */
          description: "",
        );

        allEvents.add(event);
      }
    } catch (e) {
      print("PD Pula: error: $e");
    }

    await page.close();
    await browser.close();

    return allEvents.toSet();
  }

  DateTime _getDateFromRangeDateString(String rangeDateString, int year) {
    final sameMonthRange = RegExp(r'\d{1,2}\.?-?\d{1,2}\.\d{2}\.?');
    final differentMonthRange = RegExp(r'^\d{1,2}\.\d{2}\.-\d{1,2}\.\d{2}\.?$');
    if (differentMonthRange.hasMatch(rangeDateString)) {
      // TODO this might need adjustments for optional dots
      final regex = RegExp(r"^(\d{1,2})\.(\d{1,2})(?:.-|-).*");

      final match = regex.firstMatch(rangeDateString);
      if (match == null) {
        throw Exception(
          "PD Pula: rangeDateString: $rangeDateString does not match the regex",
        );
      }

      final startDayString = match.group(1)!;
      final monthString = match.group(2)!;

      final startDay = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);

      // return DateTime(year, month, startDay);
      return TimezoneWrapper.toLocationDateInUTC(
        TimezoneLocation.croatia,
        year: year,
        month: month,
        day: startDay,
        hours: 0,
        minutes: 0,
      );
    } else if (sameMonthRange.hasMatch(rangeDateString)) {
      final regex = RegExp(r"(\d{1,2})\.?\-\d{1,2}\.(\d{1,2})\.?");

      final match = regex.firstMatch(rangeDateString);
      if (match == null) {
        throw Exception(
          "PD Pula: rangeDateString: $rangeDateString does not match the regex",
        );
      }

      final startDay = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);

      return TimezoneWrapper.toLocationDateInUTC(
        TimezoneLocation.croatia,
        year: year,
        month: month,
        day: startDay,
        hours: 0,
        minutes: 0,
      );
    } else {
      throw Exception(
        "PD Pula: rangeDateString: $rangeDateString does not match the regex",
      );
    }
  }

  DateTime _getDateFromSingleDateString(String dateString, int year) {
    final regex = RegExp(r"(\d{1,2})\.(\d{1,2})\.?");
    final match = regex.firstMatch(dateString);
    if (match == null) {
      throw Exception(
        "PD Pula: dateString: $dateString does not match the regex",
      );
    }

    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);

    return TimezoneWrapper.toLocationDateInUTC(
      TimezoneLocation.croatia,
      year: year,
      month: month,
      day: day,
      hours: 0,
      minutes: 0,
    );
  }

  @override
  // TODO: implement name
  String get name => "Planinarsko društvo Pula";
}
