import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:u_puli_api/src/features/auth/presentation/router/auth_router.dart';
import 'package:u_puli_api/src/features/events/presentation/router/events_router.dart';

// TODO this should not live here - it should live in core/presentation/router - and be called CoreRouter? or maybe it is fine to be here?
class AppRouter {
  AppRouter({
    required EventsRouter eventsRouter,
    required AuthRouter authRouter,
  }) : _router = Router() {
    _router.get('/', _rootHandler);
    _router.get('/echo/<message>', _echoHandler);

    // our routes
    _router.mount('/events', eventsRouter.router.call);
    _router.mount('/auth', authRouter.router.call);
  }

  final Router _router;
  Router get router => _router;

  // controllers
  Response _rootHandler(Request request) {
    return Response.ok('Hello, World!\n');
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }
}


// TODO it would be good to have controller hold its own
// - http method
// - path

// this way we could have a route that lists all the routes and their methods by just looking at the controllers