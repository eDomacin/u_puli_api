import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/wrappers/puppeteer/eventim_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/gkpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/hnl_puppeteer_scraper_wraper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/ink_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/kotac_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/naranca_puppeteer_scrapper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/pdpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/pulainfo_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/rojc_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/sp_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/valli_puppeteer_scraper_wrapper.dart';

class EventsScraperDataSourceImpl implements EventsScraperDataSource {
  const EventsScraperDataSourceImpl({
    required NarancaPuppeteerScraperWrapper narancaPuppeteerScraperWrapper,
    required GkpuPuppeteerScraperWrapper gkpuPuppeteerScraperWrapper,
    required InkPuppeteerScraperWrapper inkPuppeteerScraperWrapper,
    required KotacPuppeteerScraperWrapper kotacPuppeteerScraperWrapper,
    required RojcPuppeteerScraperWrapper rojcPuppeteerScraperWrapper,
    required PDPUPuppeteerScrapperWrapper pdpuPuppeteerScrapperWrapper,
    required HnlPuppeteerScraperWrapper hnlPuppeteerScrapperWrapper,
    required SpPuppeteerScraperWrapper spPuppeteerScraperWrapper,
    required PulainfoPuppeteerScraperWrapper pulainfoPuppeteerScraperWrapper,
    required EventimPuppeteerScraperWrapper eventimPuppeteerScraperWrapper,
    required ValliPuppeteerScraperWrapper valliPuppeteerScraperWrapper,
  }) : _narancaPuppeteerScraperWrapper = narancaPuppeteerScraperWrapper,
       _gkpuPuppeteerScraperWrapper = gkpuPuppeteerScraperWrapper,
       _inkPuppeteerScraperWrapper = inkPuppeteerScraperWrapper,
       _kotacPuppeteerScraperWrapper = kotacPuppeteerScraperWrapper,
       _rojcPuppeteerScraperWrapper = rojcPuppeteerScraperWrapper,
       _pdpuPuppeteerScrapperWrapper = pdpuPuppeteerScrapperWrapper,
       _hnlPuppeteerScrapperWrapper = hnlPuppeteerScrapperWrapper,
       _spPuppeteerScraperWrapper = spPuppeteerScraperWrapper,
       _pulainfoPuppeteerScraperWrapper = pulainfoPuppeteerScraperWrapper,
       _eventimPuppeteerScraperWrapper = eventimPuppeteerScraperWrapper,
       _valliPuppeteerScraperWrapper = valliPuppeteerScraperWrapper;

  // TODO this could accept some kind of reporting service to log potential errors
  final NarancaPuppeteerScraperWrapper _narancaPuppeteerScraperWrapper;
  final GkpuPuppeteerScraperWrapper _gkpuPuppeteerScraperWrapper;
  final InkPuppeteerScraperWrapper _inkPuppeteerScraperWrapper;
  final KotacPuppeteerScraperWrapper _kotacPuppeteerScraperWrapper;
  final RojcPuppeteerScraperWrapper _rojcPuppeteerScraperWrapper;
  final PDPUPuppeteerScrapperWrapper _pdpuPuppeteerScrapperWrapper;
  final HnlPuppeteerScraperWrapper _hnlPuppeteerScrapperWrapper;
  final SpPuppeteerScraperWrapper _spPuppeteerScraperWrapper;
  final PulainfoPuppeteerScraperWrapper _pulainfoPuppeteerScraperWrapper;
  final EventimPuppeteerScraperWrapper _eventimPuppeteerScraperWrapper;
  final ValliPuppeteerScraperWrapper _valliPuppeteerScraperWrapper;

  @override
  Future<Set<ScrapedEventEntity>> getKotacEvents() async {
    _printStartScrapeMessage(
      name: _kotacPuppeteerScraperWrapper.name,
      uri: _kotacPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _kotacPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _kotacPuppeteerScraperWrapper.name,
        uri: _kotacPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _kotacPuppeteerScraperWrapper.name,
        uri: _kotacPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

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

  @override
  Future<Set<ScrapedEventEntity>> getRojcEvents() async {
    _printStartScrapeMessage(
      name: _rojcPuppeteerScraperWrapper.name,
      uri: _rojcPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _rojcPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _rojcPuppeteerScraperWrapper.name,
        uri: _rojcPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _rojcPuppeteerScraperWrapper.name,
        uri: _rojcPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getPDPUEvents() async {
    _printStartScrapeMessage(
      name: _pdpuPuppeteerScrapperWrapper.name,
      uri: _pdpuPuppeteerScrapperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _pdpuPuppeteerScrapperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _pdpuPuppeteerScrapperWrapper.name,
        uri: _pdpuPuppeteerScrapperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _pdpuPuppeteerScrapperWrapper.name,
        uri: _pdpuPuppeteerScrapperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getHnlEvents() async {
    _printStartScrapeMessage(
      name: _hnlPuppeteerScrapperWrapper.name,
      uri: _hnlPuppeteerScrapperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _hnlPuppeteerScrapperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _hnlPuppeteerScrapperWrapper.name,
        uri: _hnlPuppeteerScrapperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _hnlPuppeteerScrapperWrapper.name,
        uri: _hnlPuppeteerScrapperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getSpEvents() async {
    _printStartScrapeMessage(
      name: _spPuppeteerScraperWrapper.name,
      uri: _spPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _spPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _spPuppeteerScraperWrapper.name,
        uri: _spPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _spPuppeteerScraperWrapper.name,
        uri: _spPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getPulainfoEvents() async {
    _printStartScrapeMessage(
      name: _pulainfoPuppeteerScraperWrapper.name,
      uri: _pulainfoPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _pulainfoPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _pulainfoPuppeteerScraperWrapper.name,
        uri: _pulainfoPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _pulainfoPuppeteerScraperWrapper.name,
        uri: _pulainfoPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getEventimEvents() async {
    _printStartScrapeMessage(
      name: _eventimPuppeteerScraperWrapper.name,
      uri: _eventimPuppeteerScraperWrapper.uri,
    );

    try {
      final Set<ScrapedEventEntity> events =
          await _eventimPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _eventimPuppeteerScraperWrapper.name,
        uri: _eventimPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _eventimPuppeteerScraperWrapper.name,
        uri: _eventimPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }

  @override
  Future<Set<ScrapedEventEntity>> getValliEvents() async {
    _printStartScrapeMessage(
      name: _valliPuppeteerScraperWrapper.name,
      uri: _valliPuppeteerScraperWrapper.uri,
    );
    try {
      final Set<ScrapedEventEntity> events =
          await _valliPuppeteerScraperWrapper.getEvents();

      _printFinishScrapeMessage(
        name: _valliPuppeteerScraperWrapper.name,
        uri: _valliPuppeteerScraperWrapper.uri,
      );

      return events;
    } catch (e, s) {
      _printFailedScrapeMessage(
        name: _valliPuppeteerScraperWrapper.name,
        uri: _valliPuppeteerScraperWrapper.uri,
        error: e.toString(),
        stackTrace: s,
      );

      return <ScrapedEventEntity>{};
    }
  }
}
