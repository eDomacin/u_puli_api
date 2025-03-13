import 'package:hashlib/hashlib.dart';

class HashlibWrapper {
  final BcryptSecurity _bcryptSecurity = BcryptSecurity.moderate;

  String generateEncodedString(String plainString) {
    final List<int> plainStringCodeUnits = plainString.codeUnits;

    final String encodedString = bcrypt(
      plainStringCodeUnits,
      bcryptSalt(security: _bcryptSecurity),
    );

    return encodedString;
  }

  bool verifyEncodedString(String encodedString, String plainString) {
    final bool isMatch = bcryptVerify(encodedString, plainString.codeUnits);

    return isMatch;
  }
}
