import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testify/auth_storage.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Login(fromWhere: "main",));
  }
}