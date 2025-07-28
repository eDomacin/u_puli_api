import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/timezone/timezone_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class SpPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  @override
  // TODO: implement name
  String get name => "Šou Program";

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse('https://souprogram.hr/#events');

  const SpPuppeteerScraperWrapper();

  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();

    final page = await browser.newPage();

    try {
      await page.goto(uri.toString(), wait: Until.networkIdle);

      final eventsContainerSelector = 'section#events div.grid.gap-4';
      final eventsContainer = await page.$(eventsContainerSelector);

      final eventContainerSelector =
          'div.flex.flex-col.gap-4.rounded-2xl.border.border-gray-600.p-6.text-gray-300';
      final eventContainers = await eventsContainer.$$(eventContainerSelector);

      for (final eventContainer in eventContainers) {
        final titleSelector = 'h2.font-brioni';
        final titleElement = await eventContainer.$(titleSelector);
        final title =
            (await titleElement.evaluate(
              '(element) => element.textContent',
            )).toString().trim();

        final descriptionSelector = "p";
        final descriptionElement = await eventContainer.$(descriptionSelector);
        final description =
            (await descriptionElement.evaluate(
              '(element) => element.textContent',
            )).toString().trim();

        final urlSegmentSelector = "a";
        final urlSegmentElement = await eventContainer.$(urlSegmentSelector);
        final url =
            (await urlSegmentElement.evaluate(
              '(element) => element.href',
            )).toString().trim();

        final eventInfoContainerSelector = "div.text-gray-400";
        final eventInfoContainer = await eventContainer.$(
          eventInfoContainerSelector,
        );

        final dateSelector = "p:nth-child(1)";
        final timeSelector = "p:nth-child(2)";
        final locationSelector = "p:nth-child(3)";

        final dateElement = await eventInfoContainer.$(dateSelector);
        final timeElement = await eventInfoContainer.$(timeSelector);
        final locationElement = await eventInfoContainer.$(locationSelector);

        final dateString =
            (await dateElement.evaluate(
              '(element) => element.textContent',
            )).toString().trim();
        final timeString =
            (await timeElement.evaluate(
              '(element) => element.textContent',
            )).toString().trim();
        final locationString =
            (await locationElement.evaluate(
              '(element) => element.textContent',
            )).toString().trim();

        final (:day, :month, :year) = _getDateElementsFromDateString(
          dateString,
        );
        final (:hours, :minutes) = _getTimeElementsFromTimeString(timeString);

        final utcDateTime = TimezoneWrapper.toLocationDateInUTC(
          TimezoneLocation.croatia,
          year: year,
          month: month,
          day: day,
          hours: hours,
          minutes: minutes,
        );

        final location = locationString.replaceFirst("📍", "").trim();

        final event = ScrapedEventEntity(
          title: title,
          venue: location,
          date: utcDateTime,
          uri: Uri.parse(url),
          imageUri: Uri.parse(
            "https://souprogram.hr/sou-program-logo-bez-pozadine.png",
          ),
          description: description,
        );

        allEvents.add(event);
      }
    } catch (e) {
      print("SpPuppeteerScraperWrapper: error: $e");
    }

    await page.close();
    await browser.close();

    return allEvents.toSet();
  }
}

({int day, int month, int year}) _getDateElementsFromDateString(
  String dateString,
) {
  RegExp regExp = RegExp(r'(\d{1,2})\.\s*(\d{1,2})\.\s*(\d{4})\.');

  final match = regExp.firstMatch(dateString);
  if (match == null) {
    throw Exception(
      "SpPuppeteerScraperWrapper: dateString: $dateString does not match the regex",
    );
  }

  final day = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final year = int.parse(match.group(3)!);

  return (day: day, month: month, year: year);
}

({int hours, int minutes}) _getTimeElementsFromTimeString(String timeString) {
  final RegExp regExp = RegExp(r'(\d{1,2}):(\d{2})');

  final match = regExp.firstMatch(timeString);

  if (match == null) {
    throw Exception("No match found in the text: $timeString");
  }

  final hours = int.parse(match.group(1)!);
  final minutes = int.parse(match.group(2)!);

  return (hours: hours, minutes: minutes);
}
