import 'package:path/path.dart' as path1;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String monthHistory = "MonthHistory";
  static const String dayStatus = "DayStatus";
  static const String exerciseHistory = "ExerciseHistory";
  static const String exerciseStatus = "ExerciseStatus";
  static const String circuitManager = "CircuitManager";
  static const String extraSetHistory = "ExtraSetHistory";
  static const String removedExerciseHistory = "RemovedExerciseHistory";
  static const String exerciseNotes = "ExerciseNotes";

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = path1.join(documentsDirectory.path, 'Exercise.db');
    return await openDatabase(path, version: 2, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $exerciseHistory (
        id INTEGER PRIMARY KEY autoincrement,
        split TEXT,
        dataId TEXT,
        exerciseId TEXT,
        extraId TEXT,
        monthId TEXT,
        weekId TEXT,
        dayId TEXT,
        sets TEXT,
        reps TEXT,
        weight TEXT,
        rest TEXT,
        load TEXT,
        type TEXT,
        effort TEXT,
        date TEXT,  
        `index` INTEGER,
        subIndex INTEGER,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $exerciseStatus (
        id INTEGER PRIMARY KEY autoincrement,
        split TEXT,
        dataId TEXT,
        exerciseId TEXT,
        monthId TEXT,
        weekId TEXT,
        dayId TEXT,
        type TEXT,
        date TEXT,  
        status TEXT,
        totalWeight TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $dayStatus (
        id INTEGER PRIMARY KEY autoincrement,
        dataId TEXT,
        split TEXT,
        monthId TEXT,
        weekId TEXT,
        dayId TEXT,
        date TEXT,  
        status TEXT,
        title TEXT,
        startTime TEXT,
        endTime TEXT,
        type TEXT,
        totalWeight TEXT,
        completedExercise TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $circuitManager (
        id INTEGER PRIMARY KEY autoincrement,
        dataId TEXT,
        lastRound INTEGER,
        lastExerciseCount INTEGER,
        exerciseCountList TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $extraSetHistory (
        id INTEGER PRIMARY KEY autoincrement,
        dataId TEXT,
        sets INTEGER,
        reps INTEGER,
        weight INTEGER,
        rest INTEGER,
        load INTEGER,
        type INTEGER,
        extraId TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $removedExerciseHistory (
        id INTEGER PRIMARY KEY autoincrement,
        dataId TEXT,
        exerciseId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $monthHistory (
        id INTEGER PRIMARY KEY autoincrement,
        monthId TEXT,
        monthStartDate TEXT,
        monthEndDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $exerciseNotes (
        id INTEGER PRIMARY KEY autoincrement,
        exerciseId TEXT,
        date TEXT,
        note TEXT
      )
    ''');
  }

  Future<int> insertData({required String tableName, required Map<String, dynamic> data}) async {
    Database db = await database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> fetchData({required String tableName}) async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> getDataFromTable({required String tableName, required String where, required String id}) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(tableName, where: '$where = ?', whereArgs: [id]);
    return results;
  }

  Future<List<Map<String, dynamic>>> getFilteredWithExerciseData({
    required String tableName,
    required String exerciseId,
    required String monthId,
    required String dayId,
    required String weekId,
    required String split,
  }) async {
    Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'exerciseId = ? AND monthId = ? AND dayId = ? AND weekId = ? AND split = ?',
      whereArgs: [exerciseId, monthId, dayId, weekId, split],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getFilteredWithMWDData({
    required String tableName,
    required String monthId,
    required String dayId,
    required String weekId,
    required String split,
  }) async {
    Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'monthId = ? AND dayId = ? AND weekId = ? AND split = ?',
      whereArgs: [monthId, dayId, weekId, split],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getFilteredWithMWData({
    required String tableName,
    required String monthId,
    required String weekId,
    required String split,
  }) async {
    Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'monthId = ? AND weekId = ? AND split = ?',
      whereArgs: [monthId, weekId, split],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getFilteredWithMData({
    required String tableName,
    required String monthId,
    required String split,
  }) async {
    Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'monthId = ? AND split = ?',
      whereArgs: [monthId, split],
    );

    return results;
  }

  Future<Map<String, dynamic>?> getDataById({required String tableName, required String id}) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(tableName, where: 'dataId = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getDataByAnyWithSplitField({
    required String tableName,
    required String fieldName,
    required String split,
    required String id,
  }) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: '$fieldName = ? AND split = ?',
      whereArgs: [id, split],
    );
    return results;
  }

  Future<int> updateData({required String tableName, required Map<String, dynamic> data, required String id}) async {
    Database db = await database;
    return await db.update(tableName, data, where: 'dataId = ?', whereArgs: [id]);
  }

  Future<int> updateSingleValue({
    required String tableName,
    required String columnName,
    required dynamic newValue,
    required String id,
  }) async {
    Database db = await database;
    return await db.update(
      tableName,
      {columnName: newValue},
      where: 'dataId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllData(String tableName) async {
    Database db = await database;
    await db.delete(tableName);
  }

  Future<int> deleteData(int id, {required String tableName}) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSingleData({
    required String tableName,
    required int id,
  }) async {
    Database db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
