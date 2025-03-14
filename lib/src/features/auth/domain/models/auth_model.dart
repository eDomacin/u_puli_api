import 'package:u_puli_api/src/features/auth/data/entities/auth_entity.dart';

// TODO this is not meant for sending to the client
class AuthModel {
  // TODO this should have toJson method probably

  const AuthModel({
    required this.id,
    required this.email,
    required this.authType,
    this.password,
  });

  final int id;
  final String email;
  final AuthType authType;
  final String? password;
}
