import 'package:flutter/material.dart';
//import 'package:flutter_application_1/%E0%B8%B5upload.dart';
// import 'splash_screen.dart';
// import 'login_page.dart';
// import 'signup.dart';
// import 'showdata.dart';
import 'upload.dart';
import 'chat_with_admin.dart';
import 'location_page.dart';
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
        // '/': (context) => const SplashScreen(),
        // // '/login': (context) => const DatabaseHelper(),
        // '/signup': (context) => const SignUpPage(),
        // '/showdata': (context) => const ShowDataPage(),
        // '/homepage': (context) => const HomePage(),
          '/': (context) => const UploadPage(),
        '/upload' :(context) => const UploadPage(),
        '/chat': (context) => const ChatWithAdminPage(),
        '/location': (context) => const LocationPage(),
        


      },
    );
  }
}