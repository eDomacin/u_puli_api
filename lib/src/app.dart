import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:u_puli_api/src/app_router.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source_impl.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository_impl.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/get_event_use_case.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/get_events_use_case.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_event_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_events_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/router/events_router.dart';

class App {
  // Use any available host or container IP (usually `0.0.0.0`).
  final InternetAddress ip = InternetAddress.anyIPv4;
  final int port = int.parse(Platform.environment['PORT'] ?? '8080');

  final AppRouter appRouter = _getInitializedAppRouter();

  Future<HttpServer> start() async {
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addHandler(appRouter.router.call);

    final server = await serve(handler, ip, port);
    return server;
  }
}

AppRouter _getInitializedAppRouter() {
  // data surces
  final EventsDataSource eventsDataSource = EventsDataSourceImpl();

  // repositories
  final EventsRepository eventsRepository =
      EventsRepositoryImpl(eventsDataSource: eventsDataSource);

  // use cases
  final GetEventUseCase getEventUseCase =
      GetEventUseCase(eventsRepository: eventsRepository);
  final GetEventsUseCase getEventsUseCase =
      GetEventsUseCase(eventsRepository: eventsRepository);

  // controllers
  final GetEventController getEventController = GetEventController(
    getEventUseCase: getEventUseCase,
  );
  final GetEventsController getEventsController =
      GetEventsController(getEventsUseCase: getEventsUseCase);

  final EventsRouter eventsRouter = EventsRouter(
    getEventController: getEventController,
    getEventsController: getEventsController,
  );

  final AppRouter appRouter = AppRouter(eventsRouter: eventsRouter);

  return appRouter;
}
