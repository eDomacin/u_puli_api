import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:u_puli_api/src/app_router.dart';
import 'package:u_puli_api/src/wrappers/middleware/cors_middleware_wrapper_impl.dart';

class App {
  App({required this.ip, required this.port, required AppRouter appRouter})
    : _appRouter = appRouter;

  final AppRouter _appRouter;
  final InternetAddress ip;
  final int port;

  final CorsMiddlewareWrapper _corsMiddlewareWrapper = CorsMiddlewareWrapper();

  Future<HttpServer> start() async {
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_corsMiddlewareWrapper.middleware)
        .addHandler(_appRouter.router.call);

    final server = await serve(handler, ip, port);
    return server;
  }
}
