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

  /// Initializes the database.
  ///
  /// This asynchronous function performs the following steps to initialize the database:
  /// 1. Retrieves the application's documents directory using `getApplicationDocumentsDirectory()`.
  ///    This directory is used to store the application's private files.
  ///
  /// 2. Creates the documents directory recursively if it does not already exist.
  ///    This ensures that the path to the directory is valid and ready for use.
  ///
  /// 3. Constructs the full database path by appending 'otter.db' to the path of the documents directory.
  ///    'otter.db' is the name of the database file.
  ///
  /// 4. Opens the database from the specified path using `databaseFactoryIo.openDatabase(dbPath)`.
  ///    This initializes `_database` with a reference to the opened database,
  ///    ready for read and write operations.
  ///
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'otter.db');
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  /// Saves a list of tasks into the database.
  ///
  /// This asynchronous method takes a list of `OTTask` objects and persists them into the database.
  /// Each task is saved by:
  /// 1. Constructing a map from the task properties (`uuid`, `uri`, `type`, `method`, `headers`, `body`).
  ///    - `uri` is converted to a string using `toString()`.
  ///    - `method` uses the `name` property to get the string representation of the enum.
  ///    - `headers` and `body` are encoded into JSON strings using `jsonEncode()`.
  ///
  /// 2. Adding the task to the store by calling `_store.add()`,
  ///    which includes the constructed map and a reference to `_database`.
  ///
  /// 3. Logging a message once the task is successfully saved into the database.
  ///
  /// If an error occurs during the saving process, the provided `didFail` callback is invoked with the task,
  /// the error, and the stack trace. This method ensures that tasks are individually processed and saved,
  /// and any errors are handled through the callback.
  ///
  /// Parameters:
  /// - `tasks`: A list of `OTTask` objects to be saved into the database.
  /// - `didFail`: A required callback function that is called if saving a task fails.
  ///              It receives the task, the error object, and the stack trace.
  ///
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

  /// Retrieves all tasks from the database.
  ///
  /// This method performs the following steps to fetch tasks:
  /// 1. Queries the database for all task records using `_store.find(_database)`.
  ///    This asynchronous call returns a list of records from the database referenced by `_database`.
  ///
  /// 2. Converts each record into an `OTTask` object. This conversion is done
  ///    by mapping each record to `OTTask.fromDatabase(record.value)`,
  ///    which is a factory constructor of `OTTask` designed to create an instance from the database record.
  ///    The `record.value` contains the data fields of a task stored in the database.
  ///
  /// 3. The result of the mapping is a list of `OTTask` instances,
  ///    which is then converted to a list with `.toList()`.
  ///    This final list contains all the tasks currently stored in the database.
  ///
  /// Returns:
  /// A future that completes with a list of `OTTask` objects,
  /// representing all the tasks retrieved from the database.
  ///
  @override
  Future<List<OTTask>> getTasks() async {
    final records = await _store.find(_database);
    final tasks =
        records.map((record) => OTTask.fromDatabase(record.value)).toList();
    return tasks;
  }

  /// Deletes a specific task from the database.
  ///
  /// This asynchronous method deletes a task identified by its `uuid` from the database.
  /// It performs this operation by:
  /// 1. Calling `_store.delete()` with `_database` to target the specific database
  ///    where the task records are stored.
  ///
  /// 2. Using a `Finder` with a filter that matches the `uuid` of the task to be deleted.
  ///    The `Filter.equals('uuid', uuid)` ensures that only the record
  ///    with the matching `uuid` is targeted for deletion.
  ///
  /// Parameters:
  /// - `uuid`: A `String` representing the unique identifier of the task to be deleted.
  ///
  /// This method ensures that if a task with the specified `uuid` exists in the database,
  /// it will be removed. If no task matches the `uuid`, the database remains unchanged.
  ///
  @override
  Future<void> eraseTask(String uuid) async {
    await _store.delete(_database,
        finder: Finder(filter: Filter.equals('uuid', uuid)));
  }
}
