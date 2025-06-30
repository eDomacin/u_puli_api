import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/get_events_use_case.dart';

class GetEventsController {
  const GetEventsController({required GetEventsUseCase getEventsUseCase})
    : _getEventsUseCase = getEventsUseCase;

  final GetEventsUseCase _getEventsUseCase;

  Future<Response> call(Request request) async {
    final List<EventModel> events = await _getEventsUseCase(
      // TODO temp we are testing this will null values
      fromDate: null,
      eventIds: null,
    );

    final List<Map> eventsData =
        events.map((event) {
          return {
            "id": event.id,
            "title": event.title,
            "date": event.date.millisecondsSinceEpoch,
            "location": event.location,
            /* TODO should create some converter to json on model itself, or on Converters class   */
            "url": event.url,
            "imageUrl": event.imageUrl,
            "description": event.description,
          };
        }).toList();

    final Map<String, dynamic> responseBody = {
      "ok": true,
      "message": "Data retrieved successfully",
      "data": {"events": eventsData},
    };
    final responseBodyJson = jsonEncode(responseBody);

    final response = Response(
      HttpStatus.ok,
      body: responseBodyJson,
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
    );

    return response;
  }
}
