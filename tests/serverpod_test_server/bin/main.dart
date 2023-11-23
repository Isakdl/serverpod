import 'package:serverpod_test_server/server.dart';

void main(List<String> args) {
  run(['--mode', 'production', '--apply-migrations']);
}
