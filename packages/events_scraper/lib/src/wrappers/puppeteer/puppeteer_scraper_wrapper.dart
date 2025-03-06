import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';

abstract class PuppeteerScraperWrapper {
  abstract final Uri uri;
  abstract final String name;
  Future<Set<ScrapedEventEntity>> getEvents();
}
