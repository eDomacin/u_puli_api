import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/create_middleware_helper/create_middleware_helper.dart';

class ErrorHandlerMiddlewareHelper implements CreateMiddlewareHelper {
  @override
  FutureOr<Response> errorHandler(Object error, StackTrace stackTrace) {
    print(
      'Error caught by ErrorHandlerMiddlewareHelper -> '
      '\n error: $error'
      '\n stackTrace: $stackTrace',
    );

    return Response.internalServerError(
      body: jsonEncode({
        "ok": false,
        "message": "Oops! Something went wrong :( Please try again later.",
      }),
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
    );
  }

  // not needed
  @override
  FutureOr<Response?> requestHandler(Request request) =>
      throw UnimplementedError();

  @override
  FutureOr<Response> responseHandler(Response response) =>
      throw UnimplementedError();
}
