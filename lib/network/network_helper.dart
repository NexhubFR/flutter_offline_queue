library otter;

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:otter/handler/task_handler.dart';
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_provider.dart';
import 'package:otter/model/task.dart';
import 'package:synchronized/synchronized.dart';
import 'package:http/http.dart' as http;

class OTNetworkHelper {
  final OTDBProvider _databaseProvider = OTDBProvider();

  final OTTaskHandler _handler;

  OTNetworkHelper(this._handler);

  Future<void> observe() async {
    var lock = Lock(reentrant: true);

    Connectivity().onConnectivityChanged.listen((event) async {
      if (event.first != ConnectivityResult.none) {
        await lock.synchronized(() async {
          final tasks = await _databaseProvider.getTasks();

          if (tasks.isNotEmpty) {
            await execute(tasks, _handler);
          }
        });
      }
    });
  }

  Future<void> execute(List<OTTask> tasks, OTTaskHandler handler) async {
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
