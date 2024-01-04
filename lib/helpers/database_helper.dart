import 'package:bmi_calculator_app/model/bmi_record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'bmi_records';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, 'bmi_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bmiScore REAL,
            age INTEGER,
            gender INTEGER,
            height INTEGER,
            weight INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertBMIRecord(BMIRecord record) async {
    final db = await database;
    return await db.insert(tableName, record.toMap());
  }

  Future<List<BMIRecord>> getBMIRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return BMIRecord.fromMap(maps[i]);
    });
  }

  Future<int> updateBMIRecord(BMIRecord record) async {
    final db = await database;
    return await db.update(
      tableName,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteBMIRecord(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
