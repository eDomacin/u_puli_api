import 'package:u_puli_api/src/features/auth/domain/models/auth_user_model.dart';
import 'package:u_puli_api/src/features/auth/domain/repositories/auth_repository.dart';

class GetAuthUserUseCase {
  const GetAuthUserUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<AuthUserModel?> call(int authId) async {
    final AuthUserModel? authUser = await _authRepository.getAuthUser(authId);

    return authUser;
  }
}
