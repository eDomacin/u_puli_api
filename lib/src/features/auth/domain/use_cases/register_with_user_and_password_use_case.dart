import 'package:u_puli_api/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:u_puli_api/src/features/auth/domain/values/create_auth_value.dart';

class RegisterWithUserAndPasswordUseCase {
  const RegisterWithUserAndPasswordUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<int> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final CreateEmailPasswordAuthEntityDataValue data =
        CreateEmailPasswordAuthEntityDataValue(
          firstName: firstName,
          lastName: lastName,
          email: email,
          hashedPassword: password,
        );

    final int id = await _authRepository.registerWithUserAndPassword(data);

    return id;
  }
}
