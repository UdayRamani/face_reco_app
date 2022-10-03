import 'dart:io';

import 'package:face_detaction_app/Screens/login.dart';
import 'package:face_detaction_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/home.dart';
import 'l10n/language_constant.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }


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
      title: 'Qazna Biometric',
      // supportedLocales: L10n.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,

      theme: ThemeData(
          // primarySwatch: HexColor("#2760ff"),
          primaryColor: HexColor("#2760ff"),
          appBarTheme: AppBarTheme(
              foregroundColor: Colors.white,
              backgroundColor: HexColor("#2760ff"),
              brightness: Brightness.dark)),
      routes: {
        "/home": (context) => const Home(),
        "/login": (context) => const LoginScreen(),
      },
      // home: Home(),
      home: checkLogin ? const Home() : const LoginScreen(),
    );
  }
}
