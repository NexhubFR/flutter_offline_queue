library flutter_offline_queue;

import 'package:flutter_offline_queue/http_method.dart';

class FOQTask {
  Uri uri;
  HTTPMethod method;
  Map<String, String> headers;
  Map<String, String> body;

  FOQTask(this.uri, this.method, this.headers, this.body);
}
