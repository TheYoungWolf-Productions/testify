import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testify/models/GetPreviousQuizzesModel/TestAnalysisModel/test_analysis_model.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/TestAnalysis/analysisDetails.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/TestAnalysis/testAnalysis.dart';

import '../../../Authentication/login.dart';
import '../../side_menu_bar.dart';



class MainTestAnalysis extends StatefulWidget {
  MainTestAnalysis({required this.quizId,});
  final int quizId;

  @override
  State<MainTestAnalysis> createState() => _MainTestAnalysisState();
}

class _MainTestAnalysisState extends State<MainTestAnalysis> {

  String bestSubj = "Loading...";
  String worstSubj = "Loading...";
  String timeTaken = "Loading...";
  var _timeTaken;
  int total = 0; // This is the sum of Correct to Correct , Incorrect to Incorrect, Correct to Incorrect and Incorrect to Correct
  Map<String, double> dataMap = <String, double>{
    //'total': 10,
    'correct': 5,
    'incorrect': 2,
    'omitted': 3
  };
  Map<String, String> legendLabels = <String, String>{
    //'total': 'Questions Answered     ',
    'correct': 'Correct Questions',
    'incorrect': 'Incorrect Questions      ',
    'omitted': 'Omitted Questions'
  };
  final colorList = <Color>[
    Colors.white,
    Colors.deepPurple,
    Colors.grey,

  ];
  String performance = '75%'; // Just divide the questionsAnswered by totalCorrect
  final centerText = 'Performance';
  final correct = 0.3; //percentage b/w 0-1
  final incorrect = 0.6;

  var _token;
  var _userId;
  var _getQuizAnalysis;

  String timeTakenFunction() {
    // int.parse(timeTaken) < 60 ? (int.parse(timeTaken) == 1 ? (timeTaken.toString() + ' second') : (timeTaken.toString() + ' seconds')) : ((int.parse(timeTaken) ~/ 60) == 1 ? (((int.parse(timeTaken) ~/ 60).toString() + ' minute') : ((int.parse(timeTaken) ~/ 60).toString() + ' minutes')) + ((int.parse(timeTaken) % 60) == 1 ? (int.parse(timeTaken) % 60).toString() + ' second')) : ((int.parse(timeTaken) % 60).toString() + ' seconds')),
    setState(() {
      if(int.parse(timeTaken) < 60) {
        if(int.parse(timeTaken) == 1) {
          _timeTaken = timeTaken.toString() + ' sec';
        }
        else {
          _timeTaken = timeTaken.toString() + ' sec';
        }
      }
      else {
        if((int.parse(timeTaken) ~/ 60) == 1) {
          if((int.parse(timeTaken) % 60) == 1) {
            _timeTaken = (int.parse(timeTaken) ~/ 60).toString() + ' : ' + (int.parse(timeTaken) % 60).toString() ;
          }
          else if((int.parse(timeTaken) % 60) != 1) {
            _timeTaken = (int.parse(timeTaken) ~/ 60).toString() + ' : ' + (int.parse(timeTaken) % 60).toString() ;
          }
        }
        if((int.parse(timeTaken) ~/ 60) != 1) {
          if((int.parse(timeTaken) % 60) == 1) {
            _timeTaken = (int.parse(timeTaken) ~/ 60).toString() + ' : ' + (int.parse(timeTaken) % 60).toString() ;
          }
          else if((int.parse(timeTaken) % 60) != 1) {
            _timeTaken = (int.parse(timeTaken) ~/ 60).toString() + ' : ' + (int.parse(timeTaken) % 60).toString() ;
          }
        }
      }
    });
    return _timeTaken;
  }

  @override
  void initState() {
    super.initState();
    getQuizAnalysis();
  }

  getQuizAnalysis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? responseString = prefs.getString("getQuizAnalysisAPI");
    var getQuizAnalysis1 = testAnalysisModelFromJson(responseString!);
    final TestAnalysisModel getQuizAnalysis = getQuizAnalysis1;
    setState(() {
      _getQuizAnalysis = getQuizAnalysis;
      bestSubj = _getQuizAnalysis.data.bestSubject.toString();
      worstSubj = _getQuizAnalysis.data.worstSubject.toString();
      timeTaken = _getQuizAnalysis.data.timeTaken.toString();
      dataMap = <String, double>{
        //'total': _getQuizAnalysis.data.totalQuestionsAnswered.toDouble(),
        'correct': _getQuizAnalysis.data.totalCorrect.toDouble(),
        'incorrect': _getQuizAnalysis.data.totalIncorrect.toDouble(),
        'omitted': _getQuizAnalysis.data.totalOmitted.toDouble()
      };
      total = _getQuizAnalysis.data.totalCorrectToCorrect + _getQuizAnalysis.data.totalCorrectToIncorrect + _getQuizAnalysis.data.totalIncorrectToCorrect + _getQuizAnalysis.data.totalIncorrectToIncorrect;
      performance = (_getQuizAnalysis.data.totalQuestionsAnswered / _getQuizAnalysis.data.totalCorrect).isNaN ? '0%' : (((_getQuizAnalysis.data.totalCorrect / _getQuizAnalysis.data.totalQuestionsAnswered) * 100).toStringAsFixed(1).toString() + '%');
      print(_getQuizAnalysis.data.status);
    });
  }


  @override
  Widget build(BuildContext context) {
    return _getQuizAnalysis == null ? Center() : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: (MediaQuery.of(context).size.height) * (15 / 926),
              bottom: (MediaQuery.of(context).size.height) * (8 / 926),
              left: (MediaQuery.of(context).size.width) * (18 / 428),
              right: (MediaQuery.of(context).size.width) * (18 / 428)),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width) * (221 / 428),
                    //height: (MediaQuery.of(context).size.height) *(91/926),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Test Analysis",
                            style: TextStyle(
                              color: Color(0xff232323),
                              fontFamily: 'Brandon-bld',
                              fontSize: (MediaQuery.of(context).size.height) *
                                  (25 / 926), //38,
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                          (MediaQuery.of(context).size.height) * (2 / 926),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet finibus elit non luctus. Morbi auctor mattis ante.",
                          style: TextStyle(
                            color: Color(0xFF483A3A),
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) *
                                (13 / 926), //38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) * (39 / 428),
                  ),
                  Container(
                    //color: Colors.transparent,
                    child: SvgPicture.asset(
                      "assets/Images/prevQuiz.svg",
                      height:
                      (MediaQuery.of(context).size.height) * (100 / 926),
                      //width: (MediaQuery.of(context).size.width) *(132/428),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height) * (30 / 926),
              ),
              Column(
                children: [
                  PieChart(
                    dataMap: dataMap,
                    colorList: colorList,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 28,
                    chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: false, showChartValues: false),
                    centerText: performance + '\nAverage Performance',
                    centerTextStyle: TextStyle(
                      color: Color(0xFF483A3A),
                      fontFamily: 'Brandon-med',
                      fontSize: (MediaQuery.of(context).size.height) * (16 / 926),
                    ),
                    legendLabels: legendLabels,
                    legendOptions: LegendOptions(
                        legendTextStyle: TextStyle(
                          color: Color(0xFF483A3A),
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) * (13 / 926),
                        )),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height) * (10 / 926),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * (30 / 926),
                        horizontal:
                        (MediaQuery.of(context).size.width) * (30 / 428)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Correct to Correct ' +
                                  (((_getQuizAnalysis.data.totalCorrectToCorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalCorrectToCorrect/total) * 100).toStringAsFixed(1).toString() +
                                  ' %',
                              style: TextStyle(
                                color: Color(0xff6D5A8D),
                                fontFamily: 'Brandon-med',
                                fontSize: (MediaQuery.of(context).size.height) *
                                    (12 / 926),
                              ),
                            ),
                            LinearPercentIndicator(
                              width:
                              (MediaQuery.of(context).size.width) * (160 / 428),
                              lineHeight:
                              (MediaQuery.of(context).size.height) * (7 / 926),
                              percent: ((_getQuizAnalysis.data.totalCorrectToCorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalCorrectToCorrect/total),
                              progressColor: Color(0xff6D5A8D),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Correct to Incorrect ' +
                                  (((_getQuizAnalysis.data.totalCorrectToIncorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalCorrectToIncorrect/total) * 100).toString() +
                                  ' %',
                              style: TextStyle(
                                color: Color(0xff6D5A8D),
                                fontFamily: 'Brandon-med',
                                fontSize: (MediaQuery.of(context).size.height) *
                                    (12 / 926),
                              ),
                            ),
                            LinearPercentIndicator(
                              width:
                              (MediaQuery.of(context).size.width) * (160 / 428),
                              lineHeight:
                              (MediaQuery.of(context).size.height) * (7 / 926),
                              percent: ((_getQuizAnalysis.data.totalCorrectToIncorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalCorrectToIncorrect/total),
                              progressColor: Color(0xff6D5A8D),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * (10 / 926),
                        horizontal:
                        (MediaQuery.of(context).size.width) * (30 / 428)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Incorrect to Correct ' +
                                  (((_getQuizAnalysis.data.totalIncorrectToCorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalIncorrectToCorrect/total) * 100).toString() +
                                  ' %',
                              style: TextStyle(
                                color: Color(0xff6D5A8D),
                                fontFamily: 'Brandon-med',
                                fontSize: (MediaQuery.of(context).size.height) *
                                    (12 / 926),
                              ),
                            ),
                            LinearPercentIndicator(
                              width:
                              (MediaQuery.of(context).size.width) * (160 / 428),
                              lineHeight:
                              (MediaQuery.of(context).size.height) * (7 / 926),
                              percent: ((_getQuizAnalysis.data.totalIncorrectToCorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalIncorrectToCorrect/total),
                              progressColor: Color(0xff6D5A8D),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Incorrect to Incorrect ' +
                                  (((_getQuizAnalysis.data.totalIncorrectToIncorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalIncorrectToIncorrect/total) * 100).toString() +
                                  ' %',
                              style: TextStyle(
                                color: Color(0xff6D5A8D),
                                fontFamily: 'Brandon-med',
                                fontSize: (MediaQuery.of(context).size.height) *
                                    (12 / 926),
                              ),
                            ),
                            LinearPercentIndicator(
                              width:
                              (MediaQuery.of(context).size.width) * (160 / 428),
                              lineHeight:
                              (MediaQuery.of(context).size.height) * (7 / 926),
                              percent: ((_getQuizAnalysis.data.totalIncorrectToIncorrect/total).isNaN ? 0 : _getQuizAnalysis.data.totalIncorrectToIncorrect/total),
                              progressColor: Color(0xff6D5A8D),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height) * (30 / 926),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height) * (45 / 926),
                    width: (MediaQuery.of(context).size.width) * (325 / 428),
                    decoration: BoxDecoration(
                        color: Color(0xffE4E4E4),
                        border: Border.all(
                          color: Color(0xff6D5A8D),
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              (MediaQuery.of(context).size.height) * (10 / 926)),
                          width: (MediaQuery.of(context).size.width) * (141 / 428),
                          height: (MediaQuery.of(context).size.height) * (45 / 926),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xff6D5A8D),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    (MediaQuery.of(context).size.height) *
                                        (5 / 926)),
                                height: (MediaQuery.of(context).size.height) *
                                    (30 / 926),
                                decoration: BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: Color(0xff6D5A8D),
                                  size: (MediaQuery.of(context).size.height) *
                                      (15 / 926),
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width) *
                                    (10 / 428),
                              ),
                              Text(
                                'Best Subject',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Brandon-bld',
                                  fontSize: (MediaQuery.of(context).size.height) *
                                      (13 / 926), //38,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.symmetric( horizontal:
                              (MediaQuery.of(context).size.height) * (10 / 926)),
                          width: (MediaQuery.of(context).size.width) * (181 / 428),
                          height: (MediaQuery.of(context).size.height) * (45 / 926),
                          child: Text(
                            bestSubj,
                            style: TextStyle(
                              color: Color(0xff6D5A8D),
                              fontFamily: 'Brandon-bld',
                              fontSize: (MediaQuery.of(context).size.height) *
                                  (15 / 926), //38,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height) * (25 / 926),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height) * (45 / 926),
                    width: (MediaQuery.of(context).size.width) * (325 / 428),
                    decoration: BoxDecoration(
                        color: Color(0xffE4E4E4),
                        border: Border.all(
                          color: Color(0xff6D5A8D),
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              (MediaQuery.of(context).size.height) * (10 / 926)),
                          width: (MediaQuery.of(context).size.width) * (141 / 428),
                          height: (MediaQuery.of(context).size.height) * (45 / 926),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xff6D5A8D),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    (MediaQuery.of(context).size.height) *
                                        (5 / 926)),
                                height: (MediaQuery.of(context).size.height) *
                                    (30 / 926),
                                decoration: BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.thumb_down_alt_outlined,
                                  color: Color(0xff6D5A8D),
                                  size: (MediaQuery.of(context).size.height) *
                                      (15 / 926),
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width) *
                                    (10 / 428),
                              ),
                              Text(
                                'Worst Subject',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Brandon-bld',
                                  fontSize: (MediaQuery.of(context).size.height) *
                                      (13 / 926), //38,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.symmetric( horizontal:
                              (MediaQuery.of(context).size.height) * (10 / 926)),
                          width: (MediaQuery.of(context).size.width) * (181 / 428),
                          height: (MediaQuery.of(context).size.height) * (45 / 926),
                          child: Text(
                            worstSubj,
                            style: TextStyle(
                              color: Color(0xff6D5A8D),
                              fontFamily: 'Brandon-bld',
                              fontSize: (MediaQuery.of(context).size.height) *
                                  (15 / 926), //38,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height) * (25 / 926),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height) * (45 / 926),
                    width: (MediaQuery.of(context).size.width) * (325 / 428),
                    decoration: BoxDecoration(
                        color: Color(0xffE4E4E4),
                        border: Border.all(
                          color: Color(0xff6D5A8D),
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                              (MediaQuery.of(context).size.height) * (10 / 926)),
                          width: (MediaQuery.of(context).size.width) * (141 / 428),
                          height: (MediaQuery.of(context).size.height) * (45 / 926),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xff6D5A8D),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    (MediaQuery.of(context).size.height) *
                                        (5 / 926)),
                                height: (MediaQuery.of(context).size.height) *
                                    (30 / 926),
                                decoration: BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.timer_outlined,
                                  color: Color(0xff6D5A8D),
                                  size: (MediaQuery.of(context).size.height) *
                                      (15 / 926),
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width) *
                                    (10 / 428),
                              ),
                              Text(
                                'Time Taken',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Brandon-bld',
                                  fontSize: (MediaQuery.of(context).size.height) *
                                      (13 / 926), //38,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.symmetric( horizontal:
                              (MediaQuery.of(context).size.height) * (10 / 926)),
                          width: (MediaQuery.of(context).size.width) * (181 / 428),
                          height: (MediaQuery.of(context).size.height) * (45 / 926),
                          child: Text(
                            // timeTakenFunction(),
                            timeTaken.toString(),
                            // int.parse(timeTaken) < 60 ? (int.parse(timeTaken) == 1 ? (timeTaken.toString() + ' second') : (timeTaken.toString() + ' seconds')) : ((int.parse(timeTaken) ~/ 60) == 1 ? (((int.parse(timeTaken) ~/ 60).toString() + ' minute') : ((int.parse(timeTaken) ~/ 60).toString() + ' minutes')) + ((int.parse(timeTaken) % 60) == 1 ? (int.parse(timeTaken) % 60).toString() + ' second')) : ((int.parse(timeTaken) % 60).toString() + ' seconds')),
                            style: TextStyle(
                              color: Color(0xff6D5A8D),
                              fontFamily: 'Brandon-bld',
                              fontSize: (MediaQuery.of(context).size.height) *
                                  (15 / 926), //38,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
