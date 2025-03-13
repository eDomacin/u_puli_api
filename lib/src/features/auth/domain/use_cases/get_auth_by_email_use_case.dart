import 'package:u_puli_api/src/features/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/features/auth/domain/repositories/auth_repository.dart';

class GetAuthByEmailUseCase {
  const GetAuthByEmailUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<AuthModel?> call(String email) async {
    final AuthModel? auth = await _authRepository.getAuthByEmail(email);

    return auth;
  }
}
