import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/create_event_use_case.dart';
import 'package:u_puli_api/src/features/events/utils/constants/create_event_request_body_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';

class CreateEventController {
  const CreateEventController({required CreateEventUseCase createEventUseCase})
    : _createEventUseCase = createEventUseCase;

  final CreateEventUseCase _createEventUseCase;

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

    final (
      :title,
      :location,
      :date,
      :uri,
      :imageUri,
      :description,
    ) = _getCreateEventDataFromValidatedRequestBody(validatedBodyData);

    final int id = await _createEventUseCase(
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
      message: "Event created successfully",
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

typedef _CreateEventDataFromValidatedRequestBody =
    ({
      String title,
      String location,
      DateTime date,
      Uri uri,
      Uri imageUri,
      String description,
    });

_CreateEventDataFromValidatedRequestBody
_getCreateEventDataFromValidatedRequestBody(
  Map<String, dynamic> validatedBodyData,
) {
  final String title =
      validatedBodyData[CreateEventRequestBodyConstants.TITLE.value];
  final String location =
      validatedBodyData[CreateEventRequestBodyConstants.LOCATION.value];
  final DateTime date =
      validatedBodyData[CreateEventRequestBodyConstants.DATE.value];
  final Uri uri = validatedBodyData[CreateEventRequestBodyConstants.URI.value];
  final Uri imageUri =
      validatedBodyData[CreateEventRequestBodyConstants.IMAGE_URI.value];
  final String description =
      validatedBodyData[CreateEventRequestBodyConstants.DESCRIPTION.value];

  final _CreateEventDataFromValidatedRequestBody
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

// TODO create generate ResponseGenerator for the whole app
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

    // TODO later, grab auti_id from auth validator, and retrieve user id for it
    // - then, use that that user id to link the event to the user as the event creator 