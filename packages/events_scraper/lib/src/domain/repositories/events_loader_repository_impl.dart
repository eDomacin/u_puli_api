import 'package:database_wrapper/database_wrapper.dart' hide EventsConverter;
import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/data_sources/events_storer/events_storer_data_source.dart';
import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';
import 'package:event_scraper/src/utils/converters/events_converter.dart';

class EventsLoaderRepositoryImpl implements EventsLoaderRepository {
  const EventsLoaderRepositoryImpl({
    required EventsScraperDataSource eventsScraperDataSource,
    required EventsStorerDataSource eventsStorerDataSource,
  }) : _eventsScraperDataSource = eventsScraperDataSource,
       _eventsStorerDataSource = eventsStorerDataSource;

  final EventsScraperDataSource _eventsScraperDataSource;
  final EventsStorerDataSource _eventsStorerDataSource;

  @override
  Future<void> loadKotacEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getKotacEvents();

    print("Scraped event entities: $events");

    final List<StoreEventEntityValue> storeEntityValues =
        EventsConverter.storeEntityValuesFromScrapedEntities(
          scrapedEventEntities: events,
        );

    await _eventsStorerDataSource.storeEvents(storeEntityValues);

    print("Stored event entities: $storeEntityValues");
  }

  @override
  Future<void> loadInkEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getInkEvents();

    print("Scraped event entities: $events");

    final List<StoreEventEntityValue> storeEntityValues =
        EventsConverter.storeEntityValuesFromScrapedEntities(
          scrapedEventEntities: events,
        );

    await _eventsStorerDataSource.storeEvents(storeEntityValues);

    print("Stored event entities: $storeEntityValues");
  }

  @override
  Future<void> loadNarancaEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getNarancaEvents();

    print("Scraped event entities: $events");

    final List<StoreEventEntityValue> storeEntityValues =
        EventsConverter.storeEntityValuesFromScrapedEntities(
          scrapedEventEntities: events,
        );

    await _eventsStorerDataSource.storeEvents(storeEntityValues);

    print("Stored event entities: $storeEntityValues");
  }

  @override
  Future<void> loadGkpuEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getGkpuEvents();

    print("Scraped event entities: $events");

    final List<StoreEventEntityValue> storeEntityValues =
        EventsConverter.storeEntityValuesFromScrapedEntities(
          scrapedEventEntities: events,
        );

    await _eventsStorerDataSource.storeEvents(storeEntityValues);

    print("Stored event entities: $storeEntityValues");
  }

  @override
  Future<void> loadRojcEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getRojcEvents();

    print("Scraped event entities: $events");

    final List<StoreEventEntityValue> storeEntityValues =
        EventsConverter.storeEntityValuesFromScrapedEntities(
          scrapedEventEntities: events,
        );

    await _eventsStorerDataSource.storeEvents(storeEntityValues);

    print("Stored event entities: $storeEntityValues");
  }

  @override
  Future<void> loadPDPUEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getPDPUEvents();

    print("Scraped event entities: $events");

    final List<StoreEventEntityValue> storeEntityValues =
        EventsConverter.storeEntityValuesFromScrapedEntities(
          scrapedEventEntities: events,
        );

    await _eventsStorerDataSource.storeEvents(storeEntityValues);

    print("Stored event entities: $storeEntityValues");
  }

  @override
  Future<void> loadHnlEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getHnlEvents();

    print("Scraped event entities: $events");

    final List<StoreEventEntityValue> storeEntityValues =
        EventsConverter.storeEntityValuesFromScrapedEntities(
          scrapedEventEntities: events,
        );

    await _eventsStorerDataSource.storeEvents(storeEntityValues);

    print("Stored event entities: $storeEntityValues");
  }
}
