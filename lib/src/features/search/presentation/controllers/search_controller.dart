import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/search/domain/use_cases/searh_use_case.dart';
import 'package:u_puli_api/src/features/search/utils/constants/search_request_query_params_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';

class SearchController {
  final SearchUseCase _searchUseCase;

  const SearchController({required SearchUseCase searchUseCase})
    : _searchUseCase = searchUseCase;

  Future<Response> call(Request request) async {
    final Map<String, dynamic>? validatedQueryParamsData =
        request.getValidatedQueryParamsData();

    if (validatedQueryParamsData == null) {
      final response = _generateFailureResponse(
        message: "Request query params not validated",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    final (:query) = _getSearchDataFromValidatedQueryParamsData(
      validatedQueryParamsData,
    );

    final result = await _searchUseCase.call(query);

    final resultEventsData =
        result.events.map((event) {
          /* TODO this should be unified somehow, so as not to duplicate same logic as in get events controller */
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

    /* if we have any other search results, we will transform those as well */

    final Map<String, dynamic> responseBody = {
      "ok": true,
      "message": "Data retrieved successfully",
      "data": {
        "result": {"events": resultEventsData},
      },
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

typedef _SearchDataFromValidatedQueryParamsData = ({String query});
_SearchDataFromValidatedQueryParamsData
_getSearchDataFromValidatedQueryParamsData(
  Map<String, dynamic> validatedQueryParamsData,
) {
  final String query =
      validatedQueryParamsData[SearchRequestQueryParamsConstants.QUERY.value]
          as String;

  return (query: query);
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
