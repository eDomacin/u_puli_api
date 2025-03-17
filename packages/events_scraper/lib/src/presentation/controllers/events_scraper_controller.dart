import 'package:event_scraper/src/domain/use_cases/load_gkpu_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_ink_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_kotac_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_naranca_events_use_case.dart';

class EventsScraperController {
  EventsScraperController({
    required LoadNarancaEventsUseCase loadNarancaEventsUseCase,
    required LoadGkpuEventsUseCase loadGkpuEventsUseCase,
    required LoadInkEventsUseCase loadInkEventsUseCase,
    required LoadKotacEventsUseCase loadKotacEventsUseCase,
  }) : _loadNarancaEventsUseCase = loadNarancaEventsUseCase,
       _loadGkpuEventsUseCase = loadGkpuEventsUseCase,
       _loadInkEventsUseCase = loadInkEventsUseCase,
       _loadKotacEventsUseCase = loadKotacEventsUseCase;

  final LoadNarancaEventsUseCase _loadNarancaEventsUseCase;
  final LoadGkpuEventsUseCase _loadGkpuEventsUseCase;
  final LoadInkEventsUseCase _loadInkEventsUseCase;
  final LoadKotacEventsUseCase _loadKotacEventsUseCase;

  Future<void> run() async {
    try {
      await _loadNarancaEventsUseCase();
      await _loadGkpuEventsUseCase();
      await _loadInkEventsUseCase();
      await _loadKotacEventsUseCase();
    } catch (e) {
      print("Failed scraping of events with error: $e");
    }
  }
}
