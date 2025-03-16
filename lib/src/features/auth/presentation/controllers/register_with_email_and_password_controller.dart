import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_user_model.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/get_auth_by_email_use_case.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/get_auth_user_use_case.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/register_with_user_and_password_use_case.dart';
import 'package:u_puli_api/src/features/auth/utils/constants/register_with_user_and_password_request_body_constants.dart';
import 'package:u_puli_api/src/features/auth/utils/extensions/cookies_helper_auth_extension.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/auth_jwt_helper.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/cookies_helper.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/encode_password_helper.dart';

class RegisterWithEmailAndPasswordController {
  const RegisterWithEmailAndPasswordController({
    required RegisterWithUserAndPasswordUseCase
    registerWithUserAndPasswordUseCase,
    required GetAuthUserUseCase getAuthUserUseCase,
    required GetAuthByEmailUseCase getAuthByEmailUseCase,
    required EncodePasswordHelper encodePasswordHelper,
    required AuthJWTHelper authJWTHelper,
    required CookiesHelper cookiesHelper,
  }) : _registerWithUserAndPasswordUseCase = registerWithUserAndPasswordUseCase,
       _getAuthUserUseCase = getAuthUserUseCase,
       _getAuthByEmailUseCase = getAuthByEmailUseCase,
       _encodePasswordHelper = encodePasswordHelper,
       _authJWTHelper = authJWTHelper,
       _cookiesHelper = cookiesHelper;

  final RegisterWithUserAndPasswordUseCase _registerWithUserAndPasswordUseCase;
  final GetAuthUserUseCase _getAuthUserUseCase;
  final GetAuthByEmailUseCase _getAuthByEmailUseCase;

  final EncodePasswordHelper _encodePasswordHelper;
  final AuthJWTHelper _authJWTHelper;
  final CookiesHelper _cookiesHelper;

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

    final String encodedPassword = _encodePasswordHelper.encodePassword(
      password,
    );

    final int authId = await _registerWithUserAndPasswordUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: encodedPassword,
    );

    /* TODO get authuser model here - this is what we will use to send data  */
    final AuthUserModel? authUser = await _getAuthUserUseCase(authId);
    // TODO this should never happen
    if (authUser == null) {
      final Response response = _generateFailureResponse(
        message: "There was an issue retrieving the register user",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    // TODO all types that are not supposed to be returned to the client - should be converted to value classes

    final String accessToken = _authJWTHelper.generateAccessJWT(authId: authId);
    final String refreshToken = _authJWTHelper.generateRefreshJWT(
      authId: authId,
    );

    final Cookie refreshTokenCookie = _cookiesHelper.createRefreshJWTCookie(
      refreshToken,
    );

    final Response response = _generateSuccessResponse(
      message: "User registered successfully",
      statusCode: HttpStatus.ok,
      isOk: true,
      // TODO this should probably be some constant or some creator of this
      data: {
        "user": authUser.toJson(),
        "auth": {"accessToken": accessToken},
      },
      accessToken: accessToken,
      refreshTokenCookie: refreshTokenCookie,
    );

    return response;
  }
}

typedef _UserDetailsFromValidatedRequestBody =
    ({String firstName, String lastName, String email, String password});

_UserDetailsFromValidatedRequestBody _getUserDetailsFromValidatedRequestBody(
  Map<String, dynamic> data,
) {
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

Response _generateSuccessResponse({
  required String message,
  required int statusCode,
  required bool isOk,
  required Map<String, dynamic> data,
  required String accessToken,
  required Cookie refreshTokenCookie,
}) {
  final List<Cookie> cookies = [refreshTokenCookie];
  // TODO not sure about this - but we can see later if we have multiple cookies - maybe it is good
  // final String cookiesString = cookies.map((cookie) => cookie.toString()).join("; ");
  final List<String> cookiesStrings =
      cookies.map((cookie) => cookie.toString()).toList();

  final response = Response(
    statusCode,
    body: jsonEncode({"ok": isOk, "message": message, "data": data}),
    headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.setCookieHeader: cookiesStrings,
    },
  );

  return response;
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

// TODO add constants for response messages for this controlelr - something like 
/* 

class ResponseMessages {
  static const String requestBodyNotValidated = "Request body not validated";
  static const String userAlreadyExists = "User with email already exists";
  static const String userRegisteredSuccessfully = "User registered successfully";
}
 */