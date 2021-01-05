import 'package:sqflite/sqflite.dart';
import 'package:stock_helper/storage/sqflite/sql_table_data.dart';
import 'package:stock_helper/util/log_util.dart';
import 'package:path/path.dart';

class Provider {
  final String dbName = "app.db";
  static Database db;
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsRight() async {
    List<String> expectTables = ['stocks']; //将项目中使用的表的表名添加集合中

    List<String> tables = await getTables();

    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  //初始化数据库
  Future init() async {
    //Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    print(path);
    try {
      db = await openDatabase(path);
    } catch (e) {
      logUtil.d("openDatabase error $e");
    }
    bool tableIsRight = await this.checkTableIsRight();
    if (!tableIsRight) {
      // 关闭上面打开的db，否则无法执行open
      db.close();
      //表不完整
      // Delete the database
      await deleteDatabase(path);

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(SqlTable.stocks);
        logUtil.d('database created, version: $version');
      }, onOpen: (Database db) async {
        logUtil.d('new database opened');
      });
    } else {
      logUtil.d("existing database opened");
    }
  }
}
