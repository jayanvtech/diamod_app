import 'package:diamond_app/database/diamond_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, '11diamonds.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE diamonds (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          shape TEXT,
          clarity TEXT,
          color TEXT,
          carat_from REAL,
          carat_to REAL,
          price REAL,
          expiry_date TEXT
        )
      ''');
    });
  }

  static Future<void> insertDiamond(Database db, Diamond diamond) async {
    await db.insert('diamonds', diamond.toMap());
  }

  static Future<List<Diamond>> getDiamonds(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('diamonds');

    return List.generate(maps.length, (i) {
      return Diamond(
        maps[i]['shape'],
        maps[i]['clarity'],
        maps[i]['color'],
        maps[i]['carat_from'],
        maps[i]['carat_to'],
        maps[i]['price'],
        maps[i]['expiry_date'],
      );
    });
  }

  static Future<List<Diamond>> queryDiamonds(
    Database db,
    String shape,
    String color,
    String clarity,
    double carat,
  ) async {
    print(
        "Executing Query: shape = $shape, color = $color, clarity = $clarity, carat = $carat");

    final List<Map<String, dynamic>> maps = await db.query(
      'diamonds',
      where:
          'shape = ? AND color = ? AND clarity = ? AND ? >= carat_from AND ? <= carat_to',
      whereArgs: [shape, color, clarity, carat, carat],
    );

    print("Query Result: $maps");

    return List.generate(maps.length, (i) {
      return Diamond(
        maps[i]['shape'],
        maps[i]['clarity'],
        maps[i]['color'],
        maps[i]['carat_from'].toDouble(),
        maps[i]['carat_to'].toDouble(),
        maps[i]['price'].toDouble(),
        maps[i]['expiry_date'],
      );
    });
  }
  // Inside database_helper.dart

  static Future<bool> isDiamondExist(Database db, Diamond diamond) async {
    final List<Map<String, dynamic>> result = await db.query(
      'diamonds',
      where:
          'shape = ? AND color = ? AND clarity = ? AND carat_from = ? AND carat_to = ?',
      whereArgs: [
        diamond.shape,
        diamond.color,
        diamond.clarity,
        diamond.caratFrom,
        diamond.caratTo,
      ],
    );
    return result.isNotEmpty;
  }
}
