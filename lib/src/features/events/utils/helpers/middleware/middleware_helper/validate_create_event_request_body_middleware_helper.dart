import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/events/utils/constants/create_event_request_body_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/middleware_helper/middleware_helper.dart';
import 'package:u_puli_api/src/wrappers/timezone/timezone_wrapper.dart';

class ValidateCreateEventRequestBodyMiddlewareHelper
    implements MiddlewareHelper {
  @override
  Middleware call() {
    Future<Response> Function(Request request) middleware(
      Handler innerHandler,
    ) {
      Future<Response> requestHandler(Request request) async {
        try {
          final Map<String, dynamic>? requestBody = await request.parseBody();
          if (requestBody == null) {
            final Response response = _generateFailureResponse(
              message: "Invalid request body",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final dynamic title =
              requestBody[CreateEventRequestBodyConstants.TITLE.value];
          if (title == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'title' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (title is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'title' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final dynamic date =
              requestBody[CreateEventRequestBodyConstants.DATE.value];
          if (date == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'date' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (date is! int) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'date' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          // these are default times
          final DateTime dateValue = DateTime.fromMillisecondsSinceEpoch(date);
          final DateTime now = DateTime.now();

          // we need to convert to utc
          final eventUtcDateTime = TimezoneWrapper.toLocationDateInUTC(
            TimezoneLocation.croatia,
            year: dateValue.year,
            month: dateValue.month,
            day: dateValue.day,
            hours: dateValue.hour,
            minutes: dateValue.minute,
          );
          final nowUtcDateTime = TimezoneWrapper.toLocationDateInUTC(
            TimezoneLocation.croatia,
            year: now.year,
            month: now.month,
            day: now.day,
            hours: now.hour,
            minutes: now.minute,
          );

          print("dateValue: $dateValue");
          print("now: $now");
          print("eventUtcDateTime: $eventUtcDateTime");
          print("nowUtcDateTime: $nowUtcDateTime");

          if (eventUtcDateTime.isBefore(nowUtcDateTime)) {
            final Response response = _generateFailureResponse(
              message: "Event date must be in the future",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final dynamic location =
              requestBody[CreateEventRequestBodyConstants.LOCATION.value];
          if (location == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'location' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (location is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'location' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final dynamic url =
              requestBody[CreateEventRequestBodyConstants.URL.value];
          if (url == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'uri' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (url is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'uri' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          final Uri? uriValue = Uri.tryParse(url);
          if (uriValue == null) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'uri' format",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final dynamic imageUrl =
              requestBody[CreateEventRequestBodyConstants.IMAGE_URL.value];
          if (imageUrl == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'imageUri' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (imageUrl is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'imageUri' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          final Uri? imageUriValue = Uri.tryParse(imageUrl);
          if (imageUriValue == null) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'imageUri' format",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final dynamic description =
              requestBody[CreateEventRequestBodyConstants.DESCRIPTION.value];
          if (description == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'description' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (description is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'description' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final Request validatedRequest = request
              .getChangedRequestWithValidatedBodyData({
                CreateEventRequestBodyConstants.TITLE.value: title,
                // CreateEventRequestBodyConstants.DATE.value: dateValue,
                CreateEventRequestBodyConstants.DATE.value: eventUtcDateTime,
                CreateEventRequestBodyConstants.LOCATION.value: location,
                CreateEventRequestBodyConstants.URL.value: uriValue,
                CreateEventRequestBodyConstants.IMAGE_URL.value: imageUriValue,
                CreateEventRequestBodyConstants.DESCRIPTION.value: description,
              });

          final Response response = await Future.sync(
            () => innerHandler(validatedRequest),
          );

          return response;
        } catch (e) {
          // TODO do better log
          print("Error in $ValidateCreateEventRequestBodyMiddlewareHelper");
          rethrow;
        }
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
