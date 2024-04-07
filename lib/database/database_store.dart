library otter;

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:otter/model/task.dart';
import 'package:otter/database/database_provider.dart';

class OTDBStore {
  final OTDBProvider _databaseProvider = OTDBProvider();

  Future<void> addOneTask(OTTask task,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail,
      required Function() networkAvailable}) async {
    addMultipleTasks([task],
        didFail: didFail, networkAvailable: networkAvailable);
  }

  Future<void> addMultipleTasks(List<OTTask> tasks,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail,
      required Function() networkAvailable}) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      await _databaseProvider.saveTasksIntoDatabase(tasks,
          didFail: (OTTask task, Object? error, StackTrace stackTrace) {});
    } else {
      networkAvailable();
    }
  }
}
