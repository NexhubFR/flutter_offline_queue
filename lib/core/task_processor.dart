library otter;

import 'dart:convert';

import 'package:otter/core/task_handler.dart';
import 'package:otter/model/task.dart';
import 'package:otter/manager/database_manager.dart';
import 'package:otter/enum/http_method.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class OTTaskProcessor {
  final OTDatabaseManager _databaseManager = OTDatabaseManager();

  Future<void> executeOneTask(OTTask task, OTTaskHandler handler,
      {bool offlineStorageEnabled = true,
      bool executeTasksOnNetworkAvailability = true}) async {
    executeMultipleTasks([task], handler,
        offlineStorageEnabled: offlineStorageEnabled,
        executeTasksOnNetworkAvailability: executeTasksOnNetworkAvailability);
  }

  Future<void> executeMultipleTasks(List<OTTask> tasks, OTTaskHandler handler,
      {bool offlineStorageEnabled = true,
      bool executeTasksOnNetworkAvailability = true}) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none) &&
        offlineStorageEnabled) {
      await _databaseManager.saveTasksIntoDatabase(tasks,
          didFail: handler.didFail);
    } else {
      await _executeHTTPRequests(tasks, handler);
    }
  }

  Future<void> _executeHTTPRequests(
      List<OTTask> tasks, OTTaskHandler handler) async {
    for (var task in tasks) {
      switch (task.method) {
        case HTTPMethod.post:
          await _post(task, handler);
        case HTTPMethod.patch:
          await _patch(task, handler);
        case HTTPMethod.put:
          await _put(task, handler);
      }

      await handler.didFinish(task);
    }
  }

  Future<void> _post(OTTask task, OTTaskHandler handler) async {
    await http
        .post(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  Future<void> _patch(OTTask task, OTTaskHandler handler) async {
    await http
        .patch(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  Future<void> _put(OTTask task, OTTaskHandler handler) async {
    await http
        .put(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }
}
