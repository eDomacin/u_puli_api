import 'package:database_wrapper/database_wrapper.dart';
import 'package:env_vars_wrapper/env_vars_wrapper.dart';
import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source_impl.dart';
import 'package:event_scraper/src/data/data_sources/events_storer/events_storer_data_source.dart';
import 'package:event_scraper/src/data/data_sources/events_storer/events_storer_data_source_impl.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository_impl.dart';
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
import 'package:event_scraper/src/events_scraper.dart';
import 'package:event_scraper/src/presentation/controllers/events_scraper_controller.dart';
import 'package:event_scraper/src/wrappers/puppeteer/eventim_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/gkpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/hnl_puppeteer_scraper_wraper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/ink_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/kotac_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/naranca_puppeteer_scrapper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/pdpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/pulainfo_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/rojc_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/sp_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/valli_puppeteer_scraper_wrapper.dart';

Future<void> runEventsScraper() async {
  final EnvVarsWrapper envVarsWrapper = EnvVarsWrapper();
  final DatabaseWrapper databaseWrapper = _getInitializedDatabaseWrapper(
    envVarsWrapper: envVarsWrapper,
  );
  final EventsScraperController eventsScraperController =
      _getInitializedEventsScraperController(databaseWrapper: databaseWrapper);

  final EventsScraper eventsScraper = EventsScraper(
    eventsScraperController: eventsScraperController,
  );

  // TODO give some time to the database to initialize
  await Future.delayed(const Duration(seconds: 5));

  await eventsScraper.run();

  await databaseWrapper.close();
}

DatabaseWrapper _getInitializedDatabaseWrapper({
  required EnvVarsWrapper envVarsWrapper,
}) {
  final databaseWrapper = DatabaseWrapper.app(
    endpointData: DatabaseEndpointDataValue(
      pgHost: envVarsWrapper.pgHost,
      pgDatabase: envVarsWrapper.pgDatabase,
      pgUser: envVarsWrapper.pgUser,
      pgPassword: envVarsWrapper.pgPassword,
      pgPort: envVarsWrapper.pgPort,
    ),
  );

  databaseWrapper.initialize();

  return databaseWrapper;
}

// TODO separate this for different dependency types, or use some DI
EventsScraperController _getInitializedEventsScraperController({
  required DatabaseWrapper databaseWrapper,
}) {
  // puppeteer wrappers
  final NarancaPuppeteerScraperWrapper narancaPuppeteerScraperWrapper =
      NarancaPuppeteerScraperWrapper();
  final GkpuPuppeteerScraperWrapper gkpuPuppeteerScraperWrapper =
      GkpuPuppeteerScraperWrapper();
  final InkPuppeteerScraperWrapper inkPuppeteerScraperWrapper =
      InkPuppeteerScraperWrapper();
  final KotacPuppeteerScraperWrapper kotacPuppeteerScraperWrapper =
      KotacPuppeteerScraperWrapper();
  final RojcPuppeteerScraperWrapper rojcPuppeteerScraperWrapper =
      RojcPuppeteerScraperWrapper();
  final PDPUPuppeteerScrapperWrapper pdpuPuppeteerScrapperWrapper =
      PDPUPuppeteerScrapperWrapper();
  final HnlPuppeteerScraperWrapper hnlPuppeteerScrapperWrapper =
      HnlPuppeteerScraperWrapper();
  final SpPuppeteerScraperWrapper spPuppeteerScraperWrapper =
      SpPuppeteerScraperWrapper();
  final PulainfoPuppeteerScraperWrapper pulainfoPuppeteerScraperWrapper =
      PulainfoPuppeteerScraperWrapper();
  final EventimPuppeteerScraperWrapper eventimPuppeteerScraperWrapper =
      EventimPuppeteerScraperWrapper();
  final ValliPuppeteerScraperWrapper valliPuppeteerScraperWrapper =
      ValliPuppeteerScraperWrapper();

  // data sources
  final EventsScraperDataSource eventsScraperDataSource =
      EventsScraperDataSourceImpl(
        narancaPuppeteerScraperWrapper: narancaPuppeteerScraperWrapper,
        gkpuPuppeteerScraperWrapper: gkpuPuppeteerScraperWrapper,
        inkPuppeteerScraperWrapper: inkPuppeteerScraperWrapper,
        kotacPuppeteerScraperWrapper: kotacPuppeteerScraperWrapper,
        rojcPuppeteerScraperWrapper: rojcPuppeteerScraperWrapper,
        pdpuPuppeteerScrapperWrapper: pdpuPuppeteerScrapperWrapper,
        hnlPuppeteerScrapperWrapper: hnlPuppeteerScrapperWrapper,
        spPuppeteerScraperWrapper: spPuppeteerScraperWrapper,
        pulainfoPuppeteerScraperWrapper: pulainfoPuppeteerScraperWrapper,
        eventimPuppeteerScraperWrapper: eventimPuppeteerScraperWrapper,
        valliPuppeteerScraperWrapper: valliPuppeteerScraperWrapper,
      );

  final EventsStorerDataSource eventsStorerDataSource =
      EventsStorerDataSourceImpl(databaseWrapper: databaseWrapper);

  // repositories
  final EventsLoaderRepository eventsLoaderRepository =
      EventsLoaderRepositoryImpl(
        eventsScraperDataSource: eventsScraperDataSource,
        eventsStorerDataSource: eventsStorerDataSource,
      );

  // use cases
  final LoadNarancaEventsUseCase loadNarancaEventsUseCase =
      LoadNarancaEventsUseCase(eventsLoaderRepository: eventsLoaderRepository);
  final LoadGkpuEventsUseCase loadGkpuEventsUseCase = LoadGkpuEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );
  final LoadInkEventsUseCase loadInkEventsUseCase = LoadInkEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );
  final LoadKotacEventsUseCase loadKotacEventsUseCase = LoadKotacEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );
  final LoadRojcEventsUseCase loadRojcEventsUseCase = LoadRojcEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );
  final LoadPDPUEventsUseCase loadPDPUEventsUseCase = LoadPDPUEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );
  final LoadHnlEventsUseCase loadHnlEventsUseCase = LoadHnlEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );
  final LoadSpEventsUseCase loadSpEventsUseCase = LoadSpEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );
  final LoadPulainfoEventsUseCase loadPulainfoEventsUseCase =
      LoadPulainfoEventsUseCase(eventsLoaderRepository: eventsLoaderRepository);
  final LoadEventimEventsUseCase loadEventimEventsUseCase =
      LoadEventimEventsUseCase(eventsLoaderRepository: eventsLoaderRepository);
  final LoadValliEventsUseCase loadValliEventsUseCase = LoadValliEventsUseCase(
    eventsLoaderRepository: eventsLoaderRepository,
  );

  // controller
  final EventsScraperController eventsScraperController =
      EventsScraperController(
        loadNarancaEventsUseCase: loadNarancaEventsUseCase,
        loadGkpuEventsUseCase: loadGkpuEventsUseCase,
        loadInkEventsUseCase: loadInkEventsUseCase,
        loadKotacEventsUseCase: loadKotacEventsUseCase,
        loadRojcEventsUseCase: loadRojcEventsUseCase,
        loadPDPUEventsUseCase: loadPDPUEventsUseCase,
        loadHnlEventsUseCase: loadHnlEventsUseCase,
        loadSpEventsUseCase: loadSpEventsUseCase,
        loadPulainfoEventsUseCase: loadPulainfoEventsUseCase,
        loadEventimEventsUseCase: loadEventimEventsUseCase,
        loadValliEventsUseCase: loadValliEventsUseCase,
      );

  return eventsScraperController;
}
