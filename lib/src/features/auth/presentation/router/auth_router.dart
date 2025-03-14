import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:u_puli_api/src/features/auth/presentation/controllers/login_with_email_and_password_controller.dart';
import 'package:u_puli_api/src/features/auth/presentation/controllers/register_with_email_and_password_controller.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/middleware/middleware_helper/validate_login_with_email_and_password_request_body_middleware_helper.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/middleware/middleware_helper/validate_register_with_email_and_password_request_body_middleware_helper.dart';

class AuthRouter {
  AuthRouter({
    required RegisterWithEmailAndPasswordController
    registerWithEmailAndPasswordController,
    required LoginWithEmailAndPasswordController
    loginWithEmailAndPasswordController,
    required ValidateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper
    validateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper,
    required ValidateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper
    validateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper,

    // maybe all this DI is an overkill? maybe it can be done via get it on this level already - the router itself can access get it? and test of the layers can get dependencies from constructors?
  }) : _router = Router() {
    _router.post(
      "/login",
      Pipeline()
          .addMiddleware(
            validateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper(),
          )
          .addHandler(loginWithEmailAndPasswordController.call),
    );
    _router.post(
      "/register",
      Pipeline()
          .addMiddleware(
            validateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper(),
          )
          .addHandler(registerWithEmailAndPasswordController.call),
    );
  }

  final Router _router;
  Router get router => _router;
}
