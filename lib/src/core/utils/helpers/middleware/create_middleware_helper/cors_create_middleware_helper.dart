import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/create_middleware_helper/create_middleware_helper.dart';

class CorsCreateMiddlewareHelper implements CreateMiddlewareHelper {
  @override
  FutureOr<Response?> requestHandler(Request request) {
    if (request.method == "OPTIONS") {
      return Response.ok(null, headers: _corsHeaders);
    }

    // go through to the next handler
    return null;
  }

  @override
  FutureOr<Response> responseHandler(Response response) {
    // attach cors headers to the response
    return response.change(headers: _corsHeaders);
  }

  // helpers
  final _corsHeaders = {
    HttpHeaders.accessControlAllowOriginHeader: '*',
    // HttpHeaders.accessControlAllowOriginHeader: 'http://localhost:3000',
    HttpHeaders.accessControlAllowMethodsHeader:
        'GET, POST, PUT, DELETE, OPTIONS',
    HttpHeaders.accessControlAllowHeadersHeader: '*',
  };

  // not needed
  @override
  FutureOr<Response> errorHandler(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();
}
