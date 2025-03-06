import 'package:database_wrapper/database_wrapper.dart';
import 'package:env_vars_wrapper/env_vars_wrapper.dart';
import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source.dart';
import 'package:event_scraper/src/data/data_sources/events_scraper/events_scraper_data_source_impl.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';
import 'package:event_scraper/src/domain/repositories/events_loader_repository_impl.dart';
import 'package:event_scraper/src/domain/use_cases/load_naranca_events_use_case.dart';
import 'package:event_scraper/src/presentation/controllers/events_scraper_controller.dart';
import 'package:event_scraper/src/wrappers/puppeteer/naranca_puppeteer_scrapper_wrapper.dart';

class EventsScraper {
  const EventsScraper({
    required EventsScraperController eventsScraperController,
  }) : _eventsScraperController = eventsScraperController;

  // late final DatabaseWrapper _databaseWrapper;
  final EventsScraperController _eventsScraperController;

  /// Initializes the [EventsScraper].
  ///
  /// Make sure to call this method before using the [EventsScraper].
  // void initialize() {
  //   _databaseWrapper = _getInitializedDatabaseWrapper();
  //   _eventsScraperController = _getInitializedEventsScraperController();
  // }

  /// Runs the [EventsScraper].
  ///
  /// This method will scrape the events from the data sources and store them in the database.
  Future<void> run() async {
    print('Running events scraper');
    await _eventsScraperController.run();
  }

  /// Disposes of the resources used by the [EventsScraper].
  ///
  /// Make sure to call this method when you're done using the [EventsScraper].
  // Future<void> dispose() async {
  //   await _databaseWrapper.driftWrapper.close();
  // }

  // DatabaseWrapper _getInitializedDatabaseWrapper() {
  //   final envVarsWrapper = EnvVarsWrapper();

  //   final databaseWrapper = DatabaseWrapper.app(
  //     endpointData: DatabaseEndpointDataValue(
  //       pgHost: envVarsWrapper.pgHost,
  //       pgDatabase: envVarsWrapper.pgDatabase,
  //       pgUser: envVarsWrapper.pgUser,
  //       pgPassword: envVarsWrapper.pgPassword,
  //       pgPort: envVarsWrapper.pgPort,
  //     ),
  //   );

  //   databaseWrapper.initialize();

  //   return databaseWrapper;
  // }

  // EventsScraperController _getInitializedEventsScraperController() {
  //   // puppeteer wrappers
  //   final NarancaPuppeteerScraperWrapper narancaPuppeteerScraperWrapper =
  //       NarancaPuppeteerScraperWrapper();

  //   // data sources
  //   final EventsScraperDataSource eventsScraperDataSource =
  //       EventsScraperDataSourceImpl(
  //         narancaPuppeteerScraperWrapper: narancaPuppeteerScraperWrapper,
  //       );

  //   // repositories
  //   final EventsLoaderRepository eventsLoaderRepository =
  //       EventsLoaderRepositoryImpl(
  //         eventsScraperDataSource: eventsScraperDataSource,
  //       );

  //   // use cases
  //   final LoadNarancaEventsUseCase loadNarancaEventsUseCase =
  //       LoadNarancaEventsUseCase(
  //         eventsLoaderRepository: eventsLoaderRepository,
  //       );

  //   // controller
  //   final EventsScraperController eventsScraperController =
  //       EventsScraperController(
  //         loadNarancaEventsUseCase: loadNarancaEventsUseCase,
  //       );

  //   return eventsScraperController;
  // }
}
