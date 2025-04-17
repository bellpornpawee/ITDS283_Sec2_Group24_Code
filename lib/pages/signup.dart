import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late Database _database;
  bool _isDatabaseReady = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String path = p.join(await getDatabasesPath(), 'user_db.db');
    _database = await openDatabase(path, version: 1);
    setState(() => _isDatabaseReady = true);
  }

  Future<void> _registerUser(String username, String password) async {
    if (!_isDatabaseReady) return;

    final existingUser = await _database.query(
      'users',
      where: 'username = ?',
      whereArgs: [username.trim()],
    );

    if (existingUser.isNotEmpty) {
      _showDialog('Error', 'Username already exists');
      return;
    }

    await _database.insert('users', {
      'username': username.trim(),
      'password': password.trim(),
    });

    _showDialog('Success', 'User registered successfully!');
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (title == 'Success') {
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  InputDecoration _customInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.purple.shade50,
      border: const UnderlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 24, bottom: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF1C2B4A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Register',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
          ),

          // Form Fields
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: _customInputDecoration('E-mail'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _customInputDecoration('Password'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    decoration: _customInputDecoration('Username'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    decoration: _customInputDecoration('Address'),
                  ),
                  const SizedBox(height: 32),

                  // Log in Button (styled)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _registerUser(
                          _usernameController.text,
                          _passwordController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E4A7D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
