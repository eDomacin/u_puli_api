import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_user_model.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/get_auth_by_email_use_case.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/get_auth_user_use_case.dart';
import 'package:u_puli_api/src/features/auth/utils/constants/login_with_user_and_password_request_body_constants.dart';
import 'package:u_puli_api/src/features/auth/utils/extensions/cookies_helper_auth_extension.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/auth_jwt_helper.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/encode_password_helper.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/cookies_helper.dart';
import 'package:u_puli_api/src/utils/extensions/request_extension.dart';

class LoginWithEmailAndPasswordController {
  const LoginWithEmailAndPasswordController({
    required GetAuthUserUseCase getAuthUserUseCase,
    required GetAuthByEmailUseCase getAuthByEmailUseCase,
    required EncodePasswordHelper encodePasswordHelper,
    required AuthJWTHelper authJWTHelper,
    required CookiesHelper cookiesHelper,
  }) : _getAuthUserUseCase = getAuthUserUseCase,
       _getAuthByEmailUseCase = getAuthByEmailUseCase,
       _encodePasswordHelper = encodePasswordHelper,
       _authJWTHelper = authJWTHelper,
       _cookiesHelper = cookiesHelper;

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

    final (:email, :password) = _getLoginDetailsFromValidatedRequestBody(
      validatedBodyData,
    );

    final AuthModel? auth = await _getAuthByEmailUseCase(email);

    // TODO we could extract this to clean up the code
    if (auth == null) {
      final Response response = _generateFailureResponse(
        message:
            "Invalid credentials provided. Please try again with valid credentials",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    final String? authPassword = auth.password;
    if (authPassword == null) {
      final Response response = _generateFailureResponse(
        message:
            'Invalid credentials provided. Please try again with valid credentials',
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    final bool isPasswordMatch = _encodePasswordHelper.verifyEncodedPassword(
      authPassword,
      password,
    );
    if (!isPasswordMatch) {
      final Response response = _generateFailureResponse(
        message:
            "Invalid credentials provided. Please try again with valid credentials",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    final AuthUserModel? authUser = await _getAuthUserUseCase(auth.id);
    // this should never happen
    if (authUser == null) {
      final Response response = _generateFailureResponse(
        message: "User not found",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final String accessToken = _authJWTHelper.generateAccessJWT(
      authId: auth.id,
    );
    final String refreshToken = _authJWTHelper.generateRefreshJWT(
      authId: auth.id,
    );

    final Cookie refreshTokenCookie = _cookiesHelper.createRefreshJWTCookie(
      refreshToken,
    );

    final Response response = _generateSuccessResponse(
      message: "User logged in successfully",
      statusCode: HttpStatus.ok,
      isOk: true,
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

typedef _LoginDetailsFromValidatedRequestBody =
    ({String email, String password});

_LoginDetailsFromValidatedRequestBody _getLoginDetailsFromValidatedRequestBody(
  Map<String, dynamic> data,
) {
  final String email =
      data[LoginWithUserAndPasswordRequestBodyConstants.EMAIL.value];
  final String password =
      data[LoginWithUserAndPasswordRequestBodyConstants.PASSWORD.value];

  return (email: email, password: password);
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
