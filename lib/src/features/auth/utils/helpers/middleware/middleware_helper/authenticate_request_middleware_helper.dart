import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_jwt_payload_value.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/auth_jwt_helper.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/middleware_helper/middleware_helper.dart';

class AuthenticateRequestMiddlewareHelper implements MiddlewareHelper {
  const AuthenticateRequestMiddlewareHelper({
    required AuthJWTHelper authJWTHelper,
  }) : _authJWTHelper = authJWTHelper;

  final AuthJWTHelper _authJWTHelper;

  @override
  Middleware call() {
    Future<Response> Function(Request request) middleware(
      Handler innerHandler,
    ) {
      Future<Response> requestHandler(Request request) async {
        try {
          final String? accessToken =
              request.getAccessTokenFromAuthorizationHeader();
          if (accessToken == null) {
            final Response response = _generateFailureResponse(
              message: "Missing access token",
              statusCode: HttpStatus.unauthorized,
            );
            return response;
          }

          final AuthJwtPayloadValue authJwtPayloadValue = _authJWTHelper
              .verifyAccessJwt(accessToken);

          if (authJwtPayloadValue is AuthJwtPayloadInvalidValue) {
            final Response response = _generateFailureResponse(
              message: "Invalid access token",
              statusCode: HttpStatus.unauthorized,
            );
            return response;
          }

          if (authJwtPayloadValue is AuthJwtPayloadExpiredValue) {
            final Response response = _generateFailureResponse(
              message: "Expired access token",
              statusCode: HttpStatus.unauthorized,
            );
            return response;
          }

          if (authJwtPayloadValue is AuthJwtPayloadMissingDataValue) {
            final Response response = _generateFailureResponse(
              message: "Missing data in access token",
              statusCode: HttpStatus.unauthorized,
            );
            return response;
          }

          final int authId =
              (authJwtPayloadValue as AuthJwtPayloadValidValue).authId;

          final Request changedRequest = request
              .getChangedRequestWithAuthenticatedAuthId(authId);

          final Response response = await Future.sync(
            () => innerHandler(changedRequest),
          );

          return response;
        } catch (e) {
          print("Error in $AuthenticateRequestMiddlewareHelper");

          // TODO we could return response from here - but we will hanve error handler in general
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
