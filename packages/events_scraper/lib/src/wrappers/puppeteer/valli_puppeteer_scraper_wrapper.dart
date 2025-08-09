import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/timezone/timezone_wrapper.dart';
import 'package:puppeteer/puppeteer.dart';

class ValliPuppeteerScraperWrapper extends PuppeteerScraperWrapper {
  @override
  // TODO: implement name
  String get name => "Kino Valli";

  @override
  // TODO: implement uri
  Uri get uri => Uri.parse("https://www.kinovalli.net/filmski-program/");
  // Uri get uri => Uri.parse("https://www.kinovalli.net/filmski-program/?page=2");
  // Uri get uri => Uri.parse("https://kinovalli.net");
  // Uri get uri => Uri.parse("https://www.google.com/");

  const ValliPuppeteerScraperWrapper();

  @override
  Future<Set<ScrapedEventEntity>> getEvents() async {
    final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

    final Browser browser = await getBrowser();
    final Page page = await browser.newPage();
    /* TODO for some reason, this is needed to get around some proetection 
    - https://stackoverflow.com/a/75984260/9661910
    */
    // await page.setExtraHTTPHeaders({
    //   'Accept-Language': 'hr-HR,hr;q=0.9,en-US;q=0.8,en;q=0.7',
    //   'Cache-Control': 'no-cache',
    //   'Connection': 'keep-alive',
    //   'Sec-Fetch-User': '?1',
    //   'sec-ch-ua':
    //       '"Not_A Brand";v="8", "Chromium";v="144", "Google Chrome";v="144"',
    //   'sec-ch-ua-mobile': '?0',
    //   'sec-ch-ua-platform': '"Linux"',
    // });
    const ua1 =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36';
    await page.setUserAgent(
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
    );

    try {
      await page.setExtraHTTPHeaders({
        'Accept-Language': 'hr-HR,hr;q=0.9,en-US;q=0.8,en;q=0.7',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
        'Sec-Fetch-User': '?1',
        'sec-ch-ua':
            '"Not_A Brand";v="8", "Chromium";v="144", "Google Chrome";v="144"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Linux"',
      });
      // await _setPageHeaders(page);
      await page.goto(uri.toString(), wait: Until.networkIdle);
      final nextPageSelector =
          "div.pagination > ul > li > a > i.fas.fa-chevron-right";

      ElementHandle? nextPageButton;

      do {
        /* TODO need to always set these headers becauuse we always navigate again */
        // await _setPageHeaders(page);
        await page.setExtraHTTPHeaders({
          'Accept-Language': 'hr-HR,hr;q=0.9,en-US;q=0.8,en;q=0.7',
          'Cache-Control': 'no-cache',
          'Connection': 'keep-alive',
          'Sec-Fetch-User': '?1',
          'sec-ch-ua':
              '"Not_A Brand";v="8", "Chromium";v="144", "Google Chrome";v="144"',
          'sec-ch-ua-mobile': '?0',
          'sec-ch-ua-platform': '"Linux"',
        });
        /* function here to scrape page of movies */
        final events = await getPageEvents(page, browser, ua1);
        allEvents.addAll(events);

        // get button to next page
        nextPageButton = await page.$OrNull(nextPageSelector);

        // navigate to next page
        if (nextPageButton != null) {
          await nextPageButton.evaluate('(element) => element.click()');
          // await page.waitForNavigation(wait: Until.networkIdle);
        }
      } while (nextPageButton != null);

      /* end function to scrape page of movies */
    } catch (e) {
      print("ValliPuppeteerScraperWrapper error: $e");
    }

    await page.close();
    await browser.close();

    return allEvents.toSet();
  }
}
/* TODO should use this too */
// Future<void> _setPageHeaders(Page page) async {
//   await page.setExtraHTTPHeaders({
//     'Accept-Language': 'hr-HR,hr;q=0.9,en-US;q=0.8,en;q=0.7',
//     'Cache-Control': 'no-cache',
//     'Connection': 'keep-alive',
//     'Sec-Fetch-User': '?1',
//     'sec-ch-ua':
//         '"Not_A Brand";v="8", "Chromium";v="144", "Google Chrome";v="144"',
//     'sec-ch-ua-mobile': '?0',
//     'sec-ch-ua-platform': '"Linux"',
//   });
// }

Future<Set<ScrapedEventEntity>> getPageEvents(
  Page page,
  Browser browser,
  String userAgent,
) async {
  final List<ScrapedEventEntity> allEvents = <ScrapedEventEntity>[];

  final moviesContainerSelector = "main div.movies-list > div.row";
  // await Future.delayed(const Duration(seconds: 3));
  await page.waitForSelector(moviesContainerSelector);
  final moviesContainer = await page.$(moviesContainerSelector);

  final singleMovieContainerSelector = "div.movie-item";
  final singleMovieContainers = await moviesContainer.$$(
    singleMovieContainerSelector,
  );

  for (final movieContainer in singleMovieContainers) {
    final movieProjections = await _getSingleMovieProjections(
      movieContainer: movieContainer,
    );

    allEvents.addAll(movieProjections);
  }

  return allEvents.toSet();
}

Future<Set<ScrapedEventEntity>> _getSingleMovieProjections({
  required ElementHandle movieContainer,
}) async {
  /* there can be multiple projects of a movie */
  final Set<ScrapedEventEntity> projections = <ScrapedEventEntity>{};

  /* image  */
  final imageContainerSelector = "div.movie-poster > div";
  final imageContainer = await movieContainer.$(imageContainerSelector);

  final imageUrlValue = await imageContainer.evaluate(
    '(element) => element.style.background',
  );

  final imageUrlComponent =
      imageUrlValue
          .toString()
          .replaceAll('url("', "")
          .replaceAll('")', "")
          .replaceAll('center center / cover no-repeat', "")
          .trim();

  final imageUrl = "https://www.kinovalli.net$imageUrlComponent";

  print('Image URL: $imageUrl');

  /* title */
  final titleContainerSelector = "div.movie-content > h2.h3";
  final titleContainer = await movieContainer.$(titleContainerSelector);
  final title =
      (await titleContainer.evaluate(
        '(element) => element.textContent',
      )).toString().trim();

  /* description */
  final descriptionContainerSelector = "div.movie-content > p";
  final descriptionContainer = await movieContainer.$(
    descriptionContainerSelector,
  );

  final description =
      (await descriptionContainer.evaluate(
        '(element) => element.textContent',
      )).toString().trim();

  /* url */
  final movieUrlContainerSelector = "div.movie-actions > a";
  final movieUrlContainer = await movieContainer.$(movieUrlContainerSelector);

  final movieUrl =
      (await movieUrlContainer.evaluate(
        '(element) => element.href',
      )).toString().trim();

  /* location */
  final projectionContainerSelector =
      "div.movie-content > div.movie-projections > div.modal div.modal-content > div.modal-body > div.movie-projection-item";

  final projectionContainers = await movieContainer.$$(
    projectionContainerSelector,
  );

  for (final projectionContainer in projectionContainers) {
    final dateContainerSelector = "div.datetime > div.date";
    final timeContainerSelector = "div.datetime > div.time";
    final locationContainerSelector = "div.datetime > div.location";

    final dateContainer = await projectionContainer.$(dateContainerSelector);
    final timeContainer = await projectionContainer.$(timeContainerSelector);
    final locationContainer = await projectionContainer.$(
      locationContainerSelector,
    );

    final dateValue =
        (await dateContainer.evaluate(
          '(element) => element.textContent',
        )).toString().trim();

    final dateElements = dateValue.split(".");
    final day = int.parse(dateElements[0].trim());
    final month = int.parse(dateElements[1].trim());
    final year = int.parse(dateElements[2].trim());

    final timeValue =
        (await timeContainer.evaluate(
          '(element) => element.textContent',
        )).toString().trim();
    final timeElements = timeValue.split(":");
    final hour = int.parse(timeElements[0].trim());
    final minute = int.parse(timeElements[1].trim());

    final utcDate = TimezoneWrapper.toLocationDateInUTC(
      TimezoneLocation.croatia,
      year: year,
      month: month,
      day: day,
      hours: hour,
      minutes: minute,
    );

    final locationValue =
        (await locationContainer.evaluate(
          '(element) => element.textContent',
        )).toString().trim();

    final projectionEvent = ScrapedEventEntity(
      title: title,
      venue: locationValue,
      date: utcDate,
      /* TODO temp */
      uri: Uri.parse(movieUrl),
      imageUri: Uri.parse(imageUrl),
      description: description,
    );

    projections.add(projectionEvent);
  }

  return projections;
}
