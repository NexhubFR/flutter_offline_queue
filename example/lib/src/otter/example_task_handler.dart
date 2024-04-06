import 'dart:developer';

import 'package:otter/core/task_handler.dart';
import 'package:otter/model/task.dart';

class ExampleTaskHandler extends OTTaskHandler {
  @override
  void didFail(OTTask task, Object? error, StackTrace stackTrace) {
    log('didFail: $task, $error, $stackTrace');
  }

  @override
  Future<void> didFinish(OTTask task) async {
    await super.didFinish(task);
    log('didFinish: $task');
  }

  @override
  void didSuccess(OTTask task, String response) {
    log('didSuccess: $task, $response');
  }
}
