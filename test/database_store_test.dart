import 'package:flutter_test/flutter_test.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:otter/database/database_provider.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/model/task.dart';
import 'package:otter/network/http_method.dart';

void main() {
  group('DatabaseStore Tests', () {
    late OTDBStore storeWithNoConnectivity;
    late OTDBStore storeWithConnectivity;
    late OTTask task;
    late bool networkAvailableIsExecuted;

    setUp(() => {
          storeWithNoConnectivity = OTDBStore(),
          storeWithNoConnectivity.provider = MockDatabaseProvider(),
          storeWithNoConnectivity.connectivity =
              MockConnectivity(ConnectivityResult.none),
          storeWithConnectivity = OTDBStore(),
          storeWithConnectivity.provider = MockDatabaseProvider(),
          storeWithConnectivity.connectivity =
              MockConnectivity(ConnectivityResult.wifi),
          task = OTTask(Uri.https('google.com'), HTTPMethod.get, {}, {}),
          networkAvailableIsExecuted = false
        });

    test(
        'networkAvailable is executed',
        () async => {
              await storeWithConnectivity.addOneTask(task,
                  didFail: (task, error, stackTrace) => {},
                  networkAvailable: () => {networkAvailableIsExecuted = true}),
              expect(networkAvailableIsExecuted, true)
            });

    test(
        'networkAvailable is not executed',
        () async => {
              await storeWithNoConnectivity.addOneTask(task,
                  didFail: (task, error, stackTrace) => {},
                  networkAvailable: () => {networkAvailableIsExecuted = true}),
              expect(networkAvailableIsExecuted, false)
            });
  });
}

class MockDatabaseProvider implements DefaultOTDBProvider {
  @override
  Future<void> saveTasksIntoDatabase(List<OTTask> tasks,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail}) async {}
}

class MockConnectivity implements Connectivity {
  late ConnectivityResult connectivityResult;

  MockConnectivity(this.connectivityResult);

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      const Stream.empty();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Future.value([connectivityResult]);
  }
}
