import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:u_puli_api/src/features/core/domain/exceptions/jwt_exceptions.dart';

// TODO: This is very hard to test
class DartJsonwebtokenWrapper {
  const DartJsonwebtokenWrapper({
    required String jwtAccessSecret,
    required String jwtRefreshSecret,
  }) : _jwtAccessSecret = jwtAccessSecret,
       _jwtRefreshSecret = jwtRefreshSecret;

  final String _jwtAccessSecret;
  final String _jwtRefreshSecret;

  String sign({
    required Map<String, dynamic> payload,
    required Duration expiresIn,
    required bool isAccessToken,
  }) {
    final String secret = isAccessToken ? _jwtAccessSecret : _jwtRefreshSecret;

    final JWT jwt = JWT(payload);
    final String token = jwt.sign(SecretKey(secret), expiresIn: expiresIn);

    return token;
  }

  T verify<T>({required String token, required bool isAccessToken}) {
    final String secret = isAccessToken ? _jwtAccessSecret : _jwtRefreshSecret;

    try {
      final JWT jwt = JWT.verify(token, SecretKey(secret));
      final payload = jwt.payload as T;

      return payload;
    } on JWTExpiredException catch (e) {
      throw JwtExpiredException(e);
    } catch (e) {
      throw JwtInvalidException(e);
    }
  }

  // TODO create separate helper for cookies - and it would have a method called cookieWithJwtToken or someting
}
