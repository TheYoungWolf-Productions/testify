import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testify/models/resultDetails/result_details_model.dart';
import 'package:testify/screens/Components/styles.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/TestAnalysis/analysisDetails.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/TestAnalysis/mainTestAnalysisScreen.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/TestResults/mainResultDetailsScreen.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/TestResults/resultDetails.dart';

import '../../../Authentication/login.dart';
import '../../side_menu_bar.dart';


class TestResults extends StatefulWidget {
  const TestResults({required this.quizId, required this.fromWhere,});
  final String fromWhere;
  final int quizId;
  @override
  _TestResultsState createState() => _TestResultsState();
}

class _TestResultsState extends State<TestResults> {

  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  var _token;
  var _userId;
  var _getResultDetails;
  bool _hasGetResultDetailsLoaded = false;

  Future<void> _onItemTapped(int index) async {
    if(_hasGetResultDetailsLoaded == true) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      MainResultDetails(quizId: widget.quizId),
     ResultDetails()
    ];
    getResultDetails();
  }

  Future<void> getResultDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrlGetResultDetails = "https://demo.pookidevs.com/quiz/result/getQuizResults";
    _token = prefs.getString('token')!;
    print(_token);
    _userId = prefs.getInt("userId")!;
    print(_userId);
    http.post(Uri.parse(apiUrlGetResultDetails), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "quizId": widget.quizId
        })
    ).then((response) {
      print(jsonDecode(response.body).toString());
      if((response.statusCode == 200) & (json.decode(response.body).toString().substring(0,14) != "{status: false")) {
        final responseString = (response.body);
        prefs.setString("getResultDetailsAPI", responseString);
        var getResultDetails1 = resultDetailsModelFromJson(responseString);
        final ResultDetailsModel getResultDetails = getResultDetails1;
        setState(() {
          _getResultDetails = getResultDetails;
          // print(_getResultDetails.data.worstSubject.toString());
          _hasGetResultDetailsLoaded = true;
          // print(_quizId);
        });
        // categoriesGenerateQuizData();
      }
      else { // Token Invalid
        final result = Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => const Login(fromWhere:"Home")),
          ModalRoute.withName('/'),
        );
      }
    }
    ).catchError((error){
      setState(() {
        _hasGetResultDetailsLoaded = true;
      });
      var errorSplit = error.toString().split(":");
      if(errorSplit[0].toLowerCase() == "socketexception") {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("No Internet Connection")));
      }
      // else if(errorSplit[0].toLowerCase() == "httpexception") {
      //   ScaffoldMessenger.of(context)
      //     ..removeCurrentSnackBar()
      //     ..showSnackBar(SnackBar(content: Text("Couldn't find the said thing.")));
      // }
      else if(errorSplit[0].toLowerCase() == "formatexception") {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Bad Response Format")));
      }
      else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.fromWhere == "QuizModule") {
          Navigator.of(context)
              .popUntil(ModalRoute.withName("/home"));
        }
        else if(widget.fromWhere == "PrevQuiz") {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffF8F9FB),
        drawer: SideMenuBar(),
        appBar: AppBar(
          toolbarHeight: (MediaQuery.of(context).size.height) * (73.52 / 926),
          backgroundColor: Color(0xff3F2668),
          elevation: 2,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xff7F1AF1), Color(0xff482384)])),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Login(fromWhere: "Home")),
                );
              },
              child: SvgPicture.asset(
                "assets/Images/logout.svg",
                height: (MediaQuery.of(context).size.height) * (32 / 926),
              ),
            ),
          ],
        ),
        body: _hasGetResultDetailsLoaded == false ? Center(child: CircularProgressIndicator(color: Color(0xff482384),)) : _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor:Color(0xff7F1AF1),
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart_outlined),
              label: 'Results',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'Details',
            ),],
        ) ,

      ),
    );
  }
}
