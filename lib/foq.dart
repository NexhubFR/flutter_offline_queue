import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/manager/network_manager.dart';
import 'package:flutter_offline_queue/model/task.dart';

class FOQ {
  void init(FOQTaskDelegate taskDelegate) async {
    await FOQDatabaseManager().init();
    await FOQNetworkManager(taskDelegate).observe();
  }
}
