import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app_with_firebase/auth/auth.dart';
import 'package:social_media_app_with_firebase/auth/login_or_register.dart';
import 'package:social_media_app_with_firebase/firebase_options.dart';
import 'package:social_media_app_with_firebase/pages/home_page.dart';
import 'package:social_media_app_with_firebase/pages/profile_page.dart';
import 'package:social_media_app_with_firebase/pages/users_page.dart';
import 'package:social_media_app_with_firebase/theme/dark_mode.dart';
import 'package:social_media_app_with_firebase/theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Auth(),
      theme: lightMode,
      darkTheme: darkMode,

      routes: {
        '/login_page': (context) =>  LoginOrRegister(),
        '/home_page': (context)=> HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/u': (context) => UsersPage(),

      },
    );
  }
}
