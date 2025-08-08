/* TODO this needs testing */
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/middleware.dart';
import 'package:u_puli_api/src/features/search/utils/constants/search_request_query_params_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/middleware_helper/middleware_helper.dart';

class ValidateSearchRequestMiddlewareHelper implements MiddlewareHelper {
  @override
  Middleware call() {
    Future<Response> Function(Request request) middleware(
      // this is our actual request handler - the controller we passed to route
      Handler innerHandler,
    ) {
      // this is request handler that will be called by the middleware
      Future<Response> requestHandler(Request request) async {
        final queryParams = request.url.queryParameters;

        final dynamic searchQueryParam =
            queryParams[SearchRequestQueryParamsConstants.QUERY.value];

        if (searchQueryParam is! String) {
          final response = _generateFailureResponse(
            message: "Invalid 'query' parameter",
            statusCode: HttpStatus.badRequest,
          );

          return response;
        }

        if (searchQueryParam.isEmpty) {
          final response = _generateFailureResponse(
            message: "'query' parameter cannot be empty",
            statusCode: HttpStatus.badRequest,
          );

          return response;
        }

        final validatedRequest = request
            .getChangedRequestWithValidatedQueryParamsData({
              SearchRequestQueryParamsConstants.QUERY.value: searchQueryParam,
            });

        final response = await Future.sync(
          () => innerHandler(validatedRequest),
        );

        return response;
      }

      return requestHandler;
    }

    return middleware;
  }
}

/* TODO create a unified failure response generator for all cases */

Response _generateFailureResponse({
  required String message,
  required int statusCode,
}) {
  final Map<String, dynamic> responseBody = {"ok": false, "message": message};
  final String responseBodyJson = jsonEncode(responseBody);

  final Response response = Response(
    statusCode,
    body: responseBodyJson,
    headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
  );

  return response;
}
