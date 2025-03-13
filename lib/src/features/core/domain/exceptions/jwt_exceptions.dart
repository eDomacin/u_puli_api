sealed class JWTException implements Exception {
  const JWTException(this.message);

  final String message;

  @override
  String toString() {
    return 'JWTException: $message';
  }
}

class JwtExpiredException extends JWTException {
  const JwtExpiredException(Object error)
    : super('JWT token has expired\n -> error: $error');
}

class JwtInvalidException extends JWTException {
  const JwtInvalidException(Object error)
    : super('JWT token is invalid\n -> error: $error');
}
