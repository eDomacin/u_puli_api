import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:u_puli_api/src/features/search/presentation/controllers/search_controller.dart';
import 'package:u_puli_api/src/features/search/utils/helpers/middleware/middleware_helpers/validate_search_request_middleware_helper.dart';

class SearchRouter {
  SearchRouter({
    required SearchController searchController,
    required ValidateSearchRequestMiddlewareHelper
    validateSearchRequestMiddlewareHelper,
  }) : _router = Router() {
    _router.get(
      "/",
      Pipeline()
          .addMiddleware(validateSearchRequestMiddlewareHelper())
          .addHandler(searchController.call),
    );
  }

  final Router _router;
  Router get router => _router;
}
