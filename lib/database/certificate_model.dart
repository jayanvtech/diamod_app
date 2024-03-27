import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Certificate {
  String certificateNumber;
  String filePath;
  DateTime downloadDate;

  Certificate({
    required this.certificateNumber,
    required this.filePath,
    required this.downloadDate, 
  });

  Map<String, dynamic> toMap() {
    return {
      'certificateNumber': certificateNumber,
      'filePath': filePath,
      'downloadDate': downloadDate.toIso8601String(),
    };
  }
}

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'certificates.db';
  static const String tableName = 'certificates';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            certificateNumber TEXT,
            filePath TEXT,
            downloadDate TEXT
          )
          ''');
    });
  }

  static Future<void> insertCertificate(Certificate certificate) async {
    final db = await database;
    await db.insert(tableName, certificate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Certificate>> getCertificates() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Certificate(
        certificateNumber: maps[i]['certificateNumber'],
        filePath: maps[i]['filePath'],
        downloadDate: DateTime.parse(maps[i]['downloadDate']),
      );
    });
  }
}
