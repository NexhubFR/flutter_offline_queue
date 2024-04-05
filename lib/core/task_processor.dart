library flutter_offline_queue;

import 'dart:convert';

import 'package:flutter_offline_queue/core/task_handler.dart';
import 'package:flutter_offline_queue/model/task.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/enum/http_method.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class FOQTaskProcessor {
  final FOQDatabaseManager databaseManager = FOQDatabaseManager();

  Future<void> executeOneTask(FOQTask task, FOQTaskHandler handler) async {
    executeMultipleTasks([task], handler);
  }

  Future<void> executeMultipleTasks(
      List<FOQTask> tasks, FOQTaskHandler handler) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      databaseManager.saveTasksIntoDatabase(tasks, didFail: handler.didFail);
    } else {
      await _executeHTTPRequests(tasks, handler);
    }
  }

  Future<void> _executeHTTPRequests(
      List<FOQTask> tasks, FOQTaskHandler handler) async {
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

  Future<void> _post(FOQTask task, FOQTaskHandler handler) async {
    await http
        .post(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  Future<void> _patch(FOQTask task, FOQTaskHandler handler) async {
    await http
        .patch(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  Future<void> _put(FOQTask task, FOQTaskHandler handler) async {
    await http
        .put(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }
}
