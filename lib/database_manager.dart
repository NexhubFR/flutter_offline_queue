import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FOQDatabaseManager {
  static Database? db;

  Future<void> init() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'foq.db');
    db = await databaseFactoryIo.openDatabase(dbPath);
  }
}
