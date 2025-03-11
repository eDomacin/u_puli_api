import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:u_puli_api/src/utils/constants/request_constants.dart';

extension RequestExtension on Request {
  Future<Map<String, dynamic>?> parseBody() async {
    try {
      final bodyString = await readAsString();
      final body = jsonDecode(bodyString) as Map<String, dynamic>;

      return body;
    } catch (e, s) {
      // TODO remove all prints
      print("There was an issue parsing the body -> error: $e, stackTrace: $s");
      return null;
    }
  }

  Request getChangedRequestWithValidatedBodyData(Map<String, dynamic> data) {
    final Request changedRequest = change(
      context: {RequestConstants.VALIDATED_BODY_DATA.value: data},
    );

    return changedRequest;
  }
}
