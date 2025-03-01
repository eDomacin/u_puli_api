import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRouter {
  AppRouter() : _router = Router() {
    _router.get('/', _rootHandler);
    _router.get('/echo/<message>', _echoHandler);
  }

  final Router _router;

  Response _rootHandler(Request req) {
    return Response.ok('Hello, World!\n');
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }

  Router get router => _router;
}
