import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:u_puli_api/src/app_router.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/middleware/create_middleware_helper/cors_create_middleware_helper.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/middleware/create_middleware_helper/error_handler_middleware_helper.dart';

class App {
  App({required this.ip, required this.port, required AppRouter appRouter})
    : _appRouter = appRouter;

  final AppRouter _appRouter;
  final InternetAddress ip;
  final int port;

  Future<HttpServer> start() async {
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(
          createMiddleware(
            // error from any routes' controllers will bubble up to this handler
            errorHandler: _errorHandlerMiddlewareHelper.errorHandler,
          ),
        )
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

final CorsCreateMiddlewareHelper _corsCreateMiddlewareHelper =
    CorsCreateMiddlewareHelper();

final ErrorHandlerMiddlewareHelper _errorHandlerMiddlewareHelper =
    ErrorHandlerMiddlewareHelper();
