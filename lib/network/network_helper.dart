library otter;

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:otter/handler/task_handler.dart';
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_provider.dart';
import 'package:otter/model/task.dart';
import 'package:synchronized/synchronized.dart';
import 'package:http/http.dart' as http;

abstract class DefaultOTNetworkHelper {
  Future<void> execute(List<OTTask> tasks, DefaultOTTaskHandler handler);
  Future<void> get(OTTask task, OTTaskHandler handler);
  Future<void> post(OTTask task, OTTaskHandler handler);
  Future<void> patch(OTTask task, OTTaskHandler handler);
  Future<void> put(OTTask task, OTTaskHandler handler);
}

class OTNetworkHelper implements DefaultOTNetworkHelper {
  final OTDBProvider _databaseProvider = OTDBProvider();

  final DefaultOTTaskHandler _handler;

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

  @override
  Future<void> execute(List<OTTask> tasks, DefaultOTTaskHandler handler) async {
    for (var task in tasks) {
      switch (task.method) {
        case HTTPMethod.get:
          await get(task, handler);
        case HTTPMethod.post:
          await post(task, handler);
        case HTTPMethod.patch:
          await patch(task, handler);
        case HTTPMethod.put:
          await put(task, handler);
      }

      await handler.didFinish(task);
    }
  }

  @override
  Future<void> get(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .get(task.uri, headers: task.headers)
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  @override
  Future<void> post(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .post(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  @override
  Future<void> patch(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .patch(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  @override
  Future<void> put(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .put(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }
}
