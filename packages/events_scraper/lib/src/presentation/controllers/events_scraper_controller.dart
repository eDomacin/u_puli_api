import 'package:event_scraper/src/domain/use_cases/load_gkpu_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_ink_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_kotac_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_naranca_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_rojc_events_use_case.dart';

class EventsScraperController {
  EventsScraperController({
    required LoadNarancaEventsUseCase loadNarancaEventsUseCase,
    required LoadGkpuEventsUseCase loadGkpuEventsUseCase,
    required LoadInkEventsUseCase loadInkEventsUseCase,
    required LoadKotacEventsUseCase loadKotacEventsUseCase,
    required LoadRojcEventsUseCase loadRojcEventsUseCase,
  }) : _loadNarancaEventsUseCase = loadNarancaEventsUseCase,
       _loadGkpuEventsUseCase = loadGkpuEventsUseCase,
       _loadInkEventsUseCase = loadInkEventsUseCase,
       _loadKotacEventsUseCase = loadKotacEventsUseCase,
       _loadRojcEventsUseCase = loadRojcEventsUseCase;

  final LoadNarancaEventsUseCase _loadNarancaEventsUseCase;
  final LoadGkpuEventsUseCase _loadGkpuEventsUseCase;
  final LoadInkEventsUseCase _loadInkEventsUseCase;
  final LoadKotacEventsUseCase _loadKotacEventsUseCase;
  final LoadRojcEventsUseCase _loadRojcEventsUseCase;

  Future<void> run() async {
    await _handleLoadNarancaEvents();
    await _handleLoadGkpuEvents();
    await _handleLoadInkEvents();
    await _handleLoadKotacEvents();
    await _handleLoadRojcEvents();
  }

  // TODO maybe this can be unified somehow - but i want to be able to log which one failed - so need some field on the use case, if possile
  Future<void> _handleLoadNarancaEvents() async {
    try {
      await _loadNarancaEventsUseCase();
    } catch (e) {
      print("Failed scraping Naranca events with error: $e");
    }
  }

  Future<void> _handleLoadGkpuEvents() async {
    try {
      await _loadGkpuEventsUseCase();
    } catch (e) {
      print("Failed scraping GKPU events with error: $e");
    }
  }

  Future<void> _handleLoadInkEvents() async {
    try {
      await _loadInkEventsUseCase();
    } catch (e) {
      print("Failed scraping Ink events with error: $e");
    }
  }

  Future<void> _handleLoadKotacEvents() async {
    try {
      await _loadKotacEventsUseCase();
    } catch (e) {
      print("Failed scraping Kotac events with error: $e");
    }
  }

  Future<void> _handleLoadRojcEvents() async {
    try {
      await _loadRojcEventsUseCase();
    } catch (e) {
      print("Failed scraping Rojc events with error: $e");
    }
  }
}
