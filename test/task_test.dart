import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:otter/model/task.dart';
import 'package:otter/network/http_method.dart';

void main() {
  group('Task Tests', () {
    late OTTask task;
    late Map<String, Object?> data;

    const uuid = '53b41030-0226-4bf4-88e3-edb7703de59f';
    const type = 'OTTask';
    const method = 'get';
    final uri = Uri.https('google.com');
    final headers = {'Content-Type': 'application/json'};
    final body = {'text': 'Test'};

    setUp(() => {
          data = {
            'uuid': uuid,
            'uri': uri,
            'type': type,
            'method': method,
            'headers': jsonEncode(headers),
            'body': jsonEncode(body),
          }
        });

    test(
        'fromDatabase',
        () => {
              task = OTTask.fromDatabase(data),
              expect(task.uuid, uuid),
              expect(task.uri, uri),
              expect(task.type, type),
              expect(task.method, HTTPMethod.get),
              expect(task.headers, headers),
              expect(task.body, body),
            });
  });
}
