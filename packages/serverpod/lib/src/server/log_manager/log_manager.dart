import 'dart:io';
import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/src/server/log_manager/log_settings.dart';
import 'package:serverpod/src/server/log_manager/log_writer.dart';
import 'package:synchronized/synchronized.dart';

import '../../../server.dart';
import '../../generated/protocol.dart';

/// The [LogManager] handles logging and logging settings. Typically only used
/// internally by Serverpod.
class LogManager {
  /// The [LogSettingsManager] the log manager retrieves its settings from.
  final LogSettingsManager settings;

  /// The [RuntimeSettings] the log manager retrieves its settings from.
  @Deprecated('Will be removed in 3.0.0')
  final RuntimeSettings runtimeSettings;

  final LogWriter _logWriter;

  final List<SessionLogEntryCache> _openSessionLogs = [];

  int _nextTemporarySessionId = -1;

  /// Returns a new unique temporary session id. The id will be negative, and
  /// ids are only unique to this running instance.
  int nextTemporarySessionId() {
    var id = _nextTemporarySessionId;
    _nextTemporarySessionId -= 1;
    return id;
  }

  /// Creates a new [LogManager] from [RuntimeSettings].
  LogManager(this.runtimeSettings, LogWriter logWriter)
      : _logWriter = logWriter,
        settings = LogSettingsManager(runtimeSettings);

  /// Initializes the logging for a session, automatically called when a session
  /// is created. Each call to this method should have a corresponding
  /// [finalizeSessionLog] call.
  SessionLogEntryCache initializeSessionLog(Session session) {
    var logEntry = SessionLogEntryCache(session);
    _openSessionLogs.add(logEntry);
    return logEntry;
  }

  /// Returns true if a query should be logged based on the current session and
  /// its duration and if it failed.
  bool _shouldLogQuery({
    required Session session,
    required bool slow,
    required bool failed,
  }) {
    var logSettings = settings.getLogSettingsForSession(session);
    if (logSettings.logAllQueries) {
      return true;
    }
    if (logSettings.logSlowQueries && slow) {
      return true;
    }
    if (logSettings.logFailedQueries && failed) {
      return true;
    }
    return false;
  }

  /// Returns true if a log entry should be stored for the provided session.
  @internal
  bool shouldLogEntry({
    required Session session,
    required LogEntry entry,
  }) {
    var logSettings = settings.getLogSettingsForSession(session);
    var serverLogLevel = (logSettings.logLevel);

    return entry.logLevel.index >= serverLogLevel.index;
  }

  /// Returns true if a message should be logged for the provided session.
  @internal
  bool shouldLogMessage({
    required Session session,
    required String endpoint,
    required bool slow,
    required bool failed,
  }) {
    var logSettings = settings.getLogSettingsForSession(session);
    if (logSettings.logAllSessions) {
      return true;
    }
    if (logSettings.logSlowSessions && slow) {
      return true;
    }
    if (logSettings.logFailedSessions && failed) {
      return true;
    }
    return false;
  }

  bool _continuouslyLogging(Session session) =>
      session is StreamingSession &&
      session.sessionLogId != null &&
      session.sessionLogId! >= 0;

  /// Logs an entry, depending on the session type it will be logged directly
  /// to the database or stored in the temporary cache until the session is
  /// closed. Call [shouldLogEntry] to check if the entry should be logged
  /// before calling this method. This method can be called asynchronously.
  @internal
  Future<void> logEntry(Session session, LogEntry entry) async {
    await _internalLogger(
      'ENTRY',
      session,
      entry,
      session.sessionLogs.logEntries,
      _logWriter.logStreamEntry,
      (sessionLogId, entry) => entry.sessionLogId = sessionLogId,
    );
  }

  /// Logs a query, depending on the session type it will be logged directly
  /// to the database or stored in the temporary cache until the session is
  /// closed. Call [_shouldLogQuery] to check if the entry should be logged
  /// before calling this method. This method can be called asynchronously.
  @internal
  Future<void> logQuery(
    Session session, {
    required String query,
    required Duration duration,
    required int? numRowsAffected,
    required String? error,
    required StackTrace stackTrace,
  }) async {
    var executionTime = duration.inMicroseconds / (1000 * 1000.0);

    var logSettings = settings.getLogSettingsForSession(session);

    var slow = executionTime >= logSettings.slowQueryDuration;
    var shouldLog = _shouldLogQuery(
      session: session,
      slow: slow,
      failed: error != null,
    );

    if (!shouldLog) {
      return;
    }

    var entry = QueryLogEntry(
      sessionLogId: session.sessionLogs.temporarySessionId,
      serverId: session.server.serverId,
      query: query,
      duration: executionTime,
      numRows: numRowsAffected,
      error: error,
      stackTrace: stackTrace.toString(),
      slow: slow,
      order: session.sessionLogs.createLogOrderId,
    );

    await _internalLogger(
      'QUERY',
      session,
      entry,
      session.sessionLogs.queries,
      _logWriter.logStreamQuery,
      (sessionLogId, entry) => entry.sessionLogId = sessionLogId,
    );
  }

  /// Logs a message from a stream, depending on the session type it will be
  /// logged directly to the database or stored in the temporary cache until the
  /// session is closed. Call [shouldLogMessage] to check if the entry should be
  /// logged before calling this method. This method can be called
  /// asynchronously.
  @internal
  Future<void> logMessage(Session session, MessageLogEntry entry) async {
    await _internalLogger(
      'MESSAGE',
      session,
      entry,
      session.sessionLogs.messages,
      _logWriter.logStreamMessage,
      (sessionLogId, entry) => entry.sessionLogId = sessionLogId,
    );
  }

  Future<void> _internalLogger<T extends TableRow>(
    String type,
    Session session,
    T entry,
    List<T> logCollector,
    Future<void> Function(Session, T) writeLog,
    Function(int, T) setSessionLogId,
  ) async {
    await _attemptOpenStreamingLog(session: session);
    if (_continuouslyLogging(session) && session is StreamingSession) {
      try {
        setSessionLogId(session.sessionLogId!, entry);
        await writeLog(session, entry);
      } catch (exception, stackTrace) {
        stderr
            .writeln('${DateTime.now().toUtc()} FAILED TO LOG STREAMING $type');
        stderr.write('ENDPOINT: ${_endpointForSession(session)}');
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$stackTrace');
      }
    } else {
      logCollector.add(entry);
    }
  }

  final Lock _openStreamLogLock = Lock();

  /// Sets up a log for a streaming session. Instead of writing all session data
  /// when the session is completed the session will be continuously logged.
  Future<void> _attemptOpenStreamingLog({
    required Session session,
  }) async {
    await _openStreamLogLock.synchronized(() async {
      if (session is! StreamingSession) {
        // Only open streaming logs for streaming sessions.
        return;
      }

      if (session.sessionLogId != null) {
        // Streaming log is already opened.
        return;
      }

      assert(session.sessionLogs.currentEndpoint != null);

      var logSettings = settings.getLogSettingsForSession(session);
      if (!logSettings.logStreamingSessionsContinuously) {
        // This call should not stream continuously.
        return;
      }

      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: session.server.serverId,
        time: now,
        touched: now,
        endpoint: _endpointForSession(session),
        method: _methodForSession(session),
        isOpen: true,
      );

      var sessionLogId = await _logWriter.openStreamingLog(
        session,
        sessionLogEntry,
      );

      session.sessionLogId = sessionLogId;
    });
  }

  /// Called automatically when a session is closed. Writes the session and its
  /// logs to the database, if configuration says so.
  @internal
  Future<int?> finalizeSessionLog(
    Session session, {
    int? authenticatedUserId,
    String? exception,
    StackTrace? stackTrace,
  }) async {
    _openSessionLogs.removeWhere((logEntry) => logEntry.session == session);

    // If verbose logging is enabled, output otherwise unlogged exceptions to
    // console.
    if (exception != null && !session.enableLogging) {
      session.serverpod.logVerbose(exception);
      if (stackTrace != null) {
        session.serverpod.logVerbose(stackTrace.toString());
      }
    }

    if (!session.enableLogging) return null;

    var duration = session.duration;
    var cachedEntry = session.sessionLogs;
    LogSettings? logSettings;
    if (session is! StreamingSession) {
      logSettings = settings.getLogSettingsForSession(session);
    }

    if (session.serverpod.runMode == ServerpodRunMode.development) {
      if (session is MethodCallSession) {
        stdout.writeln(
            'METHOD CALL: ${session.endpointName}.${session.methodName} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length} authenticatedUser: $authenticatedUserId');
      } else if (session is FutureCallSession) {
        stdout.writeln(
            'FUTURE CALL: ${session.futureCallName} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length}');
      }
      if (exception != null) {
        stdout.writeln(exception);
        stdout.writeln('$stackTrace');
      }
    }

    var isSlow = false;

    if (logSettings != null) {
      var slowMicros = (logSettings.slowSessionDuration * 1000000.0).toInt();
      isSlow = duration > Duration(microseconds: slowMicros) &&
          session is! StreamingSession;
    }

    if ((logSettings?.logAllSessions ?? false) ||
        (logSettings?.logSlowSessions ?? false) && isSlow ||
        (logSettings?.logFailedSessions ?? false) && exception != null ||
        cachedEntry.queries.isNotEmpty ||
        cachedEntry.logEntries.isNotEmpty ||
        cachedEntry.messages.isNotEmpty ||
        _continuouslyLogging(session)) {
      int? sessionLogId;

      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: session.server.serverId,
        time: now,
        touched: now,
        endpoint: _endpointForSession(session),
        method: _methodForSession(session),
        duration: duration.inMicroseconds / 1000000.0,
        numQueries: cachedEntry.numQueries,
        slow: isSlow,
        error: exception,
        stackTrace: stackTrace?.toString(),
        authenticatedUserId: authenticatedUserId,
      );

      try {
        if (_continuouslyLogging(session)) {
          session as StreamingSession;
          sessionLogId = session.sessionLogId!;
          sessionLogEntry.id = sessionLogId;
          sessionLogEntry.isOpen = false;
          await _logWriter.closeStreamingLog(session, sessionLogEntry);
        } else {
          await _logWriter.logAllCached(session, sessionLogEntry, cachedEntry);
        }
      } catch (e, logStackTrace) {
        stderr.writeln('${DateTime.now().toUtc()} FAILED TO LOG SESSION');
        if (_methodForSession(session) != null) {
          stderr.writeln(
              'CALL: ${_endpointForSession(session)}.${_methodForSession(session)} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length} authenticatedUser: $authenticatedUserId');
        }
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$logStackTrace');

        stderr.writeln('LOG ERRORS');
        stderr.writeln('$e');
        stderr.writeln('$logStackTrace');
        stderr.writeln('Current stacktrace:');
        stderr.writeln('${StackTrace.current}');
      }

      return sessionLogId;
    }
    return null;
  }

  /// Returns a list of logs for all open sessions.
  List<SessionLogInfo> getOpenSessionLogs(
      int numEntries, SessionLogFilter? filter) {
    var sessionLog = <SessionLogInfo>[];

    var numFoundEntries = 0;
    var i = 0;
    while (i < _openSessionLogs.length && numFoundEntries < numEntries) {
      var entry = _openSessionLogs[i];
      i += 1;
      numFoundEntries += 1;

      // Check filter (ignore slow and errors as session is still open)
      if (filter != null) {
        var session = entry.session;
        if (session is MethodCallSession) {
          if (filter.endpoint != null &&
              filter.endpoint != '' &&
              session.endpointName != filter.endpoint) {
            continue;
          }
          if (filter.endpoint != null &&
              filter.endpoint != '' &&
              filter.method != null &&
              filter.method != '' &&
              session.endpointName != filter.endpoint &&
              session.methodName != filter.method) {
            continue;
          }
        }
      }

      sessionLog.add(
        SessionLogInfo(
          sessionLogEntry: SessionLogEntry(
            serverId: Serverpod.instance.serverId,
            time: entry.session.startTime,
            touched: DateTime.now(),
            endpoint: _endpointForSession(entry.session),
            method: _methodForSession(entry.session),
            numQueries: entry.numQueries,
          ),
          queries: entry.queries,
          logs: entry.logEntries,
          messages: entry.messages,
        ),
      );
    }

    return sessionLog;
  }
}

String? _methodForSession(Session session) {
  var localSession = session;

  if (localSession is MethodCallSession) return localSession.methodName;
  if (localSession is MethodStreamSession) return localSession.methodName;
  if (localSession is FutureCallSession) return localSession.futureCallName;
  if (localSession is InternalSession) return null;
  if (localSession is StreamingSession) return null;

  throw Exception('Unknown session type: $session');
}

String _endpointForSession(Session session) {
  var localSession = session;
  if (localSession is MethodCallSession) return localSession.endpointName;
  if (localSession is MethodStreamSession) return localSession.endpointName;
  if (localSession is FutureCallSession) return 'FutureCallSession';
  if (localSession is InternalSession) return 'InternalSession';
  if (localSession is StreamingSession) return 'StreamingSession';

  throw Exception('Unknown session type: $session');
}
