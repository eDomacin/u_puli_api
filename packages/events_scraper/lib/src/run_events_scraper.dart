import 'package:database_wrapper/database_wrapper.dart';
import 'package:env_vars_wrapper/env_vars_wrapper.dart';
import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source_impl.dart';
import 'package:event_scraper/src/data/data_sources/events_storer/events_storer_data_source.dart';
import 'package:event_scraper/src/data/data_sources/events_storer/events_storer_data_source_impl.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository_impl.dart';
import 'package:event_scraper/src/domain/use_cases/load_gkpu_events_use_case.dart';
import 'package:event_scraper/src/domain/use_cases/load_naranca_events_use_case.dart';
import 'package:event_scraper/src/events_scraper.dart';
import 'package:event_scraper/src/presentation/controllers/events_scraper_controller.dart';
import 'package:event_scraper/src/wrappers/puppeteer/gkpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/naranca_puppeteer_scrapper_wrapper.dart';

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

  // data sources
  final EventsScraperDataSource eventsScraperDataSource =
      EventsScraperDataSourceImpl(
        narancaPuppeteerScraperWrapper: narancaPuppeteerScraperWrapper,
        gkpuPuppeteerScraperWrapper: gkpuPuppeteerScraperWrapper,
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

  // controller
  final EventsScraperController eventsScraperController =
      EventsScraperController(
        loadNarancaEventsUseCase: loadNarancaEventsUseCase,
        loadGkpuEventsUseCase: loadGkpuEventsUseCase,
      );

  return eventsScraperController;
}
