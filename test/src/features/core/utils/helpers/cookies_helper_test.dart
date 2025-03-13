import 'dart:io';

import 'package:test/test.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/cookies_helper.dart';

void main() {
  final CookiesHelper cookieHelper = CookiesHelper();

  group("$CookiesHelper", () {
    group("createCookie()", () {
      test("given required parameters "
          "when createCookie() is called "
          "then should return expected [Cookie]", () async {
        // setup

        // given
        final String name = "name";
        final String value = "value";

        // when
        final Cookie cookie = cookieHelper.createCookie(
          name: name,
          value: value,
        );

        // then
        print("Hello, world!");
        // TODO write expectations

        // cleanup
      });
    });
  });
}
