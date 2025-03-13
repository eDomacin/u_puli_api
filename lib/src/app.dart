import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:u_puli_api/src/app_router.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/middleware/create_middleware_helper/cors_create_middleware_helper.dart';

class App {
  App({required this.ip, required this.port, required AppRouter appRouter})
    : _appRouter = appRouter;

  final AppRouter _appRouter;
  final InternetAddress ip;
  final int port;

  final CorsCreateMiddlewareHelper _corsCreateMiddlewareHelper =
      CorsCreateMiddlewareHelper();

  Future<HttpServer> start() async {
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(
          createMiddleware(
            requestHandler: _corsCreateMiddlewareHelper.requestHandler,
            responseHandler: _corsCreateMiddlewareHelper.responseHandler,
          ),
        )
        .addHandler(_appRouter.router.call);

    final server = await serve(handler, ip, port);
    return server;
  }
}
