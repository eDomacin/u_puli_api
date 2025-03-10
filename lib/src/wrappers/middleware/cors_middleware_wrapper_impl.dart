import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/wrappers/middleware/middleware_wrapper.dart';

class CorsMiddlewareWrapper implements MiddlewareWrapper {
  CorsMiddlewareWrapper();

  @override
  Middleware get middleware => createMiddleware(
    requestHandler: _handleRequest,
    responseHandler: _handleResponse,
  );

  final _corsHeaders = {
    HttpHeaders.accessControlAllowOriginHeader: '*',
    // HttpHeaders.accessControlAllowOriginHeader: 'http://localhost:3000',
    HttpHeaders.accessControlAllowMethodsHeader:
        'GET, POST, PUT, DELETE, OPTIONS',
    HttpHeaders.accessControlAllowHeadersHeader: '*',
  };

  Response? _handleRequest(Request request) {
    if (request.method == "OPTIONS") {
      return Response.ok(null, headers: _corsHeaders);
    }

    // go through to the next handler
    return null;
  }

  Response _handleResponse(Response response) {
    // attach cors headers to the response
    return response.change(headers: _corsHeaders);
  }
}

/* just examples */
// - https://appvesto.medium.com/how-to-add-cors-to-the-dart-server-9d55a2835397
// - https://gist.github.com/graphicbeacon/e9186517767f7a86c9d24e79a09b8c3a
// - https://stackoverflow.com/questions/71639338/how-to-add-cors-middleware-in-shelf-with-router
// - https://stackoverflow.com/questions/78888063/the-client-side-doesnt-recognizes-the-cors-from-a-dart-server
// - https://www.reddit.com/r/dartlang/comments/n4m9mm/shelf_cors_headers_library/
// - https://oldmetalmind.medium.com/dart-shelf-backend-with-dart-f068d4f37a7a

// const _allowedOrigins = ["http://localhost:3000", "http://localhost:3001"];

// Map<String, String> _getCorsHeaders(String origin) {
//   return {
//     HttpHeaders.accessControlAllowOriginHeader: origin,
//     HttpHeaders.accessControlAllowMethodsHeader:
//         'GET, POST, PUT, DELETE, OPTIONS',
//     HttpHeaders.accessControlAllowHeadersHeader: '*',
//   };
// }

// Response? _corsRequestHandler(Request request) {
//   final String? origin = request.headers["origin"];
//   if (origin == null) return Response.forbidden("Origin is required");

//   // handle preflight request
//   if (request.method == "OPTIONS") {
//     return Response.ok(null, headers: _getCorsHeaders(origin));
//   }

//   // now we know it's not an OPTIONS request and we can check if the origin is allowed
//   if (!_allowedOrigins.contains(origin)) {
//     return Response.forbidden("Origin is not allowed");
//   }

//   // allow the request go through
//   return null;
// }

// Response _corsResponseHandler(Response response) {
//   return response.cha
// }

// only one allowed

// const _corsHeaders = {
//   // HttpHeaders.accessControlAllowOriginHeader: '*',
//   HttpHeaders.accessControlAllowOriginHeader: 'http://localhost:3000',
//   HttpHeaders.accessControlAllowMethodsHeader:
//       'GET, POST, PUT, DELETE, OPTIONS',
//   HttpHeaders.accessControlAllowHeadersHeader: '*',
// };

// Response? _options(Request request) {
//   // return null;

//   print("OPTIONS: ${request.method}");
//   return request.method == "OPTIONS"
//       ? Response.ok(null, headers: _corsHeaders)
//       : null;
// }

// Response _cors(Response response) {
//   return response.change(headers: _corsHeaders);
//   // return response;
// }

// final Middleware _fixCors = createMiddleware(
//   requestHandler: _options,
//   responseHandler: _cors,
// );
