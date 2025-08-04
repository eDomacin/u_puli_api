import 'package:event_scraper/src/domain/use_cases/load_eventim_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_gkpu_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_hnl_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_ink_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_kotac_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_naranca_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_pdpu_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_pulainfo_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_rojc_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_sp_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_valli_events_use_case.dart';

class EventsScraperController {
  EventsScraperController({
    required LoadNarancaEventsUseCase loadNarancaEventsUseCase,
    required LoadGkpuEventsUseCase loadGkpuEventsUseCase,
    required LoadInkEventsUseCase loadInkEventsUseCase,
    required LoadKotacEventsUseCase loadKotacEventsUseCase,
    required LoadRojcEventsUseCase loadRojcEventsUseCase,
    required LoadPDPUEventsUseCase loadPDPUEventsUseCase,
    required LoadHnlEventsUseCase loadHnlEventsUseCase,
    required LoadSpEventsUseCase loadSpEventsUseCase,
    required LoadPulainfoEventsUseCase loadPulainfoEventsUseCase,
    required LoadEventimEventsUseCase loadEventimEventsUseCase,
    required LoadValliEventsUseCase loadValliEventsUseCase,
  }) : _loadNarancaEventsUseCase = loadNarancaEventsUseCase,
       _loadGkpuEventsUseCase = loadGkpuEventsUseCase,
       _loadInkEventsUseCase = loadInkEventsUseCase,
       _loadKotacEventsUseCase = loadKotacEventsUseCase,
       _loadRojcEventsUseCase = loadRojcEventsUseCase,
       _loadHnlEventsUseCase = loadHnlEventsUseCase,
       _loadPDPUEventsUseCase = loadPDPUEventsUseCase,
       _loadSpEventsUseCase = loadSpEventsUseCase,
       _loadPulainfoEventsUseCase = loadPulainfoEventsUseCase,
       _loadEventimEventsUseCase = loadEventimEventsUseCase,
       _loadValliEventsUseCase = loadValliEventsUseCase;

  final LoadNarancaEventsUseCase _loadNarancaEventsUseCase;
  final LoadGkpuEventsUseCase _loadGkpuEventsUseCase;
  final LoadInkEventsUseCase _loadInkEventsUseCase;
  final LoadKotacEventsUseCase _loadKotacEventsUseCase;
  final LoadRojcEventsUseCase _loadRojcEventsUseCase;
  final LoadPDPUEventsUseCase _loadPDPUEventsUseCase;
  final LoadHnlEventsUseCase _loadHnlEventsUseCase;
  final LoadSpEventsUseCase _loadSpEventsUseCase;
  final LoadPulainfoEventsUseCase _loadPulainfoEventsUseCase;
  final LoadEventimEventsUseCase _loadEventimEventsUseCase;
  final LoadValliEventsUseCase _loadValliEventsUseCase;

  Future<void> run() async {
    /* TODO maaybe not even these from aggregators - lets collect directly from institutions */
    await _handleLoadNarancaEvents();
    await _handleLoadGkpuEvents();
    await _handleLoadInkEvents();
    await _handleLoadKotacEvents();
    await _handleLoadRojcEvents();
    await _handleLoadHnlEvents();
    await _handleLoadSpEvents();
    await _handleLoadPDPUEvents();
    await _handleLoadValliEvents();
    /* TODO not scraping this because it is also an aggregator */
    // await _handleLoadEventimEvents();
    // await _handleLoadPulainfoEvents();
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

  Future<void> _handleLoadPDPUEvents() async {
    try {
      await _loadPDPUEventsUseCase();
    } catch (e) {
      print("Failed scraping PDPU events with error: $e");
    }
  }

  Future<void> _handleLoadHnlEvents() async {
    try {
      await _loadHnlEventsUseCase();
    } catch (e) {
      print("Failed scraping HNL events with error: $e");
    }
  }

  Future<void> _handleLoadSpEvents() async {
    try {
      await _loadSpEventsUseCase();
    } catch (e) {
      print("Failed scraping SP events with error: $e");
    }
  }

  Future<void> _handleLoadValliEvents() async {
    try {
      await _loadValliEventsUseCase();
    } catch (e) {
      print("Failed scraping Valli events with error: $e");
    }
  }

  Future<void> _handleLoadPulainfoEvents() async {
    try {
      await _loadPulainfoEventsUseCase();
    } catch (e) {
      print("Failed scraping Pulainfo events with error: $e");
    }
  }

  Future<void> _handleLoadEventimEvents() async {
    try {
      await _loadEventimEventsUseCase();
    } catch (e) {
      print("Failed scraping Eventim events with error: $e");
    }
  }
}
