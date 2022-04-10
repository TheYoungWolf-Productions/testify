import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/auth_storage.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/side_menu_bar.dart';
import 'package:testify/screens/Welcome/QuizModule/search_bar.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("Press Logout Button")));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: SideMenuBar(),
        appBar: AppBar(
          backgroundColor: Color(0xff3F2668),
          elevation: 2,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xff7F1AF1),
                      Color(0xff482384)
                    ])
            ),
          ),
          title: const Text("Home",
            style: TextStyle(
              color: Color(0xffFFFEFE),
              fontFamily: 'Brandon-bld',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Use this where ever Navigated to Login
                final result = Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(builder: (BuildContext context) => const Login(fromWhere:"Home")),
                  ModalRoute.withName('/'),
                );

              },
              child: SvgPicture.asset(
                "assets/Images/logout.svg",
                height: (MediaQuery.of(context).size.height) *(32/926),
              ),
            ),
          ],
        ),
        body: TextButton(
          onPressed: () async {
            final result = Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchListExample()),
            );


            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // var quizID = prefs.getInt("quizId");
            // var _token = prefs.getString('token')!;
            // // print(quizID);
            // final String apiUrlGenerateQuiz = "https://demo.pookidevs.com/quiz/solver/saveQuiz";
            //   http.post(Uri.parse(apiUrlGenerateQuiz), headers: <String, String>{
            //     'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
            //   }, body: json.encode(
            //       {
            //         "data":
            //         {
            //           "quiz" : {
            //             "quizId": 387145,
            //             "quizTitle": "First Quiz", // "Custom Quiz" + Date.now()
            //             "quizDate": " ", // "Custom Quiz"
            //             "quizScore": "20", // total correct
            //             "quizTotalQuestions": "20",
            //             "quizStatus": "completed", // "completed", "suspended"
            //             "quizQuestions": "[15,18]", // Question IDs
            //             "quizMode":"tutor", // "tutor", "exam"
            //             "quizTime": "900", // total quiz time in seconds
            //             "isTimed": false, // bool true or false
            //             "omittedQuestions": [], // Don't send anything here
            //             "SelectedOptionsArray": [] // Don't send anything here
            //           },
            //           "userId": 7
            //         }
            //       })
            //   ).then((response) {
            //     print(jsonDecode(response.body).toString());
            //     if((response.statusCode == 200) & (json.decode(response.body).toString().substring(0,14) != "{status: false")) {
            //
            //     }
            //     else { // Token Invalid
            //
            //     }
            //   }
            //   );


          },
          child: Text("Search Bar"),
        ),
      ),
    );
  }
}
