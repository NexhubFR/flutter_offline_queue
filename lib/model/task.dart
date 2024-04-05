library flutter_offline_queue;

import 'dart:convert';

import 'package:flutter_offline_queue/enum/http_method.dart';
import 'package:uuid/uuid.dart';

class FOQTask {
  late String uuid;
  late String type;

  Uri uri;
  HTTPMethod method;
  Map<String, String> headers;
  Map<String, String> body;

  FOQTask(this.uri, this.method, this.headers, this.body) {
    uuid = const Uuid().v8();
    type = runtimeType.toString();
  }

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

    final task = FOQTask(uri, method, headers, body);
    task.uuid = uuid;
    task.type = type;
    return task;
  }
}
