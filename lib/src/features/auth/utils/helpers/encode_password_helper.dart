import 'package:u_puli_api/src/wrappers/hashlib/hashlib_wrapper.dart';

class EncodePasswordHelper {
  const EncodePasswordHelper({required HashlibWrapper hashlibWrapper})
    : _hashlibWrapper = hashlibWrapper;

  final HashlibWrapper _hashlibWrapper;

  String encodePassword(String plainPassword) {
    final String encodedPassword = _hashlibWrapper.generateEncodedString(
      plainPassword,
    );

    return encodedPassword;
  }

  bool verifyEncodedPassword(String encodedPassword, String plainPassword) {
    final bool isMatch = _hashlibWrapper.verifyEncodedString(
      encodedPassword,
      plainPassword,
    );

    return isMatch;
  }
}
