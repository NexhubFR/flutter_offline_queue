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

/// `OTDBStore` Caches HTTP requests in the event of network unavailability
class OTDBStore implements DefaultOTDBStore {
  DefaultOTDBProvider _databaseProvider = OTDBProvider();
  Connectivity _connectivity = Connectivity();

  set provider(DefaultOTDBProvider provider) {
    _databaseProvider = provider;
  }

  set connectivity(Connectivity connectivity) {
    _connectivity = connectivity;
  }

  /// Adds a single `OTTask` to the database or queue.
  ///
  /// Wraps the given `task` in a list and delegates to `addMultipleTasks` for consistency in handling,
  /// including error and network availability checks.
  /// This approach maintains uniformity with bulk task additions while simplifying single task processing.
  ///
  /// Parameters:
  /// - `task`: The task to add.
  /// - `didFail`: Callback for handling errors during task addition.
  /// - `networkAvailable`: Callback if network is available.
  ///
  @override
  Future<void> addOneTask(OTTask task,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail,
      required Function() networkAvailable}) async {
    addMultipleTasks([task],
        didFail: didFail, networkAvailable: networkAvailable);
  }

  /// Adds multiple `OTTask` objects to the database based on network availability.
  ///
  /// This method checks for network connectivity before deciding
  /// on the action to take with the provided tasks:
  /// - If no network is available (`ConnectivityResult.none`), tasks are saved to the database
  ///   for later processing. Errors in saving are handled by the `didFail` callback.
  /// - If the network is available, it invokes `networkAvailable`.
  ///
  /// Parameters:
  /// - `tasks`: A list of tasks to be added or processed.
  /// - `didFail`: A callback invoked if saving a task to the database fails,
  ///              providing the task, error, and stack trace.
  /// - `networkAvailable`: A callback that is called when network connectivity is available
  ///                       to process tasks immediately.
  ///
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
