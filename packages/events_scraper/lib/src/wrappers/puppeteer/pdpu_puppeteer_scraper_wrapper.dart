import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class PDPUPuppeteerScrapperWrapper extends PuppeteerScraperWrapper {
  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final Set<ScrapedEventEntity> allEvents = <ScrapedEventEntity>{};

    final Browser browser = await getBrowser();
    final Page page = await browser.newPage();

    try {
      await page.goto(uri.toString());

      final excursionsNavItemSelector =
          'a[href="https://www.pd-glasistre.hr/godisnji-plan-izleta/"]';
      await page.waitForSelector(excursionsNavItemSelector);
      await page.click(excursionsNavItemSelector);

      // get year
      final excursionsPageYearTitleSelector =
          "section.section.mcb-section.the_content.has_content p strong";
      await page.waitForSelector(excursionsPageYearTitleSelector);

      final excursionsPageYearTitleElement = await page.$(
        excursionsPageYearTitleSelector,
      );
      final excursionsPageYearTitle = await excursionsPageYearTitleElement
          .evaluate('(element) => element.textContent');
      print("PD Pula: excursionsPageYearTitle: $excursionsPageYearTitle");

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
      print("PD Pula: year: $year");

      // get events

      final excurionsTableSelector = "table.wptb-preview-table";
      await page.waitForSelector(excurionsTableSelector);

      final excursionsTable = await page.$(excurionsTableSelector);

      print("PD Pula: excursionsTable: $excursionsTable");

      final tableRowSelector = "tr.wptb-row";
      final tableRows = await excursionsTable.$$(tableRowSelector);

      print("PD Pula: tableRows.length: ${tableRows.length}");

      // TODO we dont care about the first row - it is the header
      for (int i = 1; i < tableRows.length; i++) {
        print("--------");
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

        print("PD Pula: dateContent: $dateContent");
        print("PD Pula: titleContent: $titleContent");

        final isDateRange = dateContent.contains("-");

        final date =
            isDateRange
                ? _getDateFromRangeDateString(dateContent, year)
                : _getDateFromSingleDateString(dateContent, year);

        print("PD Pula: date: $date");

        print("--------");

        final event = ScrapedEventEntity(
          title: titleContent.toString().trim(),
          date: date,
          uri: Uri.parse("https://www.pd-glasistre.hr/godisnji-plan-izleta/"),
          venue: "Planinarsko društvo Pula",
          imageUri: Uri.parse("https://picsum.photos/300/200"),
        );

        allEvents.add(event);
      }
    } catch (e) {
      print("PD Pula: error: $e");
    }

    await page.close();
    await browser.close();
    print("RocScraper: allEvents.length: ${allEvents.length}");

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

      return DateTime(year, month, startDay);
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

      return DateTime(year, month, startDay);
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

    return DateTime(year, month, day);
  }

  @override
  // TODO: implement name
  String get name => "Planinarsko društvo Pula";

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse("https://www.pd-glasistre.hr/");
}
