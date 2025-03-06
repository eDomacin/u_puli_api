import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';

class EventsLoaderRepositoryImpl implements EventsLoaderRepository {
  const EventsLoaderRepositoryImpl({
    required EventsScraperDataSource eventsScraperDataSource,
  }) : _eventsScraperDataSource = eventsScraperDataSource;

  final EventsScraperDataSource _eventsScraperDataSource;

  @override
  Future<void> loadNarancaEvents() async {
    final Set<ScrapedEventEntity> events =
        await _eventsScraperDataSource.getNarancaEvents();

    print(events);

    // TODO will be storing it from here
  }
}
