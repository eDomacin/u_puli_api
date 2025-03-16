// class AuthJwtPayloadValue {
//   const AuthJwtPayloadValue({required this.authId});
//   final int authId;
// }

sealed class AuthJwtPayloadValue {
  const AuthJwtPayloadValue();
}

class AuthJwtPayloadValidValue extends AuthJwtPayloadValue {
  const AuthJwtPayloadValidValue({required this.authId});

  final int authId;
}

class AuthJwtPayloadMissingDataValue extends AuthJwtPayloadValue {
  const AuthJwtPayloadMissingDataValue();
}

class AuthJwtPayloadInvalidValue extends AuthJwtPayloadValue {
  const AuthJwtPayloadInvalidValue();
}

class AuthJwtPayloadExpiredValue extends AuthJwtPayloadValue {
  const AuthJwtPayloadExpiredValue();
}
