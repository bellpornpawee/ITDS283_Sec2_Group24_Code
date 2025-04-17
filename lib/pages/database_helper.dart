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
        date TEXT
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

  // ฟังก์ชันค้นหาสินค้าจากฐานข้อมูล
  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    final db = await database;

    if (query.isEmpty) {
      return [];  // ถ้าไม่มีคำค้นหาก็คืนค่าลิสต์เปล่า
    }

    // ใช้ LIKE สำหรับการค้นหาผ่านชื่อและ subtitle
    final result = await db.query(
      _tableName,
      where: 'name LIKE ? OR subtitle LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return result.isEmpty ? [] : result;  // คืนค่าผลลัพธ์หรือคืนค่าลิสต์เปล่า
  }
}
