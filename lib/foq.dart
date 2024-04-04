import 'package:flutter_offline_queue/manager/database_manager.dart';
import 'package:flutter_offline_queue/manager/network_manager.dart';

class FOQ {
  void init() async {
    await FOQDatabaseManager().init();
    await FOQNetworkManager().observe();
  }
}
