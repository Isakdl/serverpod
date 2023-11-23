import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

DatabaseDefinition generateDatabaseDefinition({
  required GeneratorConfig config,
  required List<DatabaseMigrationVersion> installedModules,
  required List<ProtocolSource> protocols,
}) {
  var entityDefinitions = StatefulAnalyzer(protocols).validateAll();

  return createDatabaseDefinitionFromEntities(
    entityDefinitions,
    installedModules,
    config,
  );
}
