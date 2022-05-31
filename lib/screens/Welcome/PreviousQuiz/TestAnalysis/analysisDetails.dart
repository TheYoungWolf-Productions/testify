import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:expandable/expandable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/models/GetPreviousQuizzesModel/TestAnalysisModel/test_analysis_model.dart';

import '../../../Authentication/login.dart';
import '../../side_menu_bar.dart';

class DetailsTile extends StatelessWidget {
  final int id;
  final String name;
  final int totalQuestions;
  final int correctQuestions;
  final int incorrectQuestions;
  final int omittedQuestions;
  DetailsTile({required this.id, required this.name, required this.totalQuestions, required this.correctQuestions, required this.incorrectQuestions, required this.omittedQuestions});
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(child: Column(children: [
      Expandable(
          collapsed: ExpandableButton(
            child: Container(
              height: MediaQuery.of(context).size.height * (78 / 926),
              width: MediaQuery.of(context).size.width * (363 / 428),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xff8B8B8B)),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 6,
                        color: Colors.grey // background color
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 5 / 926)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * (78 / 926),
                    width: MediaQuery.of(context).size.height * (78 / 926),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * (12 / 926),
                        horizontal:
                        (MediaQuery.of(context).size.width) * (5 / 428)),
                    color: Color(0xff6D5A8D),
                    child: Text(
                      'Sr.No\n' + id.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffFFFEFE),
                        fontFamily: 'Brandon-med',
                        fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * (12 / 926),
                          horizontal:
                          (MediaQuery.of(context).size.width) * (12 / 428)),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff8B8B8B),
                          fontFamily: 'Brandon-med',
                          fontSize:
                          (MediaQuery.of(context).size.height) * (21 / 926),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * (12 / 926),
                        horizontal:
                        (MediaQuery.of(context).size.width) * (12 / 428)),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: MediaQuery.of(context).size.height * (35 / 926),
                      color: Color(0xff6D5A8D),
                    ),
                  )
                ],
              ),
            ),
          ),
          expanded: ExpandableButton(
            child:Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * (78 / 926),
                  width: MediaQuery.of(context).size.width * (363 / 428),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color:Color(0xff8B8B8B)),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 6,
                            color: Colors.grey // background color
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 5 / 926)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * (78 / 926),
                        width: MediaQuery.of(context).size.height * (78 / 926),
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * (12 / 926),
                            horizontal:
                            (MediaQuery.of(context).size.width) * (5 / 428)),
                        color: Color(0xff6D5A8D),
                        child: Text(
                          'Sr.No\n' + id.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffFFFEFE),
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * (12 / 926),
                              horizontal:
                              (MediaQuery.of(context).size.width) * (12 / 428)),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff8B8B8B),
                              fontFamily: 'Brandon-med',
                              fontSize:
                              (MediaQuery.of(context).size.height) * (21 / 926),
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * (12 / 926),
                            horizontal:
                            (MediaQuery.of(context).size.width) * (12 / 428)),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: MediaQuery.of(context).size.height * (35 / 926),
                          color: Color(0xff6D5A8D),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * (78 / 926),
                  width: MediaQuery.of(context).size.width * (363 / 428),
                  color: Color(0xA4E4E4E4),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * (10 / 926),
                      horizontal: (MediaQuery.of(context).size.width) * (10 / 428)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Text('Total Questions:    ', style: TextStyle(
                          color: Color(0xFF3F2668) ,
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                        ),),
                        SizedBox(width:MediaQuery.of(context).size.width * (10 / 428)),
                        Text(totalQuestions.toString(),style: TextStyle(
                          color: Colors.grey ,
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                        ),)
                      ],),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Correct Questions: ', style: TextStyle(
                            color: Color(0xFF3F2668) ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),),
                          SizedBox(width:MediaQuery.of(context).size.width * (10 / 428)),
                          Text(correctQuestions.toString(),style: TextStyle(
                            color: Colors.grey ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),)
                        ],),],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [  Row(children: [
                        Text('Incorrect Questions: ', style: TextStyle(
                          color: Color(0xFF3F2668) ,
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                        ),),
                        SizedBox(width:MediaQuery.of(context).size.width * (10 / 428)),
                        Text(incorrectQuestions.toString(),style: TextStyle(
                          color: Colors.grey ,
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                        ),)
                      ],),
                        Row(children: [
                          Text('Omitted Questions: ', style: TextStyle(
                            color: Color(0xFF3F2668) ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),),
                          SizedBox(width:MediaQuery.of(context).size.width * (10 / 428)),
                          Text(omittedQuestions.toString(),style: TextStyle(
                            color: Colors.grey ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),)
                        ],),],)


                    ],
                  ),
                )
              ],
            ),
          ))
    ],));
  }


 // }
}

class AnalysisDetails extends StatefulWidget {
  @override
  _AnalysisDetailsState createState() => _AnalysisDetailsState();
}

class _AnalysisDetailsState extends State<AnalysisDetails> {
  var _getQuizAnalysis;

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
      print(_getQuizAnalysis.data.subjects.length);
    });
  }

  int index = 0; //0=subjects,1=systems,2=topics
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * (20 / 926),
            horizontal: (MediaQuery.of(context).size.width) * (20 / 428)),
        child: Column(
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              buttonHeight: MediaQuery.of(context).size.height * (26 / 926),
              children: [
                TextButton(
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: Text(
                    'Subjects',
                    style: TextStyle(
                      color:
                      index == 0 ? Color(0xFF3F2668) : Color(0xff7F1AF1),
                      fontFamily: 'Brandon-med',
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {
                    setState(() {
                      index = 1;
                    });
                  },
                  child: Text(
                    'Systems',
                    style: TextStyle(
                      color:
                      index == 1 ? Color(0xFF3F2668) : Color(0xff7F1AF1),
                      fontFamily: 'Brandon-med',
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {
                    setState(() {
                      index = 2;
                    });
                  },
                  child: Text(
                    'Topics',
                    style: TextStyle(
                      color:
                      index == 2 ? Color(0xFF3F2668) : Color(0xff7F1AF1),
                      fontFamily: 'Brandon-med',
                    ),
                  ),
                ),
              ],
            ),
            _getQuizAnalysis == null ? Center(child: CircularProgressIndicator(color: Color(0xff482384),)) : Column(
              children: [
                Divider(),
                if(index == 0)
                  for(int i = 0; i<_getQuizAnalysis.data.subjects.length; i++)
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (20 / 926),
                        ),
                        DetailsTile(
                          id: _getQuizAnalysis.data.subjects[i].srNo,
                          name: _getQuizAnalysis.data.subjects[i].category.toString(),
                          totalQuestions: _getQuizAnalysis.data.subjects[i].totalQuestions,
                          omittedQuestions: _getQuizAnalysis.data.subjects[i].omittedQuestions,
                          incorrectQuestions: _getQuizAnalysis.data.subjects[i].incorrectQuestions,
                          correctQuestions: _getQuizAnalysis.data.subjects[i].correctQuestions,
                        ),
                      ],
                    ),
                if(index == 1)
                  for(int i = 0; i<_getQuizAnalysis.data.systems.length; i++)
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (20 / 926),
                        ),
                        DetailsTile(
                          id: _getQuizAnalysis.data.systems[i].srNo,
                          name: _getQuizAnalysis.data.systems[i].category.toString(),
                          totalQuestions: _getQuizAnalysis.data.systems[i].totalQuestions,
                          omittedQuestions: _getQuizAnalysis.data.systems[i].omittedQuestions,
                          incorrectQuestions: _getQuizAnalysis.data.systems[i].incorrectQuestions,
                          correctQuestions: _getQuizAnalysis.data.systems[i].correctQuestions,
                        ),
                      ],
                    ),
                if(index == 2)
                  for(int i = 0; i<_getQuizAnalysis.data.topics.length; i++)
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (20 / 926),
                        ),
                        DetailsTile(
                          id: _getQuizAnalysis.data.topics[i].srNo,
                          name: _getQuizAnalysis.data.topics[i].category.toString(),
                          totalQuestions: _getQuizAnalysis.data.topics[i].totalQuestions,
                          omittedQuestions: _getQuizAnalysis.data.topics[i].omittedQuestions,
                          incorrectQuestions: _getQuizAnalysis.data.topics[i].incorrectQuestions,
                          correctQuestions: _getQuizAnalysis.data.topics[i].correctQuestions,
                        ),
                      ],
                    ),
              ],
            )
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * (20 / 926),
            // ),
            // DetailsTile(id: 1234, name: "Subject 2"),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * (20 / 926),
            // ),
            // DetailsTile(id: 1234, name: "Subject 3"),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * (20 / 926),
            // ),
            // DetailsTile(id: 1234, name: "Subject 4"),
          ],
        ));
  }
}
