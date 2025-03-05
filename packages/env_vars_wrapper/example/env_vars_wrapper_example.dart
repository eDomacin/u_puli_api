import 'package:env_vars_wrapper/env_vars_wrapper.dart';

void main() {
  // NOTE: This should never run, because it will fail
  final envVarsWrapper = EnvVarsWrapper();
  print(envVarsWrapper);
}
