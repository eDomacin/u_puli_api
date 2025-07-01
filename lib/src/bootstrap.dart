import 'dart:io';

import 'package:database_wrapper/database_wrapper.dart';
import 'package:env_vars_wrapper/env_vars_wrapper.dart';
import 'package:u_puli_api/src/app.dart';
import 'package:u_puli_api/src/app_router.dart';
import 'package:u_puli_api/src/features/auth/data/data_sources/auth_data_source.dart';
import 'package:u_puli_api/src/features/auth/data/data_sources/auth_data_source_impl.dart';
import 'package:u_puli_api/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:u_puli_api/src/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/get_auth_by_email_use_case.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/get_auth_user_use_case.dart';
import 'package:u_puli_api/src/features/auth/domain/use_cases/register_with_user_and_password_use_case.dart';
import 'package:u_puli_api/src/features/auth/presentation/controllers/login_with_email_and_password_controller.dart';
import 'package:u_puli_api/src/features/auth/presentation/controllers/register_with_email_and_password_controller.dart';
import 'package:u_puli_api/src/features/auth/presentation/router/auth_router.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/auth_jwt_helper.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/encode_password_helper.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/middleware/middleware_helper/authenticate_request_middleware_helper.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/middleware/middleware_helper/validate_login_with_email_and_password_request_body_middleware_helper.dart';
import 'package:u_puli_api/src/features/auth/utils/helpers/middleware/middleware_helper/validate_register_with_email_and_password_request_body_middleware_helper.dart';
import 'package:u_puli_api/src/features/core/utils/helpers/cookies_helper.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source_impl.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository_impl.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/create_event_use_case.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/get_event_use_case.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/get_events_use_case.dart';
import 'package:u_puli_api/src/features/events/domain/use_cases/update_event_use_case.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/create_event_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_event_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/get_events_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/controllers/update_event_controller.dart';
import 'package:u_puli_api/src/features/events/presentation/router/events_router.dart';
import 'package:u_puli_api/src/features/events/utils/helpers/middleware/middleware_helper/validate_create_event_request_body_middleware_helper.dart';
import 'package:u_puli_api/src/features/events/utils/helpers/middleware/middleware_helper/validate_get_events_request_middleware_helper.dart';
import 'package:u_puli_api/src/features/events/utils/helpers/middleware/middleware_helper/validate_update_event_request_body_middleware_helper.dart';
import 'package:u_puli_api/src/wrappers/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import 'package:u_puli_api/src/wrappers/get_id/get_it_wrapper.dart';
import 'package:u_puli_api/src/wrappers/hashlib/hashlib_wrapper.dart';

Future<void> bootstrap() async {
  final EnvVarsWrapper envVarsWrapper = EnvVarsWrapper();

  final DatabaseWrapper databaseWrapper = _getInitializedDatabaseWrapper(
    envVarsWrapper: envVarsWrapper,
  );
  final AppRouter appRouter = _getInitializedAppRouter(
    databaseWrapper: databaseWrapper,
    jwtAccessSecret: envVarsWrapper.jwtAccessSecret,
    jwtRefreshSecret: envVarsWrapper.jwtRefreshSecret,
  );
  // TODO move to env vars wrapper
  final int port = int.parse(Platform.environment['PORT'] ?? '8080');
  final InternetAddress ip = InternetAddress.anyIPv4;

  final App app = App(ip: ip, port: port, appRouter: appRouter);

  final HttpServer server = await app.start();
  print('Server listening on port ${server.port}, on IP address ${app.ip}');
}

DatabaseWrapper _getInitializedDatabaseWrapper({
  required EnvVarsWrapper envVarsWrapper,
}) {
  final DatabaseEndpointDataValue endpointData = DatabaseEndpointDataValue(
    pgHost: envVarsWrapper.pgHost,
    pgDatabase: envVarsWrapper.pgDatabase,
    pgUser: envVarsWrapper.pgUser,
    pgPassword: envVarsWrapper.pgPassword,
    pgPort: envVarsWrapper.pgPort,
  );

  final DatabaseWrapper databaseWrapper = DatabaseWrapper.app(
    endpointData: endpointData,
  );

  databaseWrapper.initialize();

  getIt.registerSingleton<DatabaseWrapper>(databaseWrapper);

  final anotherDbWrapper = getIt.get<DatabaseWrapper>();

  print('anotherDbWrapper: $anotherDbWrapper');

  return databaseWrapper;
}

// TODO split this into multiple functions
// TODO clean up this function
AppRouter _getInitializedAppRouter({
  required DatabaseWrapper databaseWrapper,
  required String jwtAccessSecret,
  required String jwtRefreshSecret,
}) {
  // wrappers
  final HashlibWrapper hashlibWrapper = HashlibWrapper();
  final DartJsonwebtokenWrapper dartJsonwebtokenWrapper =
      DartJsonwebtokenWrapper(
        jwtAccessSecret: jwtAccessSecret,
        jwtRefreshSecret: jwtRefreshSecret,
      );

  // helpers
  final EncodePasswordHelper encodePasswordHelper = EncodePasswordHelper(
    hashlibWrapper: hashlibWrapper,
  );
  final AuthJWTHelper authJWTHelper = AuthJWTHelper(
    dartJsonwebtokenWrapper: dartJsonwebtokenWrapper,
  );
  final CookiesHelper cookiesHelper = CookiesHelper();

  // middlewares helpers
  final ValidateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper
  validateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper =
      ValidateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper();
  final ValidateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper
  validateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper =
      ValidateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper();
  final ValidateCreateEventRequestBodyMiddlewareHelper
  validateCreateEventRequestBodyMiddlewareHelper =
      ValidateCreateEventRequestBodyMiddlewareHelper();
  final ValidateUpdateEventRequestBodyMiddlewareHelper
  validateUpdateEventRequestBodyMiddlewareHelper =
      ValidateUpdateEventRequestBodyMiddlewareHelper();
  final AuthenticateRequestMiddlewareHelper
  authenticateRequestMiddlewareHelper = AuthenticateRequestMiddlewareHelper(
    authJWTHelper: authJWTHelper,
  );
  final ValidateGetEventsRequestMiddlewareHelper
  validateGetEventsRequestMiddlewareHelper =
      ValidateGetEventsRequestMiddlewareHelper();

  // data surces
  final EventsDataSource eventsDataSource = EventsDataSourceImpl(
    databaseWrapper: databaseWrapper,
  );
  final AuthDataSource authDataSource = AuthDataSourceImpl(
    databaseWrapper: databaseWrapper,
  );

  // repositories
  final EventsRepository eventsRepository = EventsRepositoryImpl(
    eventsDataSource: eventsDataSource,
  );
  final AuthRepository authRepository = AuthRepositoryImpl(
    authDataSource: authDataSource,
  );

  // use cases
  final GetEventUseCase getEventUseCase = GetEventUseCase(
    eventsRepository: eventsRepository,
  );
  final GetEventsUseCase getEventsUseCase = GetEventsUseCase(
    eventsRepository: eventsRepository,
  );
  final RegisterWithUserAndPasswordUseCase registerWithUserAndPasswordUseCase =
      RegisterWithUserAndPasswordUseCase(authRepository: authRepository);
  final GetAuthByEmailUseCase getAuthByEmailUseCase = GetAuthByEmailUseCase(
    authRepository: authRepository,
  );
  final GetAuthUserUseCase getAuthUserUseCase = GetAuthUserUseCase(
    authRepository: authRepository,
  );
  final CreateEventUseCase createEventUseCase = CreateEventUseCase(
    eventsRepository: eventsRepository,
  );
  final UpdateEventUseCase updateEventUseCase = UpdateEventUseCase(
    eventsRepository: eventsRepository,
  );

  // controllers
  final GetEventController getEventController = GetEventController(
    getEventUseCase: getEventUseCase,
  );
  final GetEventsController getEventsController = GetEventsController(
    getEventsUseCase: getEventsUseCase,
  );
  final RegisterWithEmailAndPasswordController
  registerWithEmailAndPasswordController =
      RegisterWithEmailAndPasswordController(
        registerWithUserAndPasswordUseCase: registerWithUserAndPasswordUseCase,
        getAuthUserUseCase: getAuthUserUseCase,
        getAuthByEmailUseCase: getAuthByEmailUseCase,
        encodePasswordHelper: encodePasswordHelper,
        authJWTHelper: authJWTHelper,
        cookiesHelper: cookiesHelper,
      );
  final LoginWithEmailAndPasswordController
  loginWithEmailAndPasswordController = LoginWithEmailAndPasswordController(
    getAuthUserUseCase: getAuthUserUseCase,
    getAuthByEmailUseCase: getAuthByEmailUseCase,
    encodePasswordHelper: encodePasswordHelper,
    authJWTHelper: authJWTHelper,
    cookiesHelper: cookiesHelper,
  );

  final CreateEventController createEventController = CreateEventController(
    createEventUseCase: createEventUseCase,
  );
  final UpdateEventController updateEventController = UpdateEventController(
    updateEventUseCase: updateEventUseCase,
  );

  // routers
  final EventsRouter eventsRouter = EventsRouter(
    getEventController: getEventController,
    getEventsController: getEventsController,
    createEventController: createEventController,
    updateEventController: updateEventController,
    // middleware
    validateCreateEventRequestBodyMiddlewareHelper:
        validateCreateEventRequestBodyMiddlewareHelper,
    validateUpdateEventRequestBodyMiddlewareHelper:
        validateUpdateEventRequestBodyMiddlewareHelper,
    authenticateRequestMiddlewareHelper: authenticateRequestMiddlewareHelper,
    validateGetEventsRequestMiddlewareHelper:
        validateGetEventsRequestMiddlewareHelper,
  );
  final AuthRouter authRouter = AuthRouter(
    registerWithEmailAndPasswordController:
        registerWithEmailAndPasswordController,
    loginWithEmailAndPasswordController: loginWithEmailAndPasswordController,
    validateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper:
        validateRegisterWithEmailAndPasswordRequestBodyMiddlewareHelper,
    validateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper:
        validateLoginWithEmailAndPasswordRequestBodyMiddlewareHelper,
  );

  final AppRouter appRouter = AppRouter(
    eventsRouter: eventsRouter,
    authRouter: authRouter,
  );

  return appRouter;
}
