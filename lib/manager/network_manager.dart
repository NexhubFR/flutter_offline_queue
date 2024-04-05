library flutter_offline_queue;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_offline_queue/core/task_handler.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/core/task_processor.dart';
import 'package:synchronized/synchronized.dart';

class FOQNetworkManager {
  final FOQDatabaseManager databaseManager = FOQDatabaseManager();

  late FOQTaskHandler handler;

  FOQNetworkManager(this.handler);

  Future<void> observe() async {
    var lock = Lock(reentrant: true);

    Connectivity().onConnectivityChanged.listen((event) async {
      if (event.first != ConnectivityResult.none) {
        await lock.synchronized(() async {
          final tasks = await databaseManager.getTasks();

          if (tasks.isNotEmpty) {
            await FOQTaskProcessor().executeMultipleTasks(tasks, handler);
          }
        });
      }
    });
  }
}
