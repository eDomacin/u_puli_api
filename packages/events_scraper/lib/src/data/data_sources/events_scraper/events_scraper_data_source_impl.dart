import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/gkpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/ink_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/naranca_puppeteer_scrapper_wrapper.dart';

class EventsScraperDataSourceImpl implements EventsScraperDataSource {
  const EventsScraperDataSourceImpl({
    required NarancaPuppeteerScraperWrapper narancaPuppeteerScraperWrapper,
    required GkpuPuppeteerScraperWrapper gkpuPuppeteerScraperWrapper,
    required InkPuppeteerScraperWrapper inkPuppeteerScraperWrapper,
  }) : _narancaPuppeteerScraperWrapper = narancaPuppeteerScraperWrapper,
       _gkpuPuppeteerScraperWrapper = gkpuPuppeteerScraperWrapper,
       _inkPuppeteerScraperWrapper = inkPuppeteerScraperWrapper;

  // TODO this could accept some kind of reporting service to log potential errors
  final NarancaPuppeteerScraperWrapper _narancaPuppeteerScraperWrapper;
  final GkpuPuppeteerScraperWrapper _gkpuPuppeteerScraperWrapper;
  final InkPuppeteerScraperWrapper _inkPuppeteerScraperWrapper;

  @override
  Future<Set<ScrapedEventEntity>> getInkEvents() async {
    _printStartScrapeMessage(
      name: _inkPuppeteerScraperWrapper.name,
      uri: _inkPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _inkPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _inkPuppeteerScraperWrapper.name,
        uri: _inkPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _inkPuppeteerScraperWrapper.name,
        uri: _inkPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getNarancaEvents() async {
    _printStartScrapeMessage(
      name: _narancaPuppeteerScraperWrapper.name,
      uri: _narancaPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _narancaPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _narancaPuppeteerScraperWrapper.name,
        uri: _narancaPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _narancaPuppeteerScraperWrapper.name,
        uri: _narancaPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getGkpuEvents() async {
    _printStartScrapeMessage(
      name: _gkpuPuppeteerScraperWrapper.name,
      uri: _gkpuPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _gkpuPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _gkpuPuppeteerScraperWrapper.name,
        uri: _gkpuPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _gkpuPuppeteerScraperWrapper.name,
        uri: _gkpuPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

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
    required StackTrace stackTrace,
  }) {
    print(
      "Failed scraping of events from $name at $uri, with error: $error and stacktrace: $stackTrace",
    );
  }
}
