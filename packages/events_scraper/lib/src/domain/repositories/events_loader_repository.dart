import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';

abstract class EventsLoaderRepository {
  Future<void> loadNarancaEvents();
}
