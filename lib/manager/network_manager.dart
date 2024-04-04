library flutter_offline_queue;

import 'dart:developer';

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
                didFinish: (taskUuid) async =>
                    await databaseManager.erase(taskUuid),
                didSuccess: (taskUuid, response) =>
                    log('Task success: $response, $taskUuid'),
                didFail: (error, stackTrace) => log('$error, $stackTrace'));
          }
        });
      }
    });
  }
}
