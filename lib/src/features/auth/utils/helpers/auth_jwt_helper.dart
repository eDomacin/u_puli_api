import 'package:u_puli_api/src/features/auth/domain/values/auth_jwt_payload_value.dart';
import 'package:u_puli_api/src/features/auth/utils/constants/auth_jwt_constants.dart';
import 'package:u_puli_api/src/wrappers/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

class AuthJWTHelper {
  const AuthJWTHelper({
    required DartJsonwebtokenWrapper dartJsonwebtokenWrapper,
  }) : _dartJsonwebtokenWrapper = dartJsonwebtokenWrapper;

  final DartJsonwebtokenWrapper _dartJsonwebtokenWrapper;

  String generateAccessJWT({required int authId}) {
    final Map<String, dynamic> payload = _generatePayload(authId: authId);

    final String token = _dartJsonwebtokenWrapper.sign(
      payload: payload,
      expiresIn: AuthJwtDurationConstants.ACCESS_JWT_DURATION.value,
    );

    return token;
  }

  String generateRefreshJWT({required int authId}) {
    final Map<String, dynamic> payload = _generatePayload(authId: authId);

    final String token = _dartJsonwebtokenWrapper.sign(
      payload: payload,
      expiresIn: AuthJwtDurationConstants.REFRESH_JWT_DURATION.value,
    );

    return token;
  }

  Map<String, dynamic> _generatePayload({required int authId}) {
    final Map<String, dynamic> payload = {
      AuthJwtPayloadKeysConstants.AUTH_ID.value: authId,
    };

    return payload;
  }

  AuthJwtPayloadValue? verifyAccessJWT(String token) {
    final Map<String, dynamic> payload = _dartJsonwebtokenWrapper
        .verify<Map<String, dynamic>>(token);

    final int? authId =
        payload[AuthJwtPayloadKeysConstants.AUTH_ID.value] as int?;

    if (authId == null) {
      return null;
    }

    final AuthJwtPayloadValue authJwtPayloadValue = AuthJwtPayloadValue(
      authId: authId,
    );
    return authJwtPayloadValue;
  }
}
