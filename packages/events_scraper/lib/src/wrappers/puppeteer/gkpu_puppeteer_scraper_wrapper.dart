import 'dart:io';

import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class GkpuPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  // TODO this needs cleanup
  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();

    final page = await browser.newPage();

    try {
      // extract into functions
      await page.goto(uri.toString(), wait: Until.networkIdle);

      // close cookies consent
      final cookiesConsentSelector = "div#privacy-banner";
      final cookiesConsent = await page.$(cookiesConsentSelector);
      final acceptCookiesButtonSelector = "a.js-cookie-accept";
      final acceptCookiesButton = await cookiesConsent.$(
        acceptCookiesButtonSelector,
      );
      // await acceptCookiesButton.click();
      await acceptCookiesButton.evaluate('(element) => element.click()');

      // navigate to events page
      final eventsNavItemSelector =
          'li.cms-menu-item > a[href="/hr/dogadjanja/"]';
      // 'li.cms-menu-item > a[href="/hr/novosti/"]';
      final eventsNavItem = await page.$(eventsNavItemSelector);
      // await eventsNavItem.click();
      await eventsNavItem.evaluate('(element) => element.click()');

      // get events
      final eventsWrapperSelector = "div.blog-main-wrapper";
      // final eventsWrapper = await page.$(eventsWrapperSelector);
      // need to await that initial page is loaded
      await page.waitForSelector(eventsWrapperSelector);

      final nextButtonSelector = "i.fa-angle-right";
      // await page.waitForSelector(nextButtonSelector);
      ElementHandle? nextButton = await page.$OrNull(nextButtonSelector);
      // ElementHandle? nextButton;

      int currentPage = 1;

      // we can always scrape the first page

      do {
        // wait for the eventsWrapperSelector to exist
        await page.waitForSelector(eventsWrapperSelector);
        final eventsWrapper = await page.$(eventsWrapperSelector);

        final eventElementsSelector = "div.single-shop";
        final eventElements = await eventsWrapper.$$(eventElementsSelector);

        for (final eventElement in eventElements) {
          // date
          final dateElementSelector = "ul.news-post-meta > li:nth-child(2)";
          final dateElement = await eventElement.$(dateElementSelector);

          final dateString =
              (await dateElement.evaluate(
                '(element) => element.textContent',
              )).toString().trim();

          final dateRegExp = RegExp(r'(\d{1,2})\.(\d{1,2})\.(\d{2})\.');
          final match = dateRegExp.firstMatch(dateString);

          if (match == null) {
            throw Exception("No match found");
          }

          final dayString = match.group(1)!;
          final monthString = match.group(2)!;
          final yearString = "20${match.group(3)}";

          final day = int.parse(dayString);
          final month = int.parse(monthString);
          final year = int.parse(yearString);

          // time
          final timeElementSelector = "ul.news-post-meta > li:nth-child(3)";
          final timeElement = await eventElement.$(timeElementSelector);

          final time =
              (await timeElement.evaluate(
                '(element) => element.textContent',
              )).toString().trim();

          final timeSections = time.split(":");
          final hours = int.parse(timeSections[0]);
          final minutes = int.parse(timeSections[1]);

          final date = DateTime(year, month, day, hours, minutes);

          // title
          final titleElementSelector = "h3 > a";
          final titleElement = await eventElement.$(titleElementSelector);

          final imageSelector = "div.product-img.product-img-list > a > img";
          final imageElement = await eventElement.$(imageSelector);

          final imageUrl = await imageElement.evaluate(
            '(element) => element.src',
          );

          print("imageUrl: $imageUrl");

          final imageUri = Uri.parse(imageUrl.toString().trim());

          final title =
              (await titleElement.evaluate(
                '(element) => element.textContent',
              )).toString().trim();
          final url =
              (await titleElement.evaluate(
                '(element) => element.href',
              )).toString();

          /* TODO create function to extract decription  */

          final detailsPage = await browser.newPage();
          await detailsPage.goto(url, wait: Until.networkIdle);

          // wait for the content to load
          final eventDescriptionSelector = "div.blog-single-content";
          await detailsPage.waitForSelector(eventDescriptionSelector);

          final eventDescriptionElement = await detailsPage.$(
            eventDescriptionSelector,
          );

          final description = await eventDescriptionElement.evaluate(
            '(element) => element.textContent',
          );

          // print("description: $description");

          await detailsPage.close();

          /* ---------- */

          final event = ScrapedEventEntity(
            title: title,
            date: date,
            uri: Uri.parse(url),
            venue: "Gradska knjižnica i čitaonica Pula",
            // TODO temp placegholder
            // imageUri: Uri.parse("https://picsum.photos/300/200"),
            imageUri: imageUri,
            description: description.toString().trim(),
          );

          allEvents.add(event);

          print("date: $date");
        }

        print("scrapping page: $currentPage");

        // scrape stuff

        // get next button
        nextButton = await page.$OrNull(nextButtonSelector);
        // go to next page
        if (nextButton != null) {
          // await nextButton.click();
          await nextButton.evaluate('(element) => element.click()');
          currentPage++;
        }
      } while (nextButton != null);

      // end extracted functions
    } catch (e) {
      print("GkpuPuppeteerScraperWrapper: error: $e");
    }

    await page.close();
    await browser.close();

    return allEvents.toSet();
  }

  @override
  // TODO: implement name
  String get name => 'Gradska knjižnica i čitaonica Pula';

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse('https://www.gkc-pula.hr/hr/');
}

Future<void> _TAKE_SCREENSHOT(Page page, int index) async {
  final screenshot = await page.screenshot();
  final path =
      "/Users/karlo/development/mine/upuli/u_puli_api/packages/events_scraper/bin";

  await File("$path/image$index.png").writeAsBytes(screenshot);
}
