library flutter_offline_queue;

import 'dart:convert';

import '../model/task.dart';

import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/enum/http_method.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class FOQTaskSequencer {
  final databaseManager = FOQDatabaseManager();

  void execute(List<FOQTask> tasks,
      {required Function(String? response) didSuccess,
      required Function(Object? error, StackTrace stackTrace) didFail}) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      databaseManager.saveTasksIntoDatabase(tasks,
          didSuccess: didSuccess, didFail: didFail);
    } else {
      await _executeHTTPRequests(tasks,
          didSuccess: didSuccess, didFail: didFail);
    }
  }

  Future<void> _executeHTTPRequests(List<FOQTask> tasks,
      {required Function(String response) didSuccess,
      required Function(Object? error, StackTrace stackTrace) didFail}) async {
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];

      switch (task.method) {
        case HTTPMethod.post:
          await http
              .post(task.uri,
                  headers: task.headers, body: jsonEncode(task.body))
              .then((value) => didSuccess(value.body))
              .onError((error, stackTrace) => didFail(error, stackTrace));
        case HTTPMethod.patch:
          await http
              .patch(task.uri,
                  headers: task.headers, body: jsonEncode(task.body))
              .then((value) => didSuccess(value.body))
              .onError((error, stackTrace) => didFail(error, stackTrace));
        case HTTPMethod.put:
          await http
              .put(task.uri, headers: task.headers, body: jsonEncode(task.body))
              .then((value) => didSuccess(value.body))
              .onError((error, stackTrace) => didFail(error, stackTrace));
      }
    }
  }
}
