import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:u_puli_api/src/app_router.dart';
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
  final EventsRouter eventsRouter = EventsRouter();

  final AppRouter appRouter = AppRouter(eventsRouter: eventsRouter);

  return appRouter;
}
