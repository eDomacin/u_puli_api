import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/create_event_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_event_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_events_controller.dart';
import 'package:u_puli_api/src/features/events/utils/helpers/middleware/middleware_helper/validate_create_event_request_body_middleware_helper.dart';

// NOTE: this router is independent - placed after "events" path in the main router
class EventsRouter {
  EventsRouter({
    required GetEventController getEventController,
    required GetEventsController getEventsController,
    required CreateEventController createEventController,

    // middleware
    required ValidateCreateEventRequestBodyMiddlewareHelper
    validateCreateEventRequestBodyMiddlewareHelper,
  }) : _router = Router() {
    _router.get("/", getEventsController.call);
    // Dynamic routes have to be last, so as not to catch other routes requests
    _router.get("/<id>", getEventController.call);
    _router.post(
      "/",
      Pipeline()
          .addMiddleware(validateCreateEventRequestBodyMiddlewareHelper())
          .addHandler(createEventController.call),
    );
  }

  final Router _router;
  Router get router => _router;
}
