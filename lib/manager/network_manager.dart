library flutter_offline_queue;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/core/task_processor.dart';
import 'package:synchronized/synchronized.dart';

class FOQNetworkManager {
  final databaseManager = FOQDatabaseManager();

  Future<void> observe() async {
    var lock = Lock(reentrant: true);

    Connectivity().onConnectivityChanged.listen((event) async {
      if (event.first != ConnectivityResult.none) {
        await lock.synchronized(() async {
          final tasks = await databaseManager.getTasks();

          if (tasks.isNotEmpty) {
            await FOQTaskProcessor().execute(tasks,
                didSuccess: (taskUuid, response) async => {
                      print('Task success: $response, $taskUuid'),
                      await databaseManager.erase(taskUuid),
                    },
                didFail: (error, stackTrace) => {print('$error, $stackTrace')});
          }
        });
      }
    });
  }
}
