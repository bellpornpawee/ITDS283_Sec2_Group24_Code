import 'package:flutter/material.dart';
import 'pages/homepage.dart';


import 'pages/login_page.dart';

import 'pages/splash_screen.dart';
import 'pages/signup.dart';
import 'pages/chatbot.dart';
 // เพิ่มหน้า LocationPage
import 'pages/search.dart';
   // เพิ่มหน้า SearchPage ถ้ามี

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Routing Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const RegisterPage(),
        // '/showdata': (context) => const ShowDataPage(),
        '/homepage': (context) => const Homepage(),
        '/chat': (context) => const ChatWithAdminPage(),
        // '/upload': (context) => const ShowDataPage(),
        '/search': (context) => const SearchPage(),
        
      },
    );
  }
}
