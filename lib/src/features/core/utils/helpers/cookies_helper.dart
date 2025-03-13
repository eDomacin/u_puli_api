// TODO check if this really needs to eb instantiated - maybe it can be a static class

import 'dart:io';

class CookiesHelper {
  Cookie createCookie({
    required String name,
    required String value,
    // TODO not sure about this - will come back to it
    Duration? maxAge,
    bool isHttpOnly = true,
    bool isSecure = true,
    String path = '/',
  }) {
    final Cookie cookie =
        Cookie(name, value)
          ..httpOnly = isHttpOnly
          ..secure = isSecure
          ..path = path
          // TODO not sure about this - will come back to it
          ..maxAge = maxAge?.inSeconds;

    return cookie;
  }
}


/* TODO could use string as well maybe 


    final httpOnly = "HttpOnly";
    final secure = "Secure";
    final name = "refresh_token";
    // TODO what is path
    final path = "/";

    final cookieString = "$name=$jwt; $httpOnly; $secure; Path=$path";
    final cookie = Cookie.fromSetCookieValue(cookieString);

    return cookie;







 */