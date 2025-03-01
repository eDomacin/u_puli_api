import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:u_puli_api/src/app_router.dart';

class App {
  // Use any available host or container IP (usually `0.0.0.0`).
  final InternetAddress ip = InternetAddress.anyIPv4;
  final int port = int.parse(Platform.environment['PORT'] ?? '8080');
  final AppRouter appRouter = AppRouter();

  Future<HttpServer> start() async {
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addHandler(appRouter.router.call);

    final server = await serve(handler, ip, port);
    return server;
  }
}
