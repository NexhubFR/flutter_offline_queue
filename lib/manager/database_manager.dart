import 'dart:convert';

import 'package:flutter_offline_queue/model/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FOQDatabaseManager {
  static Database? db;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'foq.db');
    db = await databaseFactoryIo.openDatabase(dbPath);
  }

  void saveTasksIntoDatabase(List<FOQTask> tasks,
      {required Function(String? response) didSuccess,
      required Function(Object? error, StackTrace stackTrace) didFail}) async {
    final store = intMapStoreFactory.store();
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];

      await store
          .add(FOQDatabaseManager.db!, {
            "uri": task.uri.toString(),
            "method": task.method.name,
            "headers": jsonEncode(task.headers),
            "body": jsonEncode(task.body),
          })
          .then((_) => didSuccess("Tasks saved into the database"))
          .onError((error, stackTrace) => didFail(error, stackTrace));
    }
  }

  Future<List<FOQTask>> getTasks() async {
    final store = intMapStoreFactory.store();
    final records = await store.find(FOQDatabaseManager.db!);
    final tasks =
        records.map((record) => FOQTask.fromDatabase(record.value)).toList();
    return tasks;
  }
}
