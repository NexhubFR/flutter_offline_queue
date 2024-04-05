library flutter_offline_queue;

import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/model/task.dart';

abstract class _DefaultFOQTaskHandler {
  Future<void> didFinish(FOQTask task);
  void didSuccess(FOQTask task, String response);
  void didFail(FOQTask task, Object? error, StackTrace stackTrace);
}

class FOQTaskHandler extends _DefaultFOQTaskHandler {
  final _databaseManager = FOQDatabaseManager();

  @override
  void didFail(FOQTask task, Object? error, StackTrace stackTrace) {}

  @override
  Future<void> didFinish(FOQTask task) async {
    await _databaseManager.erase(task.uuid);
  }

  @override
  void didSuccess(FOQTask task, String response) {}
}
