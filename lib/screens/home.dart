import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/models/DashboardStatsModel/dashboard_stats_model.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/GenerateQuiz/generate_quiz.dart';
import 'package:testify/screens/Welcome/Notes/notes.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/previous_quiz.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var performance=0.75;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex=0;
  AppLifecycleState? _lastLifecycleState;

  var _token;
  var _userId;
  var _getDashboardStatsSuccessful;
  bool _hasDataLoaded = false;
  int _allQuizScoreLength = 0;

  final _duration = const Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();
    getDashboardStatsAPI();
  }

  Future<void> getDashboardStatsAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const String apiUrlGetDashboardStats =
        "https://demo.pookidevs.com/user/getDashboardStats";
    _token = prefs.getString('token')!;
    _userId = prefs.getInt("userId")!;
    http.get(
      Uri.parse(apiUrlGetDashboardStats),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': _token.toString(),
      },
    ).then((response) {
      // print(jsonDecode(response.body).toString());
      if (response.statusCode == 200) {
        if (json.decode(response.body).toString().substring(0, 20) ==
            "{data: {status: true") {
          final responseString = (response.body);
          var DashboardStatsSuccessful = dashboardStatsModelFromJson(responseString);
          final DashboardStatsModel getDashboardStatsSuccessful = DashboardStatsSuccessful;
          setState(() {
            _getDashboardStatsSuccessful = getDashboardStatsSuccessful;
            //print(_getDashboardStatsSuccessful.data.allQuizScores.length);
            _allQuizScoreLength = _getDashboardStatsSuccessful.data.allQuizScores.length;
            print(_getDashboardStatsSuccessful.data.allQuizScores);
            _hasDataLoaded = true;
          });
          // print(_questions);
        } else {}
      } else {
        //Token is Invalid
        if (json.decode(response.body).toString().substring(0, 14) ==
            "{status: false") {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text("Token Expired!")));
          final result = Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                const Login(fromWhere: "Home")),
            ModalRoute.withName('/'),
          );
        } else {}
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _logoutAlertDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Are you sure you want to go Logout?',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Brandon-med',
            fontSize: (MediaQuery.of(context).size.height) * (18 / 926),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text('No',
                style: TextStyle(
                  color: Color(0xff3F2668),
                  fontFamily: 'Brandon-bld',
                  fontSize:
                  (MediaQuery.of(context).size.height) * (21 / 926),
                )),
          ),
          TextButton(
            onPressed: () async {
              final result = Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                    const Login(fromWhere: "Home")),
                ModalRoute.withName('/'),
              );
            },
            child: Text('Yes',
                style: TextStyle(
                  color: Color(0xff3F2668),
                  fontFamily: 'Brandon-bld',
                  fontSize:
                  (MediaQuery.of(context).size.height) * (21 / 926),
                )),
          ),
        ],
      ),
    )) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height/926;
    var w=MediaQuery.of(context).size.width/428;
    return WillPopScope(
      onWillPop: () async {
        _logoutAlertDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff3F2668),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                  children:[
              Container(height: h*130,alignment: Alignment.topCenter,decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xff7F1AF1),Color(0xff482384)]),borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(30,8),
                bottomRight: Radius.elliptical(30,8),
              ),)),
              Container(padding:EdgeInsets.only(top: h*60,left:w*19 ),decoration: BoxDecoration(shape: BoxShape.circle),child: Icon(Icons.circle,size:w*88,color: Colors.white,),),
              Padding(
                padding: EdgeInsets.only(top:h*87,left: w*117),
                child: Text('Welcome Alen!',style: TextStyle( color: Colors.white.withOpacity(0.9),
                    fontFamily: 'Brandon-med',
                    fontSize: h * 22),),
              )
            ]),
              SizedBox(height: h*16,),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(h*12),
                child: Text('Actions',textAlign:TextAlign.start,style: TextStyle( color: Colors.white.withOpacity(0.9),
                    fontFamily: 'Brandon-med',
                    fontSize: h * 15),),
              ),
              Container(height: h*86,color: Color(0xff482384),
                padding: EdgeInsets.all(h*15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () async { // Generate Quiz
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GenerateQuiz()));
                  }, icon: Icon(Icons.edit,color: Colors.white,)),
                  VerticalDivider(color: Colors.white,),
                  IconButton(onPressed: () async { // Previous Quiz
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviousQuiz()));
                  }, icon: Icon(Icons.quiz_outlined,color: Colors.white,)),
                  VerticalDivider(color: Colors.white,),
                  IconButton(onPressed: () async { // Notes
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notes()));
                  }, icon: Icon(Icons.event_note_rounded,color: Colors.white,)),
                ],
              ),),
              SizedBox(height: h*38,),
              Container(
                height: h*353,
                width: w*329,
                padding: EdgeInsets.all(h*10),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                        height: h*343,
                        width: w*319,
                        margin: EdgeInsets.only(top:h*20,right: w*20),
                        decoration:BoxDecoration(
                            boxShadow:[ BoxShadow(color: Color(0xff482384)..withOpacity(0.5),offset:Offset(13,-13),blurRadius: h*2,spreadRadius: h*2),],
                            color: Color(0xff7F1AF1).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(h*20)
                        )


                    ),
                    Container(
                        height: h*343,
                        width: w*319,
                        margin: EdgeInsets.only(top:h*30,right: w*30),
                        decoration:BoxDecoration(
                          boxShadow:[ BoxShadow(color: Color(0xff482384).withOpacity(0.7),offset:Offset(10,-10),blurRadius: h*2,spreadRadius: h*2),],
                            color: Color(0xff482384).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(h*20)
                        ),
                      child: AnimatedCrossFade(
                        sizeCurve: ElasticOutCurve(),
                        firstCurve: Curves.bounceInOut,
                        secondCurve: Curves.easeInBack,
                        crossFadeState: _hasDataLoaded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: _duration,
                        secondChild: Container(alignment: Alignment.center,height: 270,child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1,)),
                        firstChild: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(top:10,left:15,right: 20,bottom: 0),
                          margin: EdgeInsets.only(top:10,left:10,right: 10,bottom: 0),
                          width: double.infinity,
                          height: 250,
                          child: LineChart(
                            LineChartData(
                                minY: 0,
                                maxY: 100,
                                gridData: FlGridData(
                                  show: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Color(0xff482384),
                                      strokeWidth: 1,
                                    );
                                  },
                                  drawVerticalLine: true,
                                  drawHorizontalLine: true,
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Color(0xff482384),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                borderData: FlBorderData (
                                  show: true,
                                  border: Border.all(color: Color(0xff482384), width: 1),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: Text('          Most Recent Quizes',style: TextStyle(color: Colors.grey,fontSize: h*12) ,),
                                    axisNameSize: 20,
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      reservedSize: 20,
                                    ),
                                  ),
                                  leftTitles:AxisTitles(
                                    axisNameWidget: Text('             % Performance',style: TextStyle(color: Colors.grey,fontSize: h*12),),
                                    axisNameSize: 20,
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 20,
                                      reservedSize:30,
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      if(_allQuizScoreLength > 7)
                                        for(int i = 0; i<7; i++)
                                          FlSpot(i+1.toDouble(), double.parse(_getDashboardStatsSuccessful.data.allQuizScores[_allQuizScoreLength - 1 - i].score.toStringAsFixed(2))),
                                      if(_allQuizScoreLength <= 7)
                                        for(int i = 0; i<_allQuizScoreLength; i++)
                                          FlSpot(i+1.toDouble(), double.parse(_getDashboardStatsSuccessful.data.allQuizScores[_allQuizScoreLength - 1 - i].score.toStringAsFixed(2))),
                                    ],
                                    isCurved: true,
                                    color: Color(0xff482384),
                                    barWidth: 4,
                                    // dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            Colors.white.withOpacity(0.7),
                                            Colors.white.withOpacity(0.1),
                                          ]),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h*28,),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(h*19),
                child: Text('Recent Top 3 Quizzes',style: TextStyle( color: Color(0xFFFAFAFA).withOpacity(0.8),
                    fontFamily: 'Brandon-bld',
                    fontSize: h * 20),)

              ),
              Container(
      height: h*60,
      width:w*382,
      padding: EdgeInsets.all(h*5),
      decoration: BoxDecoration(borderRadius:BorderRadius.circular(h*5),gradient: LinearGradient(colors: [Color(0xff7F1AF1),Color(0xff482384)],begin: Alignment.topCenter,end: Alignment.bottomCenter ),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: EdgeInsets.all(h*10),
                  child: Icon(Icons.event_note_rounded,color: Colors.white,size: h*25,),
                ),
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                  Text('Microbiology',style: TextStyle( color: Color(0xFFFAFAFA).withOpacity(0.6),
                      fontFamily: 'Brandon-med',
                      fontSize: h * 16),),
                  Text('You have successfully completed this quiz',style: TextStyle( color: Color(0xFFFAFAFA).withOpacity(0.8),
                      fontFamily: 'Brandon-med',
                      fontSize: h * 13),)
                ],),
                Container(margin:EdgeInsets.all(h*5),
                  decoration: const BoxDecoration(
                    color:Colors.transparent,
                  ),
                  height: h*50,
                  width: h*50,

                  child: Stack(children: [Center(child: SizedBox(height: h*40,width: h*40,
                      child: CircularProgressIndicator(value: performance,color: Colors.white,backgroundColor:Colors.grey.withOpacity(0.2),strokeWidth: 2,))),
                    Center(child: Text((performance*100).toStringAsFixed(1).toString()+ ' %',style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Brandon-med',
                      fontSize:h*10,
                    ),))],),),
              ],),
              ),
              SizedBox(height: h*20,),
              Container(
                height: h*60,
                width:w*382,
                padding: EdgeInsets.all(h*5),
                decoration: BoxDecoration(borderRadius:BorderRadius.circular(h*5),gradient: LinearGradient(colors: [Color(0xff7F1AF1),Color(0xff482384)],begin: Alignment.topCenter,end: Alignment.bottomCenter ),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(h*10),
                      child: Icon(Icons.event_note_rounded,color: Colors.white,size: h*25,),
                    ),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text('Microbiology',style: TextStyle( color: Color(0xFFFAFAFA).withOpacity(0.6),
                            fontFamily: 'Brandon-med',
                            fontSize: h * 16),),
                        Text('You have successfully completed this quiz',style: TextStyle( color: Color(0xFFFAFAFA).withOpacity(0.8),
                            fontFamily: 'Brandon-med',
                            fontSize: h * 13),)
                      ],),
                    Container(margin:EdgeInsets.all(h*5),
                      decoration: const BoxDecoration(
                        color:Colors.transparent,
                      ),
                      height: h*50,
                      width: h*50,

                      child: Stack(children: [Center(child: SizedBox(height: h*40,width: h*40,
                          child: CircularProgressIndicator(value: performance,color: Colors.white,backgroundColor:Colors.grey.withOpacity(0.2),strokeWidth: 2,))),
                        Center(child: Text((performance*100).toStringAsFixed(1).toString()+ ' %',style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Brandon-med',
                          fontSize:h*10,
                        ),))],),),
                  ],),
              ),
              SizedBox(height: h*20,),
              Container(
                height: h*60,
                width:w*382,
                padding: EdgeInsets.all(h*5),
                decoration: BoxDecoration(borderRadius:BorderRadius.circular(h*5),gradient: LinearGradient(colors: [Color(0xff7F1AF1),Color(0xff482384)],begin: Alignment.topCenter,end: Alignment.bottomCenter ),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(h*10),
                      child: Icon(Icons.event_note_rounded,color: Colors.white,size: h*25,),
                    ),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text('Microbiology',style: TextStyle( color: Color(0xFFFAFAFA).withOpacity(0.6),
                            fontFamily: 'Brandon-med',
                            fontSize: h * 16),),
                        Text('You have successfully completed this quiz',style: TextStyle( color: Color(0xFFFAFAFA).withOpacity(0.8),
                            fontFamily: 'Brandon-med',
                            fontSize: h * 13),)
                      ],),
                    Container(margin:EdgeInsets.all(h*5),
                      decoration: const BoxDecoration(
                        color:Colors.transparent,
                      ),
                      height: h*50,
                      width: h*50,

                      child: Stack(children: [Center(child: SizedBox(height: h*40,width: h*40,
                          child: CircularProgressIndicator(value: performance,color: Colors.white,backgroundColor:Colors.grey.withOpacity(0.2),strokeWidth: 2,))),
                        Center(child: Text((performance*100).toStringAsFixed(1).toString()+ ' %',style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Brandon-med',
                          fontSize:h*10,
                        ),))],),),
                  ],),
              ),
              SizedBox(height: h*80,),
            ],

          ),
        ),

      ),
    );
  }
}
