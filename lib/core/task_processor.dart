library flutter_offline_queue;

import 'dart:convert';

import 'package:flutter_offline_queue/model/task.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/enum/http_method.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class FOQTaskProcessor {
  final databaseManager = FOQDatabaseManager();

  Future<void> executeOneTask(
      FOQTask task, FOQTaskDelegate taskDelegate) async {
    executeMultipleTasks([task], taskDelegate);
  }

  Future<void> executeMultipleTasks(
      List<FOQTask> tasks, FOQTaskDelegate taskDelegate) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      databaseManager.saveTasksIntoDatabase(tasks,
          didFail: taskDelegate.didFail);
    } else {
      await _executeHTTPRequests(tasks, taskDelegate);
    }
  }

  Future<void> _executeHTTPRequests(
      List<FOQTask> tasks, FOQTaskDelegate taskDelegate) async {
    for (var task in tasks) {
      switch (task.method) {
        case HTTPMethod.post:
          await _post(task, taskDelegate);
        case HTTPMethod.patch:
          await _patch(task, taskDelegate);
        case HTTPMethod.put:
          await _put(task, taskDelegate);
      }

      await taskDelegate.didFinish(task);
    }
  }

  Future<void> _post(FOQTask task, FOQTaskDelegate taskDelegate) async {
    await http
        .post(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => taskDelegate.didSuccess(task, value.body))
        .onError((error, stackTrace) =>
            taskDelegate.didFail(task, error, stackTrace));
  }

  Future<void> _patch(FOQTask task, FOQTaskDelegate taskDelegate) async {
    await http
        .patch(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => taskDelegate.didSuccess(task, value.body))
        .onError((error, stackTrace) =>
            taskDelegate.didFail(task, error, stackTrace));
  }

  Future<void> _put(FOQTask task, FOQTaskDelegate taskDelegate) async {
    await http
        .put(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => taskDelegate.didSuccess(task, value.body))
        .onError((error, stackTrace) =>
            taskDelegate.didFail(task, error, stackTrace));
  }
}
