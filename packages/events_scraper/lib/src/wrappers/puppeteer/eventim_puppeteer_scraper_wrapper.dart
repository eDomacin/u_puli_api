import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class EventimPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  @override
  String get name => "Eventim";

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse('https://www.eventim.hr/city/pula-5992/');
  // Uri get uri => Uri.parse('https://www.eventim.hr/city/zagreb-5991/');

  const EventimPuppeteerScraperWrapper();

  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();
    final Page page = await browser.newPage();

    /* TODO testing providing user agent  */
    // as per https://github.com/puppeteer/puppeteer/issues/11638#issuecomment-1915449858
    const ua1 =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36';
    const ua2 =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3';

    page.setUserAgent(ua2);

    int currentPage = 1;

    try {
      await page.goto(uri.toString(), wait: Until.networkIdle);
      // await page.goto(uri.toString(), wait: Until.domContentLoaded);

      final nextPageSelector =
          'nav.pagination-block > ul.pagination > .pagination-item > a[title="Sljedeća stranica"]';
      // 'nav.pagination-block > ul.pagination > .pagination-item > a.btn-btn-square[title="Sljedeća stranica"]';
      // ElementHandle? nextPageButton = await page.$OrNull(nextPageSelector);
      ElementHandle? nextPageButton;

      do {
        // scraping contents of current page
        final events = await getPageEvents(page, browser, ua2);
        allEvents.addAll(events);

        // get button to next page
        nextPageButton = await page.$OrNull(nextPageSelector);

        // natvigate to next page
        // await nextPageButton?.click();

        if (nextPageButton != null) {
          // await nextPageButton.click();
          await nextPageButton.evaluate('(element) => element.click()');
          // await page.waitForNavigation(wait: Until.networkIdle);
          currentPage++;
        }
        // await nextPageButton?.evaluate('(element) => element.click()');

        // currentPage++;
      } while (nextPageButton != null);
    } catch (e) {
      print("EventimScraperWrapper error: $e");
    }

    await page.close();
    await browser.close();

    return allEvents.toSet();
  }

  Future<Set<ScrapedEventEntity>> getPageEvents(
    Page page,
    Browser browser,
    String ua2,
  ) async {
    final List<ScrapedEventEntity> pageEvents = <ScrapedEventEntity>[];

    // await page.goto(uri.toString(), wait: Until.domContentLoaded);

    // await Future.delayed(const Duration(seconds: 3));

    final eventsContainerSelector =
        "div.search-result-content.search-result-content-listing";
    final eventsContainer = await page.$(eventsContainerSelector);

    final eventContainerSelector =
        "div.listing.listing-container > div.listing-item.borderless";
    final eventContainers = await eventsContainer.$$(eventContainerSelector);

    for (final eventContainer in eventContainers) {
      /* get url to navigate to details */
      final eventCTAButtonSelector =
          ".listing-cta.hydrated > a.btn.btn-primary";
      final eventCTAButton = await eventContainer.$(eventCTAButtonSelector);
      final eventUrlComponent =
          (await eventCTAButton.evaluate(
            '(element) => element.getAttribute("href")',
          )).toString().trim();

      final eventUrl = "https://www.eventim.hr$eventUrlComponent";

      /* TODO extract to a function */

      final event = await _getEvent(browser, eventUrl, ua2);

      pageEvents.add(event);
    }

    return pageEvents.toSet();
  }

  Future<ScrapedEventEntity> _getEvent(
    Browser browser,
    String eventUrl,
    String ua2,
  ) async {
    final eventPage = await browser.newPage();
    eventPage.setUserAgent(ua2);
    await eventPage.goto(eventUrl, wait: Until.networkIdle);

    /* get image  */
    final imageContainerSelector = "meta[property='og:image']";
    await eventPage.waitForSelector(imageContainerSelector);
    final imageElement = await eventPage.$(imageContainerSelector);

    final imgUrl =
        (await imageElement.evaluate(
          '(element) => element.getAttribute("content")',
        )).toString().trim();

    /* get details */

    final eventDetailsContainerSelector = "article.listing-item";
    final eventDetailsContainer = await eventPage.$(
      eventDetailsContainerSelector,
    );

    /* getting date  */
    final dateContainerSelector =
        "div.event-listing-date-box time.event-listing-date";
    final dateContainer = await eventDetailsContainer.$(dateContainerSelector);

    final dateTimeValue =
        (await dateContainer.evaluate(
          '(element) => element.getAttribute("datetime")',
        )).toString().trim();

    // NOTE: this is already UTC, becaseu the string includes zone
    final dateTime = DateTime.parse(dateTimeValue);

    /* getting info */
    final infoContainerSelector = "div.event-listing-info-wrapper";

    final infoContainer = await eventDetailsContainer.$(infoContainerSelector);

    final titleElementSelector = "h2.event-listing-city";
    final titleElement = await infoContainer.$(titleElementSelector);

    final title =
        (await titleElement.evaluate(
          '(element) => element.textContent',
        )).toString().trim();

    final locationSelector = "li.event-listing-event";
    final locationElement = await infoContainer.$(locationSelector);

    final location =
        (await locationElement.evaluate(
          '(element) => element.textContent',
        )).toString().trim();

    final descriptionContainerSelector = "section.c-full.c-inner.c-narrow ";
    final descriptionContainer = await eventPage.$(
      descriptionContainerSelector,
    );

    final descriptionParagraphSelector =
        "div.external-content.no-margin div.moretext p";

    final descriptionParagraphs = await descriptionContainer.$$(
      descriptionParagraphSelector,
    );

    final descriptionBuffer = StringBuffer();

    for (final paragraph in descriptionParagraphs) {
      final paragraphText = await paragraph.evaluate(
        '(element) => element.textContent',
      );
      descriptionBuffer.write("${paragraphText.toString().trim()}\n");
    }

    final desecription = descriptionBuffer.toString().trim();

    await eventPage.close();

    final event = ScrapedEventEntity(
      title: title,
      venue: location,
      date: dateTime,
      uri: Uri.parse(eventUrl),
      imageUri: Uri.parse(imgUrl),
      description: desecription,
    );

    return event;
  }
}
