import 'dart:convert';
import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:otter/model/task.dart';

abstract class DefaultOTDBProvider {
  Future<void> saveTasksIntoDatabase(List<OTTask> tasks,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
          didFail});
  Future<List<OTTask>> getTasks();
  Future<void> eraseTask(String uuid);
}

class OTDBProvider implements DefaultOTDBProvider {
  static late Database _database;

  final _store = intMapStoreFactory.store();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'otter.db');
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  @override
  Future<void> saveTasksIntoDatabase(List<OTTask> tasks,
      {required Function(OTTask task, Object? error, StackTrace stackTrace)
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

  @override
  Future<List<OTTask>> getTasks() async {
    final records = await _store.find(_database);
    final tasks =
        records.map((record) => OTTask.fromDatabase(record.value)).toList();
    return tasks;
  }

  @override
  Future<void> eraseTask(String uuid) async {
    await _store.delete(_database,
        finder: Finder(filter: Filter.equals('uuid', uuid)));
  }
}
