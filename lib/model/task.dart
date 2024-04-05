library flutter_offline_queue;

import 'dart:convert';

import 'package:flutter_offline_queue/enum/http_method.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:uuid/uuid.dart';

abstract class _DefaultFOQTaskDelegate {
  Future<void> didFinish(FOQTask task);
  void didSuccess(FOQTask task, String response);
  void didFail(FOQTask task, Object? error, StackTrace stackTrace);
}

class FOQTaskDelegate extends _DefaultFOQTaskDelegate {
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

class FOQTask {
  String uuid = const Uuid().v8();

  Uri uri;
  String type;
  HTTPMethod method;
  Map<String, String> headers;
  Map<String, String> body;

  FOQTask(this.uri, this.type, this.method, this.headers, this.body);

  static FOQTask fromDatabase(Map<String, Object?> data) {
    final values = data.values.toList();

    final uuid = values[0].toString();
    final uri = Uri.parse(values[1].toString());
    final type = values[2].toString();
    final method = HTTPMethodExtension.fromString(values[3].toString())!;

    Map<String, dynamic> decodedHeaders = jsonDecode(values[4].toString());
    Map<String, String> headers =
        decodedHeaders.map((key, value) => MapEntry(key, value.toString()));

    Map<String, dynamic> decodedBody = jsonDecode(values[5].toString());
    Map<String, String> body =
        decodedBody.map((key, value) => MapEntry(key, value.toString()));

    final task = FOQTask(uri, type, method, headers, body);
    task.uuid = uuid;
    return task;
  }
}
