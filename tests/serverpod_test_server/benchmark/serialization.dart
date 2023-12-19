import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

import 'data_creation.dart';

// Create a new benchmark by extending BenchmarkBase
class TemplateBenchmark extends BenchmarkBase {
  TemplateBenchmark() : super('Template');

  static void main() {
    TemplateBenchmark().report();
  }

  late String jsonString;
  Protocol protocol = Protocol();

  // The benchmark code.
  @override
  void exercise() {
    protocol.decode<MassiveDataBlob>(jsonString);
  }

  // Not measured setup code executed prior to the benchmark runs.
  @override
  void setup() {
    var dataBlob = createDataBlob(list: [
      createDataBlob(
        list: [
          createDataBlob(list: [
            createDataBlob(),
            createDataBlob(),
            createDataBlob(),
          ]),
          createDataBlob(
            list: [
              createDataBlob(list: [
                createDataBlob(),
                createDataBlob(),
                createDataBlob(),
              ]),
            ],
          ),
        ],
      ),
      createDataBlob(list: [
        createDataBlob(),
        createDataBlob(),
        createDataBlob(),
      ]),
      createDataBlob(),
      createDataBlob()
    ]);

    jsonString = SerializationManager.encode(dataBlob.allToJson());
  }

  // Not measured teardown code executed after the benchmark runs.
  @override
  void teardown() {}

  // To opt into the reporting the time per run() instead of per 10 run() calls.
  //@override
  //void exercise() => run();
}

void main() {
  // Run TemplateBenchmark
  TemplateBenchmark.main();
}
