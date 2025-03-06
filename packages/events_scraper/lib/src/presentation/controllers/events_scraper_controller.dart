import 'package:event_scraper/src/domain/use_cases/load_naranca_events_use_case.dart';

class EventsScraperController {
  EventsScraperController({
    required LoadNarancaEventsUseCase loadNarancaEventsUseCase,
  }) : _loadNarancaEventsUseCase = loadNarancaEventsUseCase;

  final LoadNarancaEventsUseCase _loadNarancaEventsUseCase;

  Future<void> run() async {
    try {
      await _loadNarancaEventsUseCase();
    } catch (e) {
      print("Failed scraping of events with error: $e");
    }
  }
}
