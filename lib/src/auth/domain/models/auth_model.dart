import 'package:u_puli_api/src/auth/data/entities/auth_entity.dart';

class AuthModel {
  // TODO this should have toJson method probably

  const AuthModel({
    required this.id,
    required this.email,
    required this.authType,
  });

  final int id;
  final String email;
  final AuthType authType;
}
