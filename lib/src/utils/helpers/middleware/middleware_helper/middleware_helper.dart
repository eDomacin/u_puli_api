import 'package:shelf/shelf.dart';

abstract interface class MiddlewareHelper {
  Middleware call();
}

// TODO move this to dart docs
/* 
// Classes implementing the interface need to have a single method - call
// The method should return a [Middleware] type, as in the examples below
```dart
class ExampleMiddlewareHelper implements MiddlewareHelper {
  @override
  Middleware call() {
    // TODO: implement call
    throw UnimplementedError();
  }

  // Simple example of a class implementing the interface
  Middleware simpleMiddlware() {
    return (Handler innerHandler) {
      return (Request request) {
        // do something with the request
        // This the block where the middleware logic is implemented:
        // - request body validation
        // - auth cookie validation
        // - etc.

        // It is possible to return a response here. For example, if the request is invalid
        // return Response(HttpStatus.badRequest);

        final validatedRequest = request.change();
        return innerHandler(validatedRequest);
      };
    };
  }

  // More complex - allows for error handling and response modification
  Middleware complexMiddleware() {
    return (Handler innerHandler) {
      return (Request request) {
        final changedRequest = request.change();

        return Future.sync(() => innerHandler(changedRequest)).then(
          (response) {
            final changedResponse = response.change(
              headers: {"X-Example-Header": "Example Header Value"},
            );

            return changedResponse;
          },
          onError: (Object error, StackTrace stackTrace) {
            print("Error in $ExampleMiddlewareHelper");

            // TODO not sure where is this going to propagate in
            throw error;
          },
        );
      };
    };
  }

  // More readable version of the complex middleware - uses separate functions for the middleware logic and error handling
  // Also uses async/await and try/catch for error handling
  Middleware awaitTryCatchMiddleware() {
    // define middleware function that will provide the endpoint controller to the middleware, so we can pass it the modified request.
    // This function will be called automatically by the pipeline
    Future<Response> Function(Request request) middleware(
      Handler innerHandler,
    ) {
      // define function that handles the request - this is effectively the middleware logic
      Future<Response> requestHandler(Request request) async {
        final validatedRequest = request.change();

        try {
          // we will get the response once the inner handler is done
          //  - inner handler is the function that handles the request - aka, the endpoint controller
          final Response response = await Future.sync(
            () => innerHandler(validatedRequest),
          );

          // return the response
          // we could modify the response here
          return response;
        } catch (error) {
          print("Error in $ExampleMiddlewareHelper");
          rethrow;
        }
      }

      // return the function that handles the request - this is the middleware logic
      return requestHandler;
    }

    // return the middleware
    return middleware;
  }
}
```
 */
