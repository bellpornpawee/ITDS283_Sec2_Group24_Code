import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class ShowDataPage extends StatefulWidget {
  const ShowDataPage({super.key});

  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {
  late Database _database;
  bool _isDatabaseReady = false; // ใช้ตัวแปรนี้ตรวจสอบว่า database พร้อมแล้วหรือยัง

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // สร้าง database และ table
  Future<void> _initializeDatabase() async {
    String path = p.join(await getDatabasesPath(), 'users.db');
    _database = await openDatabase(
      path,
      version: 1,
    );
    setState(() {
      _isDatabaseReady = true; // เมื่อฐานข้อมูลเปิดใช้งานเสร็จแล้ว อัพเดท state
    });
  }

  // ดึงข้อมูลผู้ใช้ทั้งหมดจาก database
  Future<List<Map<String, dynamic>>> _getUsers() async {
    if (!_isDatabaseReady) {
      return []; // ถ้าฐานข้อมูลยังไม่พร้อม ให้รีเทิร์น list ว่างๆ
    }
    final List<Map<String, dynamic>> users = await _database.query('users');
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Show Data')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUsers(), // เรียกใช้ฟังก์ชันที่ดึงข้อมูลจากฐานข้อมูล
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // แสดง progress indicator ขณะรอ
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['username'] ?? 'No username'),
                  subtitle: Text(user['password'] ?? 'No password'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
