import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DB {
  static Future<sql.Database> open() async {
    var dbpath = await sql.getDatabasesPath();
    // sql.deleteDatabase(path.join(dbpath, 'places.db'));
    var db = await sql.openDatabase(path.join(dbpath, 'places.db'),
        onCreate: (db, version) {
      db.execute('''
            CREATE TABLE places(
              id TEXT PRIMARY KEY,
              title TEXT,
              image TEXT,
              loc_lat REAL,
              loc_lng REAL,
              address TEXT
            );
          ''');
    }, version: 1);

    return db;
  }

  static Future insert(String table, Map<String, Object> data) async {
    try {
      var db = await DB.open();
      await db.insert(table, data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    } catch (e) {
      throw e;
    }
  }

  static Future<List<Map<String, Object?>>> getData(String table) async {
    var db = await DB.open();
    return db.query(table);
  }
}
