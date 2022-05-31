import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/screens/Components/styles.dart';

import '../../../../models/resultDetails/result_details_model.dart';


class DetailsTile extends StatelessWidget {
  //same code as quiz details renamed getQuizAnalysis to getResultDetails
  final int index;
  final int id;
  final String subject;
  final String system;
  final String topic;
  final int peerAvg;
  final String status;
  const DetailsTile({required this.id, required this.subject, required this.system, required this.topic, required this.peerAvg, required this.status, required this.index});
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(child: Column(children: [
      Expandable(
          collapsed: ExpandableButton(
            child: Container(
              height: MediaQuery.of(context).size.height * (55 / 926),
              width: MediaQuery.of(context).size.width * (363 / 428),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey,width: 0.2),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 7 / 926)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * (5 / 926),
                        horizontal:
                        (MediaQuery.of(context).size.width) * (15 / 428)),
                    child: Text(
                      id.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Styles.lightPurple,
                        fontFamily: 'Brandon-med',
                        fontSize: (MediaQuery.of(context).size.height) * (16/ 926),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * (10/ 926),
                          horizontal:
                          (MediaQuery.of(context).size.width) * (10 / 428)),
                      child: Text(
                        index == 0 ? subject : (index == 1 ? system : topic),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Styles.darkGrey,
                          fontFamily: 'Brandon-med',
                          fontSize:
                          (MediaQuery.of(context).size.height) * (18 / 926),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * (10/ 926),
                        horizontal:
                        (MediaQuery.of(context).size.width) * (10/ 428)),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: MediaQuery.of(context).size.height * (35 / 926),
                      color:Styles.lightPurple,
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
                  height: MediaQuery.of(context).size.height * (55 / 926),
                  width: MediaQuery.of(context).size.width * (363 / 428),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey,width: 0.2),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 7 / 926)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * (5 / 926),
                            horizontal:
                            (MediaQuery.of(context).size.width) * (15 / 428)),
                        child: Text(
                          id.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Styles.lightPurple,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (16/ 926),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * (10/ 926),
                              horizontal:
                              (MediaQuery.of(context).size.width) * (10 / 428)),
                          child: Text(
                            index == 0 ? subject : (index == 1 ? system : topic),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Styles.darkGrey,
                              fontFamily: 'Brandon-med',
                              fontSize:
                              (MediaQuery.of(context).size.height) * (18 / 926),
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * (10/ 926),
                            horizontal:
                            (MediaQuery.of(context).size.width) * (10/ 428)),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: MediaQuery.of(context).size.height * (35 / 926),
                          color:Styles.lightPurple,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * (110 / 926),
                  width: MediaQuery.of(context).size.width * (363 / 428),
                  color: Colors.grey.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * (5 / 926),
                      horizontal: (MediaQuery.of(context).size.width) * (7 / 428)),

                  child: GridView(
                      padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  mainAxisExtent: 45),
                      children:[
                        Column(children: [Text(index == 0 ? 'System:' : (index == 1 ? 'Subject:' : 'Subject:'),
                          style: TextStyle(
                            color: Styles.lightPurple ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),),
                          Text(index == 0 ? system : (index == 1 ? subject : subject),style: TextStyle(
                            color: Colors.grey ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),),],),
                        Column(children: [ Text(index == 0 ? 'Topic:' : (index == 1 ? 'Topic:' : 'System:'), style: TextStyle(
                          color: Styles.lightPurple ,
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                        ),),
                          Text(index == 0 ? topic : (index == 1 ? topic : system),style: TextStyle(
                            color: Colors.grey ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),),],)
                       , Column(children: [
                          Text('Peer average:', style: TextStyle(
                            color:Styles.lightPurple  ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),),
                          Text(peerAvg.toString()+' % ',style: TextStyle(
                            color: Colors.grey ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),),],)
                       ,Column(children: [      Text('Status:', style: TextStyle(
                          color:Styles.lightPurple  ,
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                        ),),
                          Text(status,style: TextStyle(
                            color: Colors.grey ,
                            fontFamily: 'Brandon-med',
                            fontSize: (MediaQuery.of(context).size.height) * (17 / 926),
                          ),)],)

                      ]),
                )
              ],
            ),
          ))
    ],));
  }

}

class ResultDetails extends StatefulWidget {
  @override
  _ResultDetailsState createState() => _ResultDetailsState();
}

class _ResultDetailsState extends State<ResultDetails> {
  //same code as quiz details renamed getQuizAnalysis to getResultDetails
  var _getResultDetails;

  @override
  void initState() {
    super.initState();
    getResultDetails();
  }

  getResultDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? responseString = prefs.getString("getResultDetailsAPI");
    var getResultDetails1 = resultDetailsModelFromJson(responseString!);
    final ResultDetailsModel getResultDetails = getResultDetails1;
    setState(() {
      _getResultDetails = getResultDetails;
      // print(_getResultDetails.data.subjects.length);
    });
  }


  int index = 0; //0=subjects,1=systems,2=topics
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height/926;
    var w=MediaQuery.of(context).size.width/428;
    return SingleChildScrollView(
        padding: EdgeInsets.all(h*20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top,),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left:w*10),
            child: Text(
            "Result Details",
            style: TextStyle(
            color: Styles.darkGrey,
            fontFamily: 'Brandon-bld',
            fontSize: h * 30),
            ),
            ),
            SizedBox(width: w*140,),
            Align(
            alignment: Alignment.topRight,
            child: IconButton(
            icon: Icon(Icons.close),
            iconSize: 25,
            color: Styles.lightPurple,
            onPressed: () {
            Navigator.of(context).pop();
            },
            ),
            ),
            SizedBox(height:h*20),
            ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              buttonHeight:h*25,
              children: [
                TextButton(
                  style: const ButtonStyle(
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
                        index == 0 ? Styles.lightPurple: Styles.darkGrey,
                        fontFamily: 'Brandon-med',
                        fontSize: h*22
                    ),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(
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
                        index == 1 ? Styles.lightPurple: Styles.darkGrey,
                        fontFamily: 'Brandon-med',
                        fontSize: h*22
                    ),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(
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
                        index == 2 ? Styles.lightPurple: Styles.darkGrey,
                        fontFamily: 'Brandon-med',
                        fontSize: h*22
                    ),
                  ),
                ),
              ],
            ),
            _getResultDetails == null ? const Center(child: CircularProgressIndicator(color: Color(0xff482384),)) : Column(
              children: [
                const Divider(),
                if(index == 0)
                  for(int i = 0; i<_getResultDetails.data.quizResults.length; i++)
                    if(_getResultDetails.data.quizResults[i].subject != null)
                      Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (20 / 926),
                        ),
                        DetailsTile(
                          id: _getResultDetails.data.quizResults[i].questionId,
                          subject: _getResultDetails.data.quizResults[i].subject ?? "None",
                          system: _getResultDetails.data.quizResults[i].system ?? "None",
                          topic: _getResultDetails.data.quizResults[i].topic ?? "None",
                          peerAvg: _getResultDetails.data.quizResults[i].averageCorrectToOthers,
                          status: _getResultDetails.data.quizResults[i].status == -1 ? "Omitted" : (_getResultDetails.data.quizResults[i].status == 0 ? "Incorrect" : "Correct"),
                          index: 0,
                        ),
                      ],
                    ),
                if(index == 1)
                  for(int i = 0; i<_getResultDetails.data.quizResults.length; i++)
                    if(_getResultDetails.data.quizResults[i].system != null)
                      Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (20 / 926),
                        ),
                        DetailsTile(
                          id: _getResultDetails.data.quizResults[i].questionId,
                          subject: _getResultDetails.data.quizResults[i].subject ?? "None",
                          system: _getResultDetails.data.quizResults[i].system ?? "None",
                          topic: _getResultDetails.data.quizResults[i].topic ?? "None",
                          peerAvg: _getResultDetails.data.quizResults[i].averageCorrectToOthers,
                          status: _getResultDetails.data.quizResults[i].status == -1 ? "Omitted" : (_getResultDetails.data.quizResults[i].status == 0 ? "Incorrect" : "Correct"),
                          index: 1,
                        ),
                      ],
                    ),
                if(index == 2)
                  for(int i = 0; i<_getResultDetails.data.quizResults.length; i++)
                    if(_getResultDetails.data.quizResults[i].topic != null)
                      Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (20 / 926),
                        ),
                        DetailsTile(
                          id: _getResultDetails.data.quizResults[i].questionId,
                          subject: _getResultDetails.data.quizResults[i].subject ?? "None",
                          system: _getResultDetails.data.quizResults[i].system ?? "None",
                          topic: _getResultDetails.data.quizResults[i].topic ?? "None",
                          peerAvg: _getResultDetails.data.quizResults[i].averageCorrectToOthers,
                          status: _getResultDetails.data.quizResults[i].status == -1 ? "Omitted" : (_getResultDetails.data.quizResults[i].status == 0 ? "Incorrect" : "Correct"),
                          index: 2,
                        ),
                      ],
                    ),
              ],
            )
          ],
        ));
  }
}
