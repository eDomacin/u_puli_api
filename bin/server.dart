import 'package:u_puli_api/src/app.dart';

Future<void> main(List<String> args) async {
  final app = App();

  final server = await app.start();
  print('Server listening on port ${server.port}, on IP address ${app.ip}');
}
