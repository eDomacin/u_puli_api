import 'package:database_wrapper/database_wrapper.dart';

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
