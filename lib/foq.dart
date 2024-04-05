import 'package:flutter_offline_queue/core/task_handler.dart';
import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/manager/network_manager.dart';

class FOQ {
  Future<void> init(FOQTaskHandler handler) async {
    await FOQDatabaseManager().init();
    await FOQNetworkManager(handler).observe();
  }
}
