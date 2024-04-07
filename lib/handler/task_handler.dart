library otter;

import 'package:otter/database/database_provider.dart';
import 'package:otter/model/task.dart';

abstract class DefaultOTTaskHandler {
  Future<void> didFinish(OTTask task);
  void didSuccess(OTTask task, String response);
  void didFail(OTTask task, Object? error, StackTrace stackTrace);
}

class OTTaskHandler extends DefaultOTTaskHandler {
  final _databaseProvider = OTDBProvider();

  @override
  void didFail(OTTask task, Object? error, StackTrace stackTrace) {}

  @override
  Future<void> didFinish(OTTask task) async {
    await _databaseProvider.erase(task.uuid);
  }

  @override
  void didSuccess(OTTask task, String response) {}
}
