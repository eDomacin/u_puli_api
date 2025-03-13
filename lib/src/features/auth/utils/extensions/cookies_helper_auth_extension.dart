import 'dart:io';

import 'package:u_puli_api/src/features/auth/utils/constants/auth_jwt_constants.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/cookies_helper.dart';

extension CookiesHelperAuthExtension on CookiesHelper {
  Cookie createRefreshJWTCookie(String token) {
    final Cookie cookie = createCookie(
      name: AuthJwtNameConstants.REFRESH_JWT.name,
      value: token,
      isHttpOnly: true,
      isSecure: true,
    );

    return cookie;
  }
}
