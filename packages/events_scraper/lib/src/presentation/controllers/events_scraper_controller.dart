import 'package:event_scraper/src/domain/use_cases/load_gkpu_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_ink_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_naranca_events_use_case.dart';

class EventsScraperController {
  EventsScraperController({
    required LoadNarancaEventsUseCase loadNarancaEventsUseCase,
    required LoadGkpuEventsUseCase loadGkpuEventsUseCase,
    required LoadInkEventsUseCase loadInkEventsUseCase,
  }) : _loadNarancaEventsUseCase = loadNarancaEventsUseCase,
       _loadGkpuEventsUseCase = loadGkpuEventsUseCase,
       _loadInkEventsUseCase = loadInkEventsUseCase;

  final LoadNarancaEventsUseCase _loadNarancaEventsUseCase;
  final LoadGkpuEventsUseCase _loadGkpuEventsUseCase;
  final LoadInkEventsUseCase _loadInkEventsUseCase;

  Future<void> run() async {
    try {
      await _loadNarancaEventsUseCase();
      await _loadGkpuEventsUseCase();
      await _loadInkEventsUseCase();
    } catch (e) {
      print("Failed scraping of events with error: $e");
    }
  }
}
