import 'package:otter/handler/task_handler.dart';
import 'package:otter/database/database_provider.dart';
import 'package:otter/network/network_helper.dart';

class Otter {
  static Future<void> init(OTTaskHandler handler) async {
    await OTDBProvider().init();
    await OTNetworkHelper(handler).observe();
  }
}
