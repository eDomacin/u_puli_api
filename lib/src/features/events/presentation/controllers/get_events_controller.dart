import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/get_events_use_case.dart';
import 'package:u_puli_api/src/features/events/utils/constants/get_events_request_query_params_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';

class GetEventsController {
  const GetEventsController({required GetEventsUseCase getEventsUseCase})
    : _getEventsUseCase = getEventsUseCase;

  final GetEventsUseCase _getEventsUseCase;

  Future<Response> call(Request request) async {
    // -----------------------
    //  url here -> http://localhost:8080/events?ids%3D1%2C2%2C3%26fromDate%3D1751310762670
    // TODO this already seems to be decoded in query params
    // final Map<String, String> queryParams = request.url.queryParameters;

    // final idsParam = queryParams['ids'];
    // final fromDateParam = queryParams['fromDate'];

    // final ids = _parseIds(idsParam);
    // final fromDate = _parseFromDate(fromDateParam);

    // print('Ids: $ids');
    // print('From date: $fromDate');

    // fina

    // final ids = idsParam?.split(',').map((id) => int.tryParse(id)).toList();

    // final int? fromDateMilliseconds =
    //     fromDateParam == null ? null : int.tryParse(fromDateParam);

    // final whatIsThis = request.url.queryParametersAll;

    // final DateTime? fromDate =
    //     fromDateMilliseconds == null
    //         ? null
    //         : DateTime.fromMillisecondsSinceEpoch(
    //           fromDateMilliseconds,
    //           // TODO will need to be checking this
    //           // isUtc: true,
    //         );

    // --------------------------

    /* TODO possible this can be unified in a single function or a class that handles thsi case, and then reused everywhere */
    final Map<String, dynamic>? validatedQueryParamsData =
        request.getValidatedQueryParamsData();
    if (validatedQueryParamsData == null) {
      final Response response = _generateFailureResponse(
        message: "Request query params not validated",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final (:ids, :fromDate) = _getGetEventsDataFromValidatedQueryParamsData(
      validatedQueryParamsData,
    );

    final List<EventModel> events = await _getEventsUseCase(
      // TODO temp we are testing this will null values
      fromDate: fromDate,
      eventIds: ids,
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

typedef _GetEventsDataFromValidatedQueryParamsData =
    ({List<int>? ids, DateTime? fromDate});

_GetEventsDataFromValidatedQueryParamsData
_getGetEventsDataFromValidatedQueryParamsData(
  Map<String, dynamic> validatedQueryParamsData,
) {
  final List<int>? ids =
      validatedQueryParamsData[GetEventsRequestQueryParamsConstants.IDS.value];
  final DateTime? fromDate =
      validatedQueryParamsData[GetEventsRequestQueryParamsConstants
          .FROM_DATE
          .value];

  return (ids: ids, fromDate: fromDate);
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

// List<int>? _parseIds(String? idsParam) {
//   if (idsParam == null) return null;

//   // now we know it is not empty
//   // lets check format
//   final idsParamRegexp = RegExp(r'^\d+(,\d+)*$');
//   final isMatch = idsParamRegexp.hasMatch(idsParam);
//   // we have invalid format - lets just ignore it
//   if (!isMatch) return null;

//   // now we know it is valid format
//   final ids = <int>[];

//   final idsParts = idsParam.split(',');
//   for (final part in idsParts) {
//     final id = int.parse(part);
//     ids.add(id);
//   }
//   return ids;
// }

// DateTime? _parseFromDate(String? fromDateParam) {
//   if (fromDateParam == null) return null;

//   final fromDateParamsRegexp = RegExp(r'^\d+$');
//   final isMatch = fromDateParamsRegexp.hasMatch(fromDateParam);
//   // we have invalid format - lets just ignore it
//   if (!isMatch) return null;

//   final milliseconds = int.parse(fromDateParam);
//   final fromDate = DateTime.fromMillisecondsSinceEpoch(
//     milliseconds,
//     // TODO will need to be checking this
//     // isUtc: true,
//   );
//   return fromDate;
// }
