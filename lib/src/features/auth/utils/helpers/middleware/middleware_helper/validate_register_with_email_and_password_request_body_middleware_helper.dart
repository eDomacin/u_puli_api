import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/auth/utils/constants/register_with_user_and_password_request_body_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/utils/helpers/middleware/middleware_helper/middleware_helper.dart';

class ValidateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper
    implements MiddlewareHelper {
  @override
  Middleware call() {
    // define middleware function that will provide the endpoint controller to the middleware, so we can pass it the modified request.
    // This function will be called automatically by the pipeline
    Future<Response> Function(Request request) middleware(
      Handler innerHandler,
    ) {
      // define function that handles the request - this is effectively the middleware logic
      Future<Response> requestHandler(Request request) async {
        try {
          // we will get the response once the inner handler is done
          //  - inner handler is the function that handles the request - aka, the endpoint controller

          final Map<String, dynamic>? requestBody = await request.parseBody();
          if (requestBody == null) {
            final Response response = _generateFailureResponse(
              message: "Invalid request body",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final firstName =
              requestBody[RegisterWithUserAndPasswordRequestBodyConstants
                  .FIRST_NAME
                  .value];

          if (firstName == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'first_name' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (firstName is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'first_name' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final lastName =
              requestBody[RegisterWithUserAndPasswordRequestBodyConstants
                  .LAST_NAME
                  .value];

          if (lastName == null) {
            final Response response = _generateFailureResponse(
              message: "Missing 'last_name' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }
          if (lastName is! String) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'last_name' parameter",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final email =
              requestBody[RegisterWithUserAndPasswordRequestBodyConstants
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

          final emailRegExp = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          );
          if (!emailRegExp.hasMatch(email)) {
            final Response response = _generateFailureResponse(
              message: "Invalid 'email' format",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final password =
              requestBody[RegisterWithUserAndPasswordRequestBodyConstants
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

          final passwordRegExp = RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*])[A-Za-z\d!@#\$%\^&\*]{8,}$',
          );
          if (!passwordRegExp.hasMatch(password)) {
            final Response response = _generateFailureResponse(
              message:
                  "Invalid 'password' format. Password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character",
              statusCode: HttpStatus.badRequest,
            );
            return response;
          }

          final Request
          validatedRequest = request.getChangedRequestWithValidatedBodyData({
            RegisterWithUserAndPasswordRequestBodyConstants.FIRST_NAME.value:
                firstName,
            RegisterWithUserAndPasswordRequestBodyConstants.LAST_NAME.value:
                lastName,
            RegisterWithUserAndPasswordRequestBodyConstants.EMAIL.value: email,
            RegisterWithUserAndPasswordRequestBodyConstants.PASSWORD.value:
                password,
          });

          // pass validated request to the inner handler - the controller
          final Response response = await Future.sync(
            () => innerHandler(validatedRequest),
          );

          // return the response
          // we could modify the response here
          return response;
        } catch (error) {
          print(
            "Error in $ValidateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper",
          );
          rethrow;
        }
      }

      // return the function that handles the request - this is the middleware logic
      return requestHandler;
    }

    // return the middleware
    return middleware;
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
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
    );

    return response;
  }
}

  // TOOD how to test this class
  // void main(List<String> args) {
  //   final validateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper =
  //       ValidateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper();

  //   final middleware =
  //       validateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper();

  //   // we pass our controller to the middleware and we get back the middleware logic - the function that handles the request
  //   final requestHandler = middleware((Request request) async {
  //     return Response.ok("Hello, World!");
  //   });

  //   // call the middleware logic - the function that handles the request
  //   final response = requestHandler(Request('GET', Uri.parse('/')));

  //   // we can expect that the response is the same as the one we returned from the controller
  //   // we can also expect that our callback was called
  // }