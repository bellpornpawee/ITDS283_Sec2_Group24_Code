import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late Database _database;
  bool _isDatabaseReady = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // Initialize database
  Future<void> _initializeDatabase() async {
    try {
      String path = p.join(await getDatabasesPath(), 'user_db.db');
      _database = await openDatabase(path, version: 1, onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');
        // Add some test data
        await db.insert('users', {'username': 'testuser', 'password': 'password123'});
        await db.insert('users', {'username': 'admin', 'password': 'adminpass'});
      });

      setState(() {
        _isDatabaseReady = true;
      });
    } catch (e) {
      print("Error initializing database: $e");
    }
  }

  // Check user credentials
  Future<bool> _checkUserCredentials(String username, String password) async {
    if (!_isDatabaseReady) {
      print("Database is not ready yet.");
      return false;
    }

    try {
      final result = await _database.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      return result.isNotEmpty;
    } catch (e) {
      print("Error checking credentials: $e");
      return false;
    }
  }

  // Login logic
  Future<void> _login() async {
    setState(() => _isLoading = true);

    String username = _usernameController.text;
    String password = _passwordController.text;

    bool isValidUser = await _checkUserCredentials(username, password);

    setState(() => _isLoading = false);

    if (isValidUser) {
      print("Login successful!");
      Navigator.pushReplacementNamed(context, '/homepage');
    } else {
      print("Login failed.");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Fetch and print all user data
  Future<void> _printUserData() async {
    if (!_isDatabaseReady) {
      print("Database is not ready yet.");
      return;
    }

    try {
      final result = await _database.query('users');
      result.forEach((user) {
        print('ID: ${user['id']}, Username: ${user['username']}, Password: ${user['password']}');
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF0F1F3D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Username'),
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter username',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Password'),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter password',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: _login,
                            child: Container(
                              width: 120,
                              height: 45,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF4A90E2), Color(0xFF0F1F3D)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account yet? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Add the button to print data to the console
                    // GestureDetector(
                    //   onTap: _printUserData,
                    //   child: Container(
                    //     width: 160,
                    //     height: 45,
                    //     decoration: BoxDecoration(
                    //       gradient: const LinearGradient(
                    //         colors: [Color(0xFF4A90E2), Color(0xFF0F1F3D)],
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //       ),
                    //       borderRadius: BorderRadius.circular(8),
                    //       boxShadow: const [
                    //         BoxShadow(
                    //           color: Colors.black26,
                    //           blurRadius: 4,
                    //           offset: Offset(2, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: const Center(
                    //       child: Text(
                    //         'Show Data',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
