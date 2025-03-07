import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/naranca_puppeteer_scrapper_wrapper.dart';

class EventsScraperDataSourceImpl implements EventsScraperDataSource {
  const EventsScraperDataSourceImpl({
    required NarancaPuppeteerScraperWrapper narancaPuppeteerScraperWrapper,
  }) : _narancaPuppeteerScraperWrapper = narancaPuppeteerScraperWrapper;

  // TODO this could accept some kind of reporting service to log potential errors
  final NarancaPuppeteerScraperWrapper _narancaPuppeteerScraperWrapper;

  @override
  Future<Set<ScrapedEventEntity>> getNarancaEvents() async {
    _printStartScrapeMessage(
      name: _narancaPuppeteerScraperWrapper.name,
      uri: _narancaPuppeteerScraperWrapper.uri,
    );

    try {
      final events = await _narancaPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _narancaPuppeteerScraperWrapper.name,
        uri: _narancaPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      // _printFailedScrapeMessage(
      //   name: _narancaPuppeteerScraperWrapper.name,
      //   uri: _narancaPuppeteerScraperWrapper.uri,
      //   error: e.toString(),
      // );

      print("error: $e, stacktrace: $s");

      return <ScrapedEventEntity>{};
    }
  }

  // TODO maybe logs should be move to the controller - we could have access to some reporting service there
  void _printStartScrapeMessage({required String name, required Uri uri}) {
    print("Starting scraping of events from $name at $uri");
  }

  void _printFinishScrapeMessage({required String name, required Uri uri}) {
    print("Finished scraping of events from $name at $uri");
  }

  void _printFailedScrapeMessage({
    required String name,
    required Uri uri,
    required String error,
  }) {
    print("Failed scraping of events from $name at $uri, with error: $error");
  }
}
