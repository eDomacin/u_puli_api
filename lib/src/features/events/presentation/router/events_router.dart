import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:u_puli_api/src/auth/utils/helpers/middleware/middleware_helper/validate_register_with_email_and_password_request_body_middleware_helper.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_event_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_events_controller.dart';

// NOTE: this router is independent - placed after "events" path in the main router
class EventsRouter {
  EventsRouter({
    required GetEventController getEventController,
    required GetEventsController getEventsController,
  }) : _router = Router() {
    // TODO test only
    _router.post(
      "/test",
      Pipeline()
          .addMiddleware(
            ValidateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper()
                .call(),
          )
          .addHandler((Request request) async {
            return Response.ok("test");
          }),
    );

    _router.get("/", getEventsController.call);
    // Dynamic routes have to be last, so as not to catch other routes requests
    _router.get("/<id>", getEventController.call);
  }

  final Router _router;
  Router get router => _router;
}
