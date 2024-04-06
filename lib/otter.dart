import 'package:otter/core/task_handler.dart';
import 'package:otter/manager/database_manager.dart';
import 'package:otter/manager/network_manager.dart';

class Otter {
  static Future<void> init(OTTaskHandler handler) async {
    await OTDatabaseManager().init();
    await OTNetworkManager(handler).observe();
  }
}
