import 'dart:io';

import 'package:face_detaction_app/login.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
// @dart=2.9

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool checkLogin = false;
  String roles = "";

  @override
  void initState() {
    super.initState();
    loginScreen();
  }

  Future<void> loginScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    checkLogin = pref.getBool("loginScreen")!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      supportedLocales: [Locale('en', ''), Locale('ru', ''), Locale('hi', '')],
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          appBarTheme: AppBarTheme(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              brightness: Brightness.dark)),
      routes: {
        "/home": (context) => const Home(),
        "/login": (context) => const LoginScreen(),
      },
      home: checkLogin ? Home() : LoginScreen(),
    );
  }
}
