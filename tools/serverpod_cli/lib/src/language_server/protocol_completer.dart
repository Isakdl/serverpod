import 'dart:io';
import 'dart:math';

import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';

class ProtocolCompleter {
  static CompletionList createCompletionList(
    Position position,
    ProtocolState protocol,
    List<SerializableEntityDefinition> entities,
  ) {
    var line = _getLine(protocol.source.yaml, position.line);
    var preWrittenString = line.substring(0, position.character);
    var tokens = preWrittenString.split('=');
    var previousToken = tokens[max(0, tokens.length - 2)];

    if (preWrittenString.contains('serverOnly:')) {
      return CompletionList(
        isIncomplete: false,
        items: [
          CompletionItem(
            label: 'true',
            kind: CompletionItemKind.Value,
          ),
          CompletionItem(
            label: 'false',
            kind: CompletionItemKind.Value,
          ),
        ],
      );
    }

    if (previousToken.contains('parent')) {
      return CompletionList(
        isIncomplete: false,
        items: entities
            .whereType<ClassDefinition>()
            .where((element) => element.tableName != null)
            .map(
              (e) => CompletionItem(
                label: e.tableName!,
                kind: CompletionItemKind.Reference,
                documentation: Either2.t1(
                  MarkupContent(
                    kind: MarkupKind.Markdown,
                    value: '''
```serverpod
class: ${e.className}
table: ${e.tableName}
fields:
  ${e.fields.map((e) => '${e.name}: ${e.type.toString()}').join('\n  ')}
```

Above is the full definition of the class.
''',
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    stderr.writeln('line: $line');

    return CompletionList(
      isIncomplete: false,
      items: [
        CompletionItem(
          label: 'TypeScript',
          kind: CompletionItemKind.Text,
        ),
        CompletionItem(
          label: 'JavaScript',
          kind: CompletionItemKind.Text,
        ),
      ],
    );
  }
}

String _getLine(String yaml, int line) {
  return yaml.split('\n')[line];
}
