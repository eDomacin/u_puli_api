import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/auth/domain/use_cases/get_auth_by_email_use_case.dart';
import 'package:u_puli_api/src/auth/domain/use_cases/register_with_user_and_password_use_case.dart';
import 'package:u_puli_api/src/auth/utils/constants/register_with_user_and_password_request_body_constants.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';

class RegisterWithUserAndPasswordController {
  const RegisterWithUserAndPasswordController({
    required RegisterWithUserAndPasswordUseCase
    registerWithUserAndPasswordUseCase,
    required GetAuthByEmailUseCase getAuthByEmailUseCase,
  }) : _registerWithUserAndPasswordUseCase = registerWithUserAndPasswordUseCase,
       _getAuthByEmailUseCase = getAuthByEmailUseCase;

  final RegisterWithUserAndPasswordUseCase _registerWithUserAndPasswordUseCase;
  final GetAuthByEmailUseCase _getAuthByEmailUseCase;

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

    // TODO temp request

    final (
      :firstName,
      :lastName,
      :email,
      :password,
    ) = _getUserDetailsFromValidatedRequestBody(validatedBodyData);

    final AuthModel? auth = await _getAuthByEmailUseCase(email);
    if (auth != null) {
      final Response response = _generateFailureResponse(
        message: "User with email already exists",
        statusCode: HttpStatus.conflict,
      );
      return response;
    }

    return Response(HttpStatus.ok);
  }

  ({String firstName, String lastName, String email, String password})
  _getUserDetailsFromValidatedRequestBody(Map<String, dynamic> data) {
    final String firstName =
        data[RegisterWithUserAndPasswordRequestBodyConstants.FIRST_NAME.value];
    final String lastName =
        data[RegisterWithUserAndPasswordRequestBodyConstants.LAST_NAME.value];
    final String email =
        data[RegisterWithUserAndPasswordRequestBodyConstants.EMAIL.value];
    final String password =
        data[RegisterWithUserAndPasswordRequestBodyConstants.PASSWORD.value];

    return (
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
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
