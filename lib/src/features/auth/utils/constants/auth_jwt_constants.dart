enum AuthJwtNameConstants { ACCESS_JWT, REFRESH_JWT }

enum AuthJwtDurationConstants {
  ACCESS_JWT_DURATION._(Duration(minutes: 15)),
  REFRESH_JWT_DURATION._(Duration(days: 7));

  const AuthJwtDurationConstants._(this.value);
  final Duration value;
}

enum AuthJwtPayloadKeysConstants {
  AUTH_ID._("auth_id");

  const AuthJwtPayloadKeysConstants._(this.value);
  final String value;
}
