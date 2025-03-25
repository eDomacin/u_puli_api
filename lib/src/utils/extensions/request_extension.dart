import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:u_puli_api/src/utils/constants/request_constants.dart';

extension RequestExtension on Request {
  T? getUrlParam<T>({
    required String parameterName,
    required T? Function(String) parser,
  }) {
    try {
      final String? paramValue = this.params[parameterName];
      /*       
      // alternatively, we could access params from the context. because in tests, request.params does not hold actual params because request does not pass through reouter - it should pass through router, and defined route, for it to be parsed into params map
      final shelfRouterParamsKey = "shelf_router/params";
      final paramsMap = context[shelfRouterParamsKey] as Map<String, String>;
      final paramValue = paramsMap[paramName]; 
      */

      if (paramValue == null) {
        return null;
      }

      final T? parsedValue = parser(paramValue);

      return parsedValue;
    } catch (e, s) {
      // TODO remove all prints
      print(
        "There was an issue parsing the url parameter -> error: $e, stackTrace: $s",
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> parseBody() async {
    try {
      final bodyString = await readAsString();
      final body = jsonDecode(bodyString) as Map<String, dynamic>;

      return body;
    } catch (e, s) {
      // TODO remove all prints
      print("There was an issue parsing the body -> error: $e, stackTrace: $s");
      return null;
    }
  }

  String? getAccessTokenFromAuthorizationHeader() {
    final String? authorizationHeader =
        headers[HttpHeaders.authorizationHeader];

    if (authorizationHeader == null) {
      return null;
    }

    final List<String> authorizationHeaderParts = authorizationHeader.split(
      " ",
    );

    if (authorizationHeaderParts.length != 2) {
      return null;
    }

    return authorizationHeaderParts[1];
  }

  Request getChangedRequestWithValidatedBodyData(Map<String, dynamic> data) {
    final Request changedRequest = change(
      context: {RequestConstants.VALIDATED_BODY_DATA.value: data},
    );

    return changedRequest;
  }

  Request getChangedRequestWithValidatedUrlParamsData(
    Map<String, dynamic> data,
  ) {
    final Request changedRequest = change(
      context: {RequestConstants.VALIDATED_URL_PARAMS_DATA.value: data},
    );

    return changedRequest;
  }

  Map<String, dynamic>? getValidatedBodyData() {
    final Map<String, dynamic>? validatedBodyData =
        context[RequestConstants.VALIDATED_BODY_DATA.value]
            as Map<String, dynamic>?;

    return validatedBodyData;
  }

  Map<String, dynamic>? getValidatedUrlParamsData() {
    final Map<String, dynamic>? validatedUrlParamsData =
        context[RequestConstants.VALIDATED_URL_PARAMS_DATA.value]
            as Map<String, dynamic>?;

    return validatedUrlParamsData;
  }

  Request getChangedRequestWithAuthenticatedAuthId(int authId) {
    final Request changedRequest = change(
      context: {RequestConstants.AUTHENTICATED_AUTH_ID.value: authId},
    );

    return changedRequest;
  }

  int? getAuthenticatedAuthId() {
    final int? authenticatedAuthId =
        context[RequestConstants.AUTHENTICATED_AUTH_ID.value] as int?;

    return authenticatedAuthId;
  }
}
