import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/auth/utils/constants/auth_reg_exp_validation_constants.dart';
import 'package:u_puli_api/src/features/auth/utils/constants/login_with_user_and_password_request_body_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/middleware_helper/middleware_helper.dart';

class ValidateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper
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

          final email =
              requestBody[LoginWithUserAndPasswordRequestBodyConstants
                  .EMAIL
                  .value];
          if (email == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'email' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (email is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'email' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          if (!AuthRegExpValidationConstants.EMAIL.hasMatch(email)) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'email' format",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final password =
              requestBody[LoginWithUserAndPasswordRequestBodyConstants
                  .PASSWORD
                  .value];
          if (password == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'password' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (password is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'password' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final Request validatedRequest = request
              .getChangedRequestWithValidatedBodyData({
                LoginWithUserAndPasswordRequestBodyConstants.EMAIL.value: email,
                LoginWithUserAndPasswordRequestBodyConstants.PASSWORD.value:
                    password,
              });

          final Response response = await Future.sync(
            () => innerHandler(validatedRequest),
          );

          return response;
        } catch (error) {
          print(
            "Error in $ValidateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper",
          );
          rethrow;
        }
      }

      return requestHandler;
    }

    return middleware;
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
}
