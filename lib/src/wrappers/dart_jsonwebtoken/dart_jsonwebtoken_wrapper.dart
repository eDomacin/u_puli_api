import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:u_puli_api/src/features/core/domain/exceptions/jwt_exceptions.dart';

// TODO: This is very hard to test
class DartJsonwebtokenWrapper {
  const DartJsonwebtokenWrapper(this._jwtSecret);

  final String _jwtSecret;

  String sign({
    required Map<String, dynamic> payload,
    required Duration expiresIn,
  }) {
    final JWT jwt = JWT(payload);
    final String token = jwt.sign(SecretKey(_jwtSecret), expiresIn: expiresIn);

    return token;
  }

  T verify<T>(String token) {
    try {
      final JWT jwt = JWT.verify(token, SecretKey(_jwtSecret));
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
