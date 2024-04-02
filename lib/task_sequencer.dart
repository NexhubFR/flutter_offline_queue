library flutter_offline_queue;

import 'dart:convert';

import 'task.dart';

import 'package:flutter_offline_queue/database_manager.dart';
import 'package:sembast/sembast.dart';
import 'package:flutter_offline_queue/http_method.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class FOQTaskSequencer {
  void execute(List<FOQTask> tasks,
      {required Function(String? response) didSuccess,
      required Function(Object? error, StackTrace stackTrace) didFail}) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      _saveTasksIntoDatabase(tasks, didSuccess: didSuccess, didFail: didFail);
    } else {
      await _executeHTTPRequests(tasks,
          didSuccess: didSuccess, didFail: didFail);
    }
  }

  void _saveTasksIntoDatabase(List<FOQTask> tasks,
      {required Function(String? response) didSuccess,
      required Function(Object? error, StackTrace stackTrace) didFail}) async {
    var store = intMapStoreFactory.store();
    for (int i = 0; i < tasks.length; i++) {
      var task = tasks[i];
      await store
          .add(FOQDatabaseManager.db!, {
            "uri": task.uri.toString(),
            "method": task.method.toString(),
            "headers": task.headers,
            "body": task.body
          })
          .then((_) => didSuccess("Tasks saved into the database"))
          .onError((error, stackTrace) => didFail(error, stackTrace));
    }
  }

  Future<void> _executeHTTPRequests(List<FOQTask> tasks,
      {required Function(String response) didSuccess,
      required Function(Object? error, StackTrace stackTrace) didFail}) async {
    for (int i = 0; i < tasks.length; i++) {
      var task = tasks[i];

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
