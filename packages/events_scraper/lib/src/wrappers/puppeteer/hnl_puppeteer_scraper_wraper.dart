import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/timezone/timezone_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class HnlPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  @override
  // TODO: implement name
  String get name => "Hrvatska nogometna liga";

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse("https://hnl.hr/klubovi/istra-1961/");

  const HnlPuppeteerScraperWrapper() : super();

  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();

    final page = await browser.newPage();

    try {
      await page.goto(uri.toString(), wait: Until.networkIdle);

      // selector table container for all matches
      final matchesTableSelector = "table.table1.raspored.utakmice";
      final matchesTable = await page.$(matchesTableSelector);

      final matchesTableRowsSelector = "tbody > tr";
      final matchesTableRows = await matchesTable.$$(matchesTableRowsSelector);

      print("found matches table: $matchesTable");

      for (final tableRow in matchesTableRows) {
        // get classes of each element
        // final rowClasses = (await tableRow.evaluate(
        //   '(element) => element.className',
        // )).toString();

        // if(rowClasses.isNotEmpty) {
        //   // we dont care about header rows
        //   continue;
        // }
        // print("row classes: $rowClasses");

        final rowContent = await tableRow.evaluate(
          '(element) => element.textContent',
        );

        // we dont care about header rows containing match reports
        if (rowContent!.contains("Izvještaj")) {
          continue;
        }

        print("row content: $rowContent");

        final homeTeamCell = await tableRow.$("td:nth-child(2)");
        final homeTeam =
            (await homeTeamCell.evaluate(
              '(element) => element.textContent',
            )).toString().trim();

        if (homeTeam != "Istra 1961") {
          continue; // we only care about Istra 1961 matches
        }

        final awayTeamCell = await tableRow.$("td:nth-child(6)");
        final awayTeam =
            (await awayTeamCell.evaluate(
              '(element) => element.textContent',
            )).toString().trim();

        final matchInfoCell = await tableRow.$("td:nth-child(1)");

        final matchInfo = await matchInfoCell.evaluate(
          '(element) => element.textContent',
        );

        print("match info: $matchInfo");

        final matchDateTime = _convertMatchInfoToDateTime(matchInfo!);

        final event = ScrapedEventEntity(
          title: "$homeTeam - $awayTeam",
          venue: "Aldo Drosina",
          date: matchDateTime,
          uri: uri,
          imageUri: Uri.parse(
            "https://upload.wikimedia.org/wikipedia/commons/f/f7/Pula_-_stadion_-_january_2011_-_zapad_%28W%29_-_panoramio.jpg",
          ),
          description: "",
        );

        allEvents.add(event);
      }
    } catch (e) {
      print("HnlScraper: error: $e");
    }

    await page.close();
    await browser.close();

    return allEvents.toSet();
  }
}

DateTime _convertMatchInfoToDateTime(String matchInfo) {
  // extract date and time from matchInfo
  RegExp regExp = RegExp(r"(\d{2})\.(\d{2})\.(\d{4})\.(?:\s+(\d{2}):(\d{2}))?");

  final match = regExp.firstMatch(matchInfo);
  if (match == null) {
    // TODO not sure if we should throw an error here
    throw Exception("Match info does not match the regex: $matchInfo");
  }

  final String dayValue = match.group(1)!;
  final String monthValue = match.group(2)!;
  final String yearValue = match.group(3)!;
  final String hourValue =
      match.group(4) ?? "00"; // default to 00 if not present
  final String minuteValue =
      match.group(5) ?? "00"; // default to 00 if not present

  final utcDateTime = TimezoneWrapper.toLocationDateInUTC(
    TimezoneLocation.croatia,
    year: int.parse(yearValue),
    month: int.parse(monthValue),
    day: int.parse(dayValue),
    hours: int.parse(hourValue),
    minutes: int.parse(minuteValue),
  );

  return utcDateTime;
}
