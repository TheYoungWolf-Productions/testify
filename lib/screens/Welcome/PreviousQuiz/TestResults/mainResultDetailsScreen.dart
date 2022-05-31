
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/models/resultDetails/result_details_model.dart';

import '../../../Components/styles.dart';


class MainResultDetails extends StatefulWidget {
  MainResultDetails({required this.quizId,});
  final int quizId;


  @override
  State<MainResultDetails> createState() => _MainResultDetailsState();
}

class _MainResultDetailsState extends State<MainResultDetails> {

  String totalScore = "Loading...";
  String timeTaken = "Loading...";
  int total = 0; // This is the sum of Correct to Correct , Incorrect to Incorrect, Correct to Incorrect and Incorrect to Correct
  Map<String, double> dataMap = <String, double>{};
  double performance = 0.75; // Just divide the questionsAnswered by totalCorrect
  final centerText = 'Performance';
  final correct = 0.3; //percentage b/w 0-1
  final incorrect = 0.6;
  var status;
  var _timeTaken;

  var _token;
  var _userId;
  var _getResultDetails;

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
    getQuizResults();
  }

  getQuizResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? responseString = prefs.getString("getResultDetailsAPI");
    var getResultDetails1 = resultDetailsModelFromJson(responseString!);
    final ResultDetailsModel getResultDetails = getResultDetails1;
    setState(() {
      _getResultDetails = getResultDetails;
      dataMap = <String, double>{
        'total': _getResultDetails.data.totalQuestions.toDouble(),
        'correct': _getResultDetails.data.totalCorrect.toDouble(),
        'incorrect': _getResultDetails.data.totalIncorrect.toDouble(),
        'omitted': _getResultDetails.data.totalOmitted.toDouble()
      };
      timeTaken = _getResultDetails.data.timeTaken;
      performance=(_getResultDetails.data.totalCorrect.toDouble()/_getResultDetails.data.totalQuestions.toDouble());
      status=_getResultDetails.data.status;
      (status=='completed')?status='Completed':status='Suspended';
      print(_getResultDetails.data.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height / 926;
    var w = MediaQuery.of(context).size.width / 428;
    return _getResultDetails == null ? Center() : Stack(
      children: [
        Container(
          height: h*420,
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.top+h *10, horizontal: w * 15),
        width: double.infinity,
        decoration: BoxDecoration(  gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xff7F1AF1), Color(0xff482384)])
        ),
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
                          "Test Results",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Brandon-bld',
                            fontSize: (MediaQuery.of(context).size.height) *
                                (20 / 926), //38,
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
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: 'Brandon-reg',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (10 / 926), //38,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height) * (73 / 926),
            ),
            Container(margin:EdgeInsets.all(h*10),
              padding: EdgeInsets.all(h*10),
              decoration: const BoxDecoration(
                color:Colors.transparent,
              ),
              height: h*153,
              width: h*153,
              child: Stack(children: [Center(child: SizedBox(height: h*153,
                  width: h*153,child: CircularProgressIndicator(value: performance,color: Colors.white,backgroundColor:Colors.grey.withOpacity(0.2),strokeWidth: 8,))),
              Center(child: Text((performance*100).toStringAsFixed(1).toString()+ ' %',style: TextStyle(
      color: Colors.white,
      fontFamily: 'Brandon-med',
      fontSize:h*25,
      ),))],),),
            Center(
              child: Text(status,textAlign: TextAlign.center,style: TextStyle(
                color: Colors.white,
                fontFamily: 'Brandon-med',
                fontSize:h*25,
              ),),
            ),
            SizedBox(height: h*10,),

          ],
        ),

      ),
        Container(
          height: h*140,
          width: w*370,
          margin: EdgeInsets.only(top:h*390,left:w*30),
          decoration: BoxDecoration(
            color:Color(0xffDEDEDE),
            border:Border.all(color: Colors.white,width: w*0.4),
            borderRadius: BorderRadius.circular(h*12),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text(
                      '  Total Questions  ',
                      style: TextStyle(
                        color: Styles.darkGrey,
                        fontFamily: 'Brandon-med',
                        fontSize: h*14,
                      ),
                    ),
                    Text(
                      (_getResultDetails.data.totalQuestions).toString(),
                      style: TextStyle(
                        color: Styles.lightPurple,
                        fontFamily: 'Brandon-med',
                        fontSize: h*16,
                      ),
                    ),
                  ],),
                  Column(children: [
                    Text(
                      'Correct Questions' ,
                      style: TextStyle(
                        color: Styles.darkGrey,
                        fontFamily: 'Brandon-med',
                        fontSize: h*14,
                      ),
                    ),
                    Text(
                      (_getResultDetails.data.totalCorrect).toString(),
                      style: TextStyle(
                        color: Styles.lightPurple,
                        fontFamily: 'Brandon-med',
                        fontSize: h*16,
                      ),
                    ),
                  ],),

                ],),
              SizedBox(height: h*15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text(
                      'Incorrect Questions',
                      style: TextStyle(
                        color: Styles.darkGrey,
                        fontFamily: 'Brandon-med',
                        fontSize: h*14,
                      ),
                    ),
                    Text(
                      (_getResultDetails.data.totalIncorrect).toString(),
                      style: TextStyle(
                        color: Styles.lightPurple,
                        fontFamily: 'Brandon-med',
                        fontSize: h*16,
                      ),
                    ),
                  ],),
                  Column(children: [
                    Text(
                      'Omitted Questions' ,
                      style: TextStyle(
                        color: Styles.darkGrey,
                        fontFamily: 'Brandon-med',
                        fontSize: h*14,
                      ),
                    ),
                    Text(
                      (_getResultDetails.data.totalOmitted).toString(),
                      style: TextStyle(
                        color: Styles.lightPurple,
                        fontFamily: 'Brandon-med',
                        fontSize: h*16,
                      ),
                    ),
                  ],),

                ],),

            ],),
        ),
        Container(
          height: h*409,width: double.infinity,color: Colors.white,margin: EdgeInsets.only(top: h*560),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height) * (75 / 926),
                    width: (MediaQuery.of(context).size.width) * (173 / 428),padding: EdgeInsets.all(h*10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xff7F1AF1),Color(0xff482384)],begin: Alignment.topCenter,end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Container(height:h*40,width:w*30,decoration:BoxDecoration(borderRadius: BorderRadius.circular(h*5),color:Colors.white),child:  Icon(Icons.fact_check_rounded,color: Styles.lightPurple,size: h*20,)),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Score',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Brandon-med',
                                fontSize: h*16,
                              ),
                            ),
                            Text(
                              (_getResultDetails.data.score).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brandon-med',
                                fontSize: h*20,
                              ),
                            ),
                          ],)],
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height) * (75 / 926),
                    width: (MediaQuery.of(context).size.width) * (173 / 428),padding: EdgeInsets.all(h*10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xff7F1AF1),Color(0xff482384)],begin: Alignment.topCenter,end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Container(height:h*40,width:w*30,decoration:BoxDecoration(borderRadius: BorderRadius.circular(h*5),color:Colors.white),child: Icon(Icons.timelapse_rounded,color: Styles.lightPurple,size: h*20,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Time Taken',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Brandon-med',
                                fontSize: h*16,
                              ),
                            ),
                            Text(
                              timeTakenFunction(),
                              //(_getResultDetails.data.timeTaken).toString()+' secs',
                              style: TextStyle(
                                color:Colors.white,
                                fontFamily: 'Brandon-med',
                                fontSize: h*20,
                              ),
                            ),
                          ],)],
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
    ]);
  }
}
