import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/update_event_use_case.dart';
import 'package:u_puli_api/src/features/events/utils/constants/events_request_url_params_constants.dart';
import 'package:u_puli_api/src/features/events/utils/constants/update_event_request_body_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';

class UpdateEventController {
  const UpdateEventController({required UpdateEventUseCase updateEventUseCase})
    : _updateEventUseCase = updateEventUseCase;

  final UpdateEventUseCase _updateEventUseCase;

  Future<Response> call(Request request) async {
    final Map<String, dynamic>? validatedBodyData =
        request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final Response response = _generateFailureResponse(
        message: "Request body not validated",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final validatedUrlParams = request.getValidatedUrlParamsData();
    if (validatedUrlParams == null) {
      final Response response = _generateFailureResponse(
        message: "Request url params not validated",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final (:id) = _getUpdateEventDataFromValidatedUrlParams(validatedUrlParams);
    final (
      :title,
      :location,
      :date,
      :uri,
      :imageUri,
      :description,
    ) = _getUpdateEventDataFromValidatedRequestBody(validatedBodyData);

    await _updateEventUseCase(
      id: id,
      title: title,
      location: location,
      date: date,
      uri: uri,
      imageUri: imageUri,
      description: description,
    );

    final Map<String, dynamic> data = {
      "event": {"id": id},
    };

    final Response response = _generateSuccessResponse(
      message: "Event updated successfully",
      statusCode: HttpStatus.ok,
      isOk: true,
      data: data,
    );

    return response;
  }
}

Response _generateSuccessResponse({
  required String message,
  required int statusCode,
  required bool isOk,
  required Map<String, dynamic> data,
}) {
  final Response response = Response(
    statusCode,
    body: jsonEncode({"ok": isOk, "message": message, "data": data}),
    headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
  );

  return response;
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
    // TODO check if original access token and refresh token will be presnt on subsequent requests in the browser
    headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
  );

  return response;
}

typedef _UpdateEventDataFromValidatedUrlParams = ({int id});
_UpdateEventDataFromValidatedUrlParams
_getUpdateEventDataFromValidatedUrlParams(
  Map<String, dynamic> validatedUrlParams,
) {
  final int id = validatedUrlParams[EventsRequestUrlParamsConstants.ID.value];

  final _UpdateEventDataFromValidatedUrlParams
  createEventDataFromValidatedUrlParams = (id: id);

  return createEventDataFromValidatedUrlParams;
}

typedef _UpdateEventDataFromValidatedRequestBody =
    ({
      String? title,
      String? location,
      DateTime? date,
      Uri? uri,
      Uri? imageUri,
      String? description,
    });
_UpdateEventDataFromValidatedRequestBody
_getUpdateEventDataFromValidatedRequestBody(
  Map<String, dynamic> validatedBodyData,
) {
  final String? title =
      validatedBodyData[UpdateEventRequestBodyConstants.TITLE.value];
  final String? location =
      validatedBodyData[UpdateEventRequestBodyConstants.LOCATION.value];
  final DateTime? date =
      validatedBodyData[UpdateEventRequestBodyConstants.DATE.value];
  final Uri? uri = validatedBodyData[UpdateEventRequestBodyConstants.URI.value];
  final Uri? imageUri =
      validatedBodyData[UpdateEventRequestBodyConstants.IMAGE_URI.value];
  final String? description =
      validatedBodyData[UpdateEventRequestBodyConstants.DESCRIPTION.value];

  final _UpdateEventDataFromValidatedRequestBody
  createEventDataFromValidatedRequestBody = (
    title: title,
    location: location,
    date: date,
    uri: uri,
    imageUri: imageUri,
    description: description,
  );

  return createEventDataFromValidatedRequestBody;
}
