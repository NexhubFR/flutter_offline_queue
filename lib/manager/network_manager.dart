library flutter_offline_queue;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/core/task_processor.dart';
import 'package:flutter_offline_queue/model/task.dart';
import 'package:synchronized/synchronized.dart';

class FOQNetworkManager {
  final databaseManager = FOQDatabaseManager();

  FOQTaskDelegate? taskDelegate;

  FOQNetworkManager(this.taskDelegate);

  Future<void> observe() async {
    var lock = Lock(reentrant: true);

    Connectivity().onConnectivityChanged.listen((event) async {
      if (event.first != ConnectivityResult.none) {
        await lock.synchronized(() async {
          final tasks = await databaseManager.getTasks();

          if (tasks.isNotEmpty) {
            await FOQTaskProcessor().executeMultipleTasks(tasks, taskDelegate!);
          }
        });
      }
    });
  }
}
