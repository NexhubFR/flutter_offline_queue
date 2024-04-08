library otter;

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:otter/model/task.dart';
import 'package:otter/database/database_provider.dart';

abstract class DefaultOTDBStore {
  Future<void> addOneTask(OTTask task,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail,
      required Function() networkAvailable});
  Future<void> addMultipleTasks(List<OTTask> tasks,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail,
      required Function() networkAvailable});
}

class OTDBStore implements DefaultOTDBStore {
  DefaultOTDBProvider _databaseProvider = OTDBProvider();
  Connectivity _connectivity = Connectivity();

  set provider(DefaultOTDBProvider provider) {
    _databaseProvider = provider;
  }

  set connectivity(Connectivity connectivity) {
    _connectivity = connectivity;
  }

  @override
  Future<void> addOneTask(OTTask task,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail,
      required Function() networkAvailable}) async {
    addMultipleTasks([task],
        didFail: didFail, networkAvailable: networkAvailable);
  }

  @override
  Future<void> addMultipleTasks(List<OTTask> tasks,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail,
      required Function() networkAvailable}) async {
    final List<ConnectivityResult> connectivityResult =
        await (_connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      await _databaseProvider.saveTasksIntoDatabase(tasks,
          didFail: (OTTask task, Object? error, StackTrace stackTrace) {});
    } else {
      networkAvailable();
    }
  }
}
