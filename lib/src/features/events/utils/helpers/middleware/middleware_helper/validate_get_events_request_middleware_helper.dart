import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/middleware.dart';
import 'package:u_puli_api/src/features/events/utils/constants/events_reg_exp_validation_constants.dart';
import 'package:u_puli_api/src/features/events/utils/constants/get_events_request_query_params_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/middleware_helper/middleware_helper.dart';

class ValidateGetEventsRequestMiddlewareHelper implements MiddlewareHelper {
  @override
  Middleware call() {
    Future<Response> Function(Request request) middleware(
      // inner handler is our actual request handler - the controller we passed to route
      Handler innerHandler,
    ) {
      // now create request handler
      Future<Response> requestHandler(Request request) async {
        final queryParams = request.url.queryParameters;

        final dynamic idsParam =
            queryParams[GetEventsRequestQueryParamsConstants.IDS.value];
        if (idsParam is! String?) {
          final Response response = _generateFailureResponse(
            message: "Invalid 'ids' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final dynamic fromDateParam =
            queryParams[GetEventsRequestQueryParamsConstants.FROM_DATE.value];
        if (fromDateParam is! String?) {
          final Response response = _generateFailureResponse(
            message: "Invalid 'fromDate' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final List<int>? ids = _parseIds(idsParam);
        final DateTime? fromDate = _parseFromDate(fromDateParam);

        final Request validatedRequest = request
            .getChangedRequestWithValidatedQueryParamsData({
              GetEventsRequestQueryParamsConstants.IDS.value: ids,
              GetEventsRequestQueryParamsConstants.FROM_DATE.value: fromDate,
            });

        final Response response = await Future.sync(
          () => innerHandler(validatedRequest),
        );

        return response;
      }

      return requestHandler;
    }

    return middleware;
  }
}

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

List<int>? _parseIds(String? idsParam) {
  if (idsParam == null) return null;

  // now we know it is not empty
  // lets check format
  // final idsParamRegexp = RegExp(r'^\d+(,\d+)*$');
  final isMatch = EventsRegExpValidationConstants.IDS.hasMatch(idsParam);
  // we have invalid format - lets just ignore it
  if (!isMatch) return null;

  // now we know it is valid format
  final ids = <int>[];

  final idsParts = idsParam.split(',');
  for (final part in idsParts) {
    final id = int.parse(part);
    ids.add(id);
  }
  return ids;
}

DateTime? _parseFromDate(String? fromDateParam) {
  if (fromDateParam == null) return null;

  // final fromDateParamsRegexp = RegExp(r'^\d+$');
  final isMatch = EventsRegExpValidationConstants.FROM_DATE.hasMatch(
    fromDateParam,
  );
  // we have invalid format - lets just ignore it
  if (!isMatch) return null;

  final milliseconds = int.parse(fromDateParam);
  final fromDate = DateTime.fromMillisecondsSinceEpoch(
    milliseconds,
    // TODO will need to be checking this
    // isUtc: true,
  );
  return fromDate;
}
