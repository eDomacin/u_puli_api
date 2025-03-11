import 'package:u_puli_api/src/auth/data/entities/auth_entity.dart';

class AuthEntityValue {
  AuthEntityValue({
    required this.id,
    required this.email,
    required this.authType,
  });

  final int id;
  final String email;
  final AuthType authType;
}
