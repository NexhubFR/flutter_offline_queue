import 'dart:convert';
import 'dart:developer';

import 'package:flutter_offline_queue/model/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FOQDatabaseManager {
  static late Database _database;

  final _store = intMapStoreFactory.store();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'foq.db');
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<void> saveTasksIntoDatabase(List<FOQTask> tasks,
      {required Function(FOQTask task, Object? error, StackTrace stackTrace)
          didFail}) async {
    for (var task in tasks) {
      await _store
          .add(_database, {
            'uuid': task.uuid,
            'uri': task.uri.toString(),
            'type': task.type,
            'method': task.method.name,
            'headers': jsonEncode(task.headers),
            'body': jsonEncode(task.body),
          })
          .then((_) => log('Task saved into the database.'))
          .onError((error, stackTrace) => didFail(task, error, stackTrace));
    }
  }

  Future<List<FOQTask>> getTasks() async {
    final records = await _store.find(_database);
    final tasks =
        records.map((record) => FOQTask.fromDatabase(record.value)).toList();
    return tasks;
  }

  Future<void> erase(String uuid) async {
    await _store.delete(_database,
        finder: Finder(filter: Filter.equals('uuid', uuid)));
  }
}
