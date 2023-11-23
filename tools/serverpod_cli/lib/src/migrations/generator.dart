import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

import '../util/protocol_helper.dart';

const _fileNameMigrationJson = 'migration.json';
const _fileNameDefinitionJson = 'definition.json';
const _fileNameMigrationSql = 'migration.sql';
const _fileNameDefinitionSql = 'definition.sql';

class MigrationGenerator {
  MigrationGenerator({
    required this.directory,
    required this.projectName,
  });
  final Directory directory;
  final String projectName;

  static String createVersionName(String? tag) {
    var now = DateTime.now().toUtc();
    var fmt = DateFormat('yyyyMMddHHmmss');
    var versionName = fmt.format(now);
    if (tag != null) {
      versionName += '-$tag';
    }
    return versionName;
  }

  Directory get migrationsBaseDirectory =>
      MigrationConstants.migrationsBaseDirectory(directory);

  Directory get migrationsProjectDirectory =>
      Directory(path.join(migrationsBaseDirectory.path, projectName));

  List<String> getMigrationModules() {
    if (!migrationsBaseDirectory.existsSync()) {
      return [];
    }
    var names = <String>[];
    var fileEntities = migrationsBaseDirectory.listSync();
    for (var entity in fileEntities) {
      if (entity is Directory) {
        names.add(path.basename(entity.path));
      }
    }
    names.sort();
    return names;
  }

  Future<MigrationVersion> getMigrationVersion(
    String versionName,
    String module,
  ) async {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        module,
      ),
    );
    try {
      return await MigrationVersion.load(
        moduleName: module,
        versionName: versionName,
        migrationsDirectory: migrationsDirectory,
      );
    } catch (e) {
      throw MigrationVersionLoadException(
        versionName: versionName,
        moduleName: module,
        exception: e.toString(),
      );
    }
  }

  Future<MigrationVersion?> getLatestMigrationVersion(
    String module,
  ) async {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        module,
      ),
    );

    var migrationRegistry = await MigrationRegistry.load(migrationsDirectory);

    var latestVersion = migrationRegistry.getLatest();
    if (latestVersion == null) {
      return null;
    }

    return await getMigrationVersion(
      latestVersion,
      module,
    );
  }

  Future<List<MigrationVersion>> getAllMigrationVersions(
    List<String> modules,
  ) async {
    var versions = <Future<MigrationVersion?>>[];
    for (var module in modules) {
      var moduleVersions = getLatestMigrationVersion(module);
      versions.add(moduleVersions);
    }
    var resolved = await Future.value(versions);
    return resolved.whereType<MigrationVersion>().toList();
  }

  Future<DatabaseDefinition> _getSourceDatabaseDefinition(
    String? latestVersion,
    List<DatabaseMigrationVersion> installedModules,
  ) async {
    if (latestVersion == null) {
      return DatabaseDefinition(
        tables: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
        installedModules: installedModules,
      );
    }

    var latest = await getMigrationVersion(latestVersion, projectName);
    return latest.databaseDefinition;
  }

  Future<MigrationVersion?> createMigration({
    String? tag,
    required bool force,
    required GeneratorConfig config,
    bool write = true,
  }) async {
    var migrationRegistry = await MigrationRegistry.load(
      migrationsProjectDirectory,
    );

    var protocols =
        await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);

    var moduleNames = config.modules.map((module) => module.name).toList();
    var migrationVersions = await getAllMigrationVersions(moduleNames);
    var installedModules = migrationVersions.map((m) {
      return DatabaseMigrationVersion(
        module: m.moduleName,
        version: m.versionName,
      );
    }).toList();

    var databaseSource = await _getSourceDatabaseDefinition(
      migrationRegistry.getLatest(),
      installedModules,
    );

    var databaseDestination = generateDatabaseDefinition(
      config: config,
      installedModules: installedModules,
      protocols: protocols,
    );

    var migration = generateDatabaseMigration(
      srcDatabase: databaseSource,
      dstDatabase: databaseDestination,
    );

    var warnings = migration.warnings;
    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return null;
    }

    if (migration.isEmpty && !force) {
      log.info('No changes detected.');
      return null;
    }

    var versionName = createVersionName(tag);
    var migrationVersion = MigrationVersion(
      moduleName: projectName,
      migrationsDirectory: migrationsProjectDirectory,
      versionName: versionName,
      migration: migration,
      databaseDefinition: databaseDestination,
    );

    // TODO merge all definitions from all dependencies

    // TODO create SQL content

    if (write) {
      // DO NOT WRITE SQL IN HERE
      await migrationVersion.write(module: projectName);
      migrationRegistry.add(versionName);
      await migrationRegistry.write();

      // TODO add writing sql
    }

    return migrationVersion;
  }

  Future<bool> repairMigration({
    String? tag,
    required bool force,
    required String runMode,
    RepairTargetMigration? targetMigration,
  }) async {
    Map<String, MigrationVersion> versions =
        await loadMigrationVersionsFromAllModules(
      targetMigration: targetMigration,
    );

    DatabaseDefinition dstDatabase =
        createDatabaseDefinitionFromTables(versions);

    var client = ConfigInfo(runMode).createServiceClient();
    DatabaseDefinition liveDatabase;
    try {
      liveDatabase = await client.insights.getLiveDatabaseDefinition();
    } catch (e) {
      throw MigrationLiveDatabaseDefinitionException(
        exception: e.toString(),
      );
    } finally {
      client.close();
    }

    var migration = generateDatabaseMigration(
      srcDatabase: liveDatabase,
      dstDatabase: dstDatabase,
    );

    var warnings = migration.warnings;
    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return false;
    }

    bool versionsMismatch = moduleVersionMismatch(liveDatabase, versions);

    if (migration.isEmpty && !versionsMismatch && !force) {
      log.info('No changes detected.');
      return false;
    }

    var repairMigrationName = createVersionName(tag);

    var moduleVersions = versions
        .map((key, value) => MapEntry<String, String>(key, value.versionName));
    moduleVersions[MigrationConstants.repairMigrationModuleName] =
        repairMigrationName;

    _writeRepairMigration(
      repairMigrationName,
      migration,
      moduleVersions,
    );

    return true;
  }

  bool moduleVersionMismatch(
    DatabaseDefinition liveDatabase,
    Map<String, MigrationVersion> versions,
  ) {
    var installedModules = liveDatabase.installedModules;
    if (installedModules == null) {
      return versions.isNotEmpty;
    }

    installedModules.removeWhere((module) =>
        module.module == MigrationConstants.repairMigrationModuleName);

    if (installedModules.length != versions.length) {
      return true;
    }

    for (var module in installedModules) {
      if (versions[module.module]?.versionName != module.version) {
        return true;
      }
    }

    return false;
  }

  DatabaseDefinition createDatabaseDefinitionFromTables(
    Map<String, MigrationVersion> versions,
  ) {
    var migrationDefinitions =
        versions.values.map((e) => e.databaseDefinition).toList();
    var dstDatabase = DatabaseDefinition(
        tables: migrationDefinitions.expand((e) => e.tables).toList(),
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
        installedModules: [] // TODO: Add installed modules, THIS IS FOR THE ENTIRE DIFF do we need it? yes we do since we have to write to the database!
        // We should be able to create this from MigrationVersion ?!?! It is a list of DatabaseMigrationVersion
        );
    return dstDatabase;
  }

  Future<Map<String, MigrationVersion>>
      loadLatestMigrationVersionsFromAllModules() async {
    var versions = <String, MigrationVersion>{};

    var modules = getMigrationModules();

    for (var module in modules) {
      var version = await getLatestMigrationVersion(module);

      if (version == null) {
        continue;
      }

      versions[module] = version;
    }
    return versions;
  }

  Future<Map<String, MigrationVersion>> loadMigrationVersionsFromAllModules({
    RepairTargetMigration? targetMigration,
  }) async {
    var versions = <String, MigrationVersion>{};
    if (targetMigration != null) {
      versions[targetMigration.moduleName] =
          await _loadTargetRepairMigrationVersion(targetMigration);
    }

    var modules = getMigrationModules();
    modules.removeWhere((moduleName) => versions.containsKey(moduleName));

    for (var module in modules) {
      var version = await getLatestMigrationVersion(module);

      if (version == null) {
        continue;
      }

      versions[module] = version;
    }
    return versions;
  }

  Future<MigrationVersion> _loadTargetRepairMigrationVersion(
    RepairTargetMigration targetMigration,
  ) async {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        targetMigration.moduleName,
      ),
    );

    var registry = await MigrationRegistry.load(migrationsDirectory);

    if (!registry.versions.contains(targetMigration.version)) {
      throw MigrationRepairTargetNotFoundException(
        versionsFound: registry.versions,
        targetName: targetMigration.version,
      );
    }

    return await getMigrationVersion(
      targetMigration.version,
      targetMigration.moduleName,
    );
  }

  void _printWarnings(List<DatabaseMigrationWarning> warnings) {
    if (warnings.isNotEmpty) {
      log.warning('Migration Warnings:');
      for (var warning in warnings) {
        log.warning(
          warning.message,
          type: TextLogType.bullet,
        );
      }
    }
  }

  void _writeRepairMigration(
    String repairMigrationName,
    DatabaseMigration migration,
    Map<String, String> moduleVersions,
  ) {
    var repairMigrationSql = migration.toPgSql(versions: moduleVersions);

    var repairMigrationFile = File(path.join(
      MigrationConstants.repairMigrationDirectory(directory).path,
      '$repairMigrationName.sql',
    ));

    var targetDirectory =
        MigrationConstants.repairMigrationDirectory(directory);

    if (targetDirectory.existsSync()) {
      targetDirectory.deleteSync(recursive: true);
    }

    targetDirectory.createSync(recursive: true);

    try {
      repairMigrationFile.writeAsStringSync(repairMigrationSql);
    } catch (e) {
      throw MigrationRepairWriteException(exception: e.toString());
    }
  }
}

class MigrationVersion {
  MigrationVersion({
    required this.moduleName,
    required this.migrationsDirectory,
    required this.versionName,
    required this.migration,
    required this.databaseDefinition,
  });

  final String moduleName;
  final Directory migrationsDirectory;
  final String versionName;
  final DatabaseMigration migration;
  final DatabaseDefinition databaseDefinition;

  static Future<MigrationVersion> load({
    required String versionName,
    required Directory migrationsDirectory,
    required String moduleName,
  }) async {
    var versionDir = Directory(
      path.join(migrationsDirectory.path, versionName),
    );

    // Get the serialization manager
    var serializationManager = Protocol();

    // Load the database definition
    var definitionFile = File(path.join(
      versionDir.path,
      _fileNameDefinitionJson,
    ));
    var definitionData = await definitionFile.readAsString();
    var databaseDefinition = serializationManager.decode<DatabaseDefinition>(
      definitionData,
    );

    // Load the migration definition
    var migrationFile = File(path.join(
      versionDir.path,
      _fileNameMigrationJson,
    ));
    var migrationData = await migrationFile.readAsString();
    var migrationDefinition = serializationManager.decode<DatabaseMigration>(
      migrationData,
    );

    return MigrationVersion(
      moduleName: moduleName,
      migrationsDirectory: migrationsDirectory,
      versionName: versionName,
      migration: migrationDefinition,
      databaseDefinition: databaseDefinition,
    );
  }

  Future<void> write({
    required String module,
  }) async {
    // Create sql for definition and migration
    var definitionSql = databaseDefinition.toPgSql(
      module: module,
      version: versionName,
    );
    var migrationSql = migration.toPgSql(
      versions: {module: versionName},
    );

    var versionDir = Directory(
      path.join(migrationsDirectory.path, versionName),
    );
    await versionDir.create(recursive: true);

    // Write the database definition JSON file
    var definitionFile = File(path.join(
      versionDir.path,
      _fileNameDefinitionJson,
    ));
    var definitionData = SerializationManager.encode(
      databaseDefinition,
      formatted: true,
    );
    await definitionFile.writeAsString(definitionData);

    // Write the database definition SQL file
    var definitionSqlFile = File(path.join(
      versionDir.path,
      _fileNameDefinitionSql,
    ));
    await definitionSqlFile.writeAsString(definitionSql);

    // Write the migration definition JSON file
    var migrationFile = File(path.join(
      versionDir.path,
      _fileNameMigrationJson,
    ));
    var migrationData = SerializationManager.encode(
      migration,
      formatted: true,
    );
    await migrationFile.writeAsString(migrationData);

    // Write the migration definition SQL file
    var migrationSqlFile = File(path.join(
      versionDir.path,
      _fileNameMigrationSql,
    ));
    await migrationSqlFile.writeAsString(migrationSql);
  }
}

class RepairTargetMigration {
  RepairTargetMigration({
    required this.moduleName,
    required this.version,
  });

  final String moduleName;
  final String version;
}
