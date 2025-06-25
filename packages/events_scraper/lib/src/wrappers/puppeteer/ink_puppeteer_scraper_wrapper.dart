import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class InkPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();

    final Page page = await browser.newPage();

    try {
      // goes to helper fucntions
      await page.goto(uri.toString());

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

          // get image
          final imageElementSelector = "div.schedule-item-left > img";
          final imageElement = await blockEvent.$(imageElementSelector);
          final imageUrl = await imageElement.evaluate(
            '(element) => element.src',
          );

          print("imageUrl!!!!!!!!!!: $imageUrl");

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

          final timeString =
              (await timeElement.evaluate('(element) => element.textContent')
                      as String)
                  .trim();

          final hourAndMinutes = _InkEventHourAndMinute.fromItemTimeString(
            timeString,
          );
          // // time can be either in format "21:00" or 9 - 21
          // // so we need to handle both cases
          // // we need to extract only start timn
          // final timeSections = timeString.split(":");
          // // final hoursSegment = timeSections[0].trim();
          // final hoursSegment = timeString.toString().substring(0, 2).trim();
          // // now remove anyhting from the string that is not a digit
          // final hoursSegmentDigits = hoursSegment.replaceAll(RegExp(r'\D'), '');
          // final hours = int.parse(hoursSegmentDigits);
          // final minutes = int.parse(timeSections[1]);

          print("hour and minutes: $hourAndMinutes");

          final date = DateTime(
            year,
            month,
            day,
            hourAndMinutes.hours,
            hourAndMinutes.minutes,
          );

          // here open new page to collect description
          final detailsPage = await browser.newPage();
          await detailsPage.goto(url.toString(), wait: Until.networkIdle);

          final descriptionSelector =
              // "div#galleries > section.repertoire-detail-section";
              "div#galleries";
          final descriptionElement = await detailsPage.$OrNull(
            descriptionSelector,
          );

          final description =
              ((await descriptionElement?.evaluate(
                            '(element) => element.textContent',
                          ) ??
                          "")
                      as String)
                  .trim()
                  // .replaceAll("KUPI ULAZNICU", "")
                  .replaceAll(RegExp(r"KUPI ULAZNICU(?:\s\(.+\))?"), "")
                  .replaceAll("GALERIJA", "")
                  .replaceAll("Učitaj još", "")
                  .trim();

          print("description!!!!!!!!!: $description");

          await detailsPage.close();

          // end of getting description

          final event = ScrapedEventEntity(
            title: title,
            date: date,
            uri: Uri.parse(url),
            venue: "Istarsko Narodno Kazalište",
            // TODO temp placegholder
            // imageUri: Uri.parse("https://picsum.photos/300/200"),
            imageUri: Uri.parse(imageUrl.toString().trim()),
            description: description,
          );

          allEvents.add(event);
        }
      }
    } catch (e) {
      print("Ink: error: $e");
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

class _InkEventHourAndMinute {
  final int hours;
  final int minutes;

  const _InkEventHourAndMinute({required this.hours, required this.minutes});

  factory _InkEventHourAndMinute.fromItemTimeString(String timeString) {
    // time can be in following formats:
    // option 1 - 21:00
    // option 2 - 9 - 21
    // option 3 - 9:30 - 21:30
    // option 4 - 21:30 - 22
    // option 5 - 21:30 - 22:30
    // option 6 - 21 - 22.30
    // option 7- 21 - 22

    final option1Regex = RegExp(r"(\d{2}):(\d{2})");
    final option2Regex = RegExp(r"(\d+)\s*-\s*\d+");
    final option3Regex = RegExp(r"^(\d{1,2}):(\d{2})");
    final option4Regex = RegExp(r"^(\d{1,2}):(\d{2})");
    final option5Regex = RegExp(r"^(\d{1,2}):(\d{2})");
    final option6Regex = RegExp(r"^(\d{1,2})\s*-\s*");
    final option7Regex = RegExp(r"^(\d{1,2})\s*-\s*\d*");

    if (option1Regex.hasMatch(timeString)) {
      final match = option1Regex.firstMatch(timeString)!;
      final hours = match.group(1);
      final minutes = match.group(2);

      print("hours: $hours");
      print("minutes: $minutes");

      return _InkEventHourAndMinute(
        hours: int.parse(hours!),
        minutes: int.parse(minutes!),
      );
    }

    if (option2Regex.hasMatch(timeString)) {
      final match = option2Regex.firstMatch(timeString)!;
      final hours = match.group(1);
      final minutes = 0;

      print("hours: $hours");
      print("minutes: $minutes");

      return _InkEventHourAndMinute(hours: int.parse(hours!), minutes: minutes);
    }

    if (option3Regex.hasMatch(timeString)) {
      final match = option3Regex.firstMatch(timeString)!;
      final hours = match.group(1);
      final minutes = match.group(2);

      print("hours: $hours");
      print("minutes: $minutes");

      return _InkEventHourAndMinute(
        hours: int.parse(hours!),
        minutes: int.parse(minutes!),
      );
    }

    if (option4Regex.hasMatch(timeString)) {
      final match = option4Regex.firstMatch(timeString)!;
      final hours = match.group(1);
      final minutes = match.group(2);

      print("hours: $hours");
      print("minutes: $minutes");

      return _InkEventHourAndMinute(
        hours: int.parse(hours!),
        minutes: int.parse(minutes!),
      );
    }

    if (option5Regex.hasMatch(timeString)) {
      final match = option5Regex.firstMatch(timeString)!;
      final hours = match.group(1);
      final minutes = match.group(2);

      print("hours: $hours");
      print("minutes: $minutes");

      return _InkEventHourAndMinute(
        hours: int.parse(hours!),
        minutes: int.parse(minutes!),
      );
    }

    if (option6Regex.hasMatch(timeString)) {
      final match = option6Regex.firstMatch(timeString)!;
      final hours = match.group(1);
      final minutes = 0;

      print("hours: $hours");
      print("minutes: $minutes");

      return _InkEventHourAndMinute(hours: int.parse(hours!), minutes: minutes);
    }

    if (option7Regex.hasMatch(timeString)) {
      final match = option7Regex.firstMatch(timeString)!;
      final hours = match.group(1);
      final minutes = 0;

      print("hours: $hours");
      print("minutes: $minutes");

      return _InkEventHourAndMinute(hours: int.parse(hours!), minutes: minutes);
    }

    throw ArgumentError('Invalid time format: $timeString');
  }

  @override
  String toString() {
    return '$_InkEventHourAndMinute{hours: $hours, minutes: $minutes}';
  }
}
