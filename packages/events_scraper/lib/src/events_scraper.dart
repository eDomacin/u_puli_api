import 'package:event_scraper/src/presentation/controllers/events_scraper_controller.dart';

class EventsScraper {
  const EventsScraper({
    required EventsScraperController eventsScraperController,
  }) : _eventsScraperController = eventsScraperController;

  final EventsScraperController _eventsScraperController;

  /// Runs the [EventsScraper].
  ///
  /// This method will scrape the events from the data sources and store them in the database.
  Future<void> run() async {
    print('Running events scraper');
    await _eventsScraperController.run();
  }
}
