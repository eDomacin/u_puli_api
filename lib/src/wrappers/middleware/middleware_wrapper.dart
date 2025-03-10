import 'package:shelf/shelf.dart';

abstract class MiddlewareWrapper {
  const MiddlewareWrapper();
  Middleware get middleware;
}
