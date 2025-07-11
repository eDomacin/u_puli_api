import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/get_event_use_case.dart';

class GetEventController {
  const GetEventController({required GetEventUseCase getEventUseCase})
    : _getEventUseCase = getEventUseCase;

  final GetEventUseCase _getEventUseCase;

  Future<Response> call(Request request) async {
    // TODO will need to create middlware for this
    final idParam = request.params['id'];
    if (idParam == null) {
      // TODO we will come back to this
      throw ArgumentError("Missing 'id' parameter");
    }

    final id = int.tryParse(idParam);
    if (id == null) {
      // TODO we will come back to this
      throw ArgumentError("Invalid 'id' parameter");
    }

    final EventModel? event = await _getEventUseCase(id);
    if (event == null) {
      final Response notFoundResponse = _generateNotFoundResponse();

      return notFoundResponse;
    }

    final Response successResponse = _generateSuccessResponse(event: event);

    return successResponse;
  }
}

Response _generateNotFoundResponse() {
  final Map<String, dynamic> responseBody = {
    "ok": false,
    "message": "Data not found",
  };
  final responseBodyJson = jsonEncode(responseBody);

  final response = Response(
    HttpStatus.notFound,
    body: responseBodyJson,
    headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
  );

  return response;
}

Response _generateSuccessResponse({required EventModel event}) {
  /* TODO should create some converter to json on model itself, or on Converters class   */
  final Map<String, dynamic> eventData = {
    "id": event.id,
    "title": event.title,
    "date": event.date.millisecondsSinceEpoch,
    "location": event.location,
    "url": event.url,
    "imageUrl": event.imageUrl,
    "description": event.description,
  };

  final Map<String, dynamic> responseBody = {
    "ok": true,
    "message": "Data retrieved successfully",
    "data": {"event": eventData},
  };
  final responseBodyJson = jsonEncode(responseBody);

  final response = Response(
    HttpStatus.ok,
    body: responseBodyJson,
    headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
  );

  return response;
}
