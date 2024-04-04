library flutter_offline_queue;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/core/task_sequencer.dart';

class FOQNetworkManager {
  final databaseManager = FOQDatabaseManager();

  Future<void> observe() async {
    Connectivity().onConnectivityChanged.listen((event) async {
      if (event != ConnectivityResult.none) {
        // final sequencer = FOQTaskSequencer();
        // final tasks = await databaseManager.getTasks();

        // sequencer.execute(tasks,
        //    didSuccess: (response) => {print(response)},
        //    didFail: (error, stackTrace) => {print(error), print(stackTrace)});
      }
    });
  }
}
