library flutter_offline_queue;

import 'dart:convert';

import 'package:flutter_offline_queue/enum/http_method.dart';

class FOQTask {
  Uri uri;
  HTTPMethod method;
  Map<String, String> headers;
  Map<String, String> body;

  FOQTask(this.uri, this.method, this.headers, this.body);

  static FOQTask fromDatabase(Map<String, Object?> data) {
    final values = data.values.toList();

    final uri = Uri.parse(values.first.toString());
    final method = HTTPMethodExtension.fromString(values[1].toString())!;

    Map<String, dynamic> decodedHeaders = jsonDecode(values[2].toString());
    Map<String, String> headers =
        decodedHeaders.map((key, value) => MapEntry(key, value.toString()));

    Map<String, dynamic> decodedBody = jsonDecode(values[3].toString());
    Map<String, String> body =
        decodedBody.map((key, value) => MapEntry(key, value.toString()));

    return FOQTask(uri, method, headers, body);
  }
}
