import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/auth/domain/use_cases/register_with_user_and_password_use_case.dart';

class RegisterWithUserAndPasswordController {
  const RegisterWithUserAndPasswordController({
    required RegisterWithUserAndPasswordUseCase
    registerWithUserAndPasswordUseCase,
  }) : _registerWithUserAndPasswordUseCase = registerWithUserAndPasswordUseCase;

  final RegisterWithUserAndPasswordUseCase _registerWithUserAndPasswordUseCase;

  Future<Response> call(Request request) async {
    return Response(HttpStatus.ok);
  }
}


// TODO create ResponseGenerator class