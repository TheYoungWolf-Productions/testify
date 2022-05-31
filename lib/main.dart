import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testify/auth_storage.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/GenerateQuiz/generate_quiz.dart';
import 'package:testify/screens/Welcome/QuizModule/quiz_module.dart';
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
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => Login(fromWhere: "main",),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/home': (context) => Home(),
        },
      // home: Login(fromWhere: "main",)
    );
  }
}