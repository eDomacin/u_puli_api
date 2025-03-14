import 'package:u_puli_api/src/features/auth/data/entities/auth_entity.dart';

class AuthEntityValue {
  AuthEntityValue({
    required this.id,
    required this.email,
    required this.authType,
    required this.password,
  });

  final int id;
  final String email;
  final AuthType authType;
  final String? password;
}


// TODO some of these are not needed