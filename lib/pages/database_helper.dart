import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const _dbName = 'my_database.db';
  static const _dbVersion = 1;
  static const _tableName = 'my_table';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY,
        name TEXT,
        brand TEXT,
        location TEXT,
        subtitle TEXT,
        imagePath TEXT,
        date TEXT,
        username TEXT
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(_tableName, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      _tableName,
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<Map<String, dynamic>?> getItemById(int id) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    final db = await database;

    if (query.isEmpty) {
      return [];
    }

    return await db.query(
      _tableName,
      where: 'name LIKE ? OR subtitle LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }

  Future<String> _saveImageToFile(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$timestamp-${basename(imageFile.path)}';
    final localImage = await imageFile.copy(join(directory.path, fileName));
    return localImage.path;
  }

  Future<int> updateImagePath(int id, File imageFile) async {
    final imagePath = await _saveImageToFile(imageFile);
    final db = await database;
    return await db.update(
      _tableName,
      {'imagePath': imagePath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
