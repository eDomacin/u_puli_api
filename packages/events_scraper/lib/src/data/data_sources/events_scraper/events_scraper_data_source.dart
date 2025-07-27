import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';

abstract interface class EventsScraperDataSource {
  Future<Set<ScrapedEventEntity>> getNarancaEvents();
  Future<Set<ScrapedEventEntity>> getGkpuEvents();
  Future<Set<ScrapedEventEntity>> getInkEvents();
  Future<Set<ScrapedEventEntity>> getKotacEvents();
  Future<Set<ScrapedEventEntity>> getRojcEvents();
  Future<Set<ScrapedEventEntity>> getPDPUEvents();
  Future<Set<ScrapedEventEntity>> getHnlEvents();
}
