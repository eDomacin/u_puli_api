import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/events/utils/constants/events_request_url_params_constants.dart';
import 'package:u_puli_api/src/features/events/utils/constants/update_event_request_body_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/middleware_helper/middleware_helper.dart';

class ValidateUpdateEventRequestBodyMiddlewareHelper
    implements MiddlewareHelper {
  @override
  Middleware call() {
    // TODO: implement call
    Future<Response> Function(Request request) middleware(
      Handler innerHandler,
    ) {
      Future<Response> requestHandler(Request request) async {
        final int? id = request.getUrlParam<int>(
          parameterName: EventsRequestUrlParamsConstants.ID.value,
          parser: (param) => int.tryParse(param) ?? -1,
        );

        if (id == null) {
          // TODO this would never happen
          final Response response = _generateFailureResponse(
            message: "Missing 'id' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final Map<String, dynamic>? requestBody = await request.parseBody();
        if (requestBody == null) {
          final Response response = _generateFailureResponse(
            message: "Invalid request body",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final dynamic title =
            requestBody[UpdateEventRequestBodyConstants.TITLE.value];
        if (title is! String?) {
          final Response response = _generateFailureResponse(
            message: "Invalid 'title' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final dynamic location =
            requestBody[UpdateEventRequestBodyConstants.LOCATION.value];
        if (location is! String?) {
          final Response response = _generateFailureResponse(
            message: "Invalid 'location' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final dynamic date =
            requestBody[UpdateEventRequestBodyConstants.DATE.value];
        if (date is! int?) {
          final Response response = _generateFailureResponse(
            message: "Invalid 'date' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final dynamic uri =
            requestBody[UpdateEventRequestBodyConstants.URI.value];
        if (uri is! String?) {
          final Response response = _generateFailureResponse(
            message: "Invalid 'uri' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final dynamic imageUri =
            requestBody[UpdateEventRequestBodyConstants.IMAGE_URI.value];
        if (imageUri is! String?) {
          final Response response = _generateFailureResponse(
            message: "Invalid 'imageUri' parameter",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        // validate parsable values
        final Response? dateValidationResponse = _validateDate(
          dateMilliseconds: date,
        );
        if (dateValidationResponse != null) {
          return dateValidationResponse;
        }

        final Response? uriValidationResponse = _validateUri(uri: uri);
        if (uriValidationResponse != null) {
          return uriValidationResponse;
        }

        final Response? imageUriValidationResponse = _validateImageUri(
          imageUri: imageUri,
        );
        if (imageUriValidationResponse != null) {
          return imageUriValidationResponse;
        }

        final Request validatedRequest = request
            .getChangedRequestWithValidatedBodyData({
              UpdateEventRequestBodyConstants.TITLE.value: title,
              UpdateEventRequestBodyConstants.LOCATION.value: location,
              UpdateEventRequestBodyConstants.DATE.value: date,
              UpdateEventRequestBodyConstants.URI.value: uri,
              UpdateEventRequestBodyConstants.IMAGE_URI.value: imageUri,
            })
            .getChangedRequestWithValidatedUrlParamsData({
              EventsRequestUrlParamsConstants.ID.value: id,
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

  Response? _validateDate({required int? dateMilliseconds}) {
    if (dateMilliseconds == null) return null;

    final DateTime date = DateTime.fromMillisecondsSinceEpoch(dateMilliseconds);
    final DateTime now = DateTime.now();

    if (date.isBefore(now)) {
      final Response response = _generateFailureResponse(
        message: "Event date must be in the future",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    return null;
  }

  Response? _validateUri({required String? uri}) {
    if (uri == null) return null;

    final Uri? uriValue = Uri.tryParse(uri);
    if (uriValue == null) {
      final Response response = _generateFailureResponse(
        message: "Invalid 'uri' parameter",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    return null;
  }

  Response? _validateImageUri({required String? imageUri}) {
    if (imageUri == null) return null;

    final Uri? imageUriValue = Uri.tryParse(imageUri);
    if (imageUriValue == null) {
      final Response response = _generateFailureResponse(
        message: "Invalid 'imageUri' parameter",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    return null;
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
