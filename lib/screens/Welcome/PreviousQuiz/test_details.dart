import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Authentication/login.dart';
import '../side_menu_bar.dart';

class TestDetails extends StatelessWidget {
  final int quizId;
  final List<dynamic> system;
  final List<dynamic> subject;
  final List<dynamic> topic;
  final String status;
  final String score;
  TestDetails(
      {required this.quizId,
        required this.system,
        required this.subject,
        required this.topic,
        required this.status,
        required this.score});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text(
          "Test Details",
          style: TextStyle(
            color: Color(0xffFFFEFE),
            fontFamily: 'Brandon-bld',
          ),
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
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: (MediaQuery.of(context).size.height) * (488 / 926),
                    width: (MediaQuery.of(context).size.width) * (385 / 428),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, offset: Offset(0, 4), blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      children: [

                        Container(
                          height: (MediaQuery.of(context).size.height) * (59 / 926),
                          width: (MediaQuery.of(context).size.width) * (385 / 428),
                          color: Color(0xff6D5A8D),
                          child: Center(
                            child: Text(
                              'Test Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brandon-bld',
                                fontSize: (MediaQuery.of(context).size.height) * (20 / 926),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: (MediaQuery.of(context).size.height) * (310 / 926),
                          width: (MediaQuery.of(context).size.width) * (385 / 428),
                          padding: EdgeInsets.all(25),
                          child: Table(
                            columnWidths: {0:FixedColumnWidth((MediaQuery.of(context).size.width) * (25 / 428)),
                            1:FixedColumnWidth((MediaQuery.of(context).size.width) * (200 / 428))},
                            border: TableBorder.all(color: Colors.transparent),
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quiz ID:',
                                        style: TextStyle(
                                          color: Color(0xff3F2668),
                                          fontFamily: 'Brandon-bld',
                                          fontSize: (MediaQuery.of(context).size.height) *
                                              (16 / 926),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(quizId.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Brandon-med',
                                            fontSize: (MediaQuery.of(context).size.height) *
                                                (16 / 926),
                                          ))
                                    ],
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'System:',
                                        style: TextStyle(
                                          color: Color(0xff3F2668),
                                          fontFamily: 'Brandon-bld',
                                          fontSize: (MediaQuery.of(context).size.height) *
                                              (16 / 926),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(system.toString().substring(1, system.toString().length-1) == "" ? "-" : system.toString().substring(1, system.toString().length-1),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Brandon-med',
                                            fontSize: (MediaQuery.of(context).size.height) *
                                                (16 / 926),
                                          ))
                                    ],
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Subject:',
                                        style: TextStyle(
                                          color: Color(0xff3F2668),
                                          fontFamily: 'Brandon-bld',
                                          fontSize: (MediaQuery.of(context).size.height) *
                                              (16 / 926),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(subject.toString().substring(1, subject.toString().length-1) == "" ? "-" : subject.toString().substring(1, subject.toString().length-1),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Brandon-med',
                                            fontSize: (MediaQuery.of(context).size.height) *
                                                (16 / 926),
                                          ))
                                    ],
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Topic:',
                                        style: TextStyle(
                                          color: Color(0xff3F2668),
                                          fontFamily: 'Brandon-bld',
                                          fontSize: (MediaQuery.of(context).size.height) *
                                              (16 / 926),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(topic.toString().substring(1, topic.toString().length-1) == "" ? "-" : topic.toString().substring(1, topic.toString().length-1),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Brandon-med',
                                            fontSize: (MediaQuery.of(context).size.height) *
                                                (16 / 926),
                                          ))
                                    ],
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Score:',
                                        style: TextStyle(
                                          color: Color(0xff3F2668),
                                          fontFamily: 'Brandon-bld',
                                          fontSize: (MediaQuery.of(context).size.height) *
                                              (16 / 926),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(score,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Brandon-med',
                                            fontSize: (MediaQuery.of(context).size.height) *
                                                (16 / 926),
                                          ))
                                    ],
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status:',
                                        style: TextStyle(
                                          color: Color(0xff3F2668),
                                          fontFamily: 'Brandon-bld',
                                          fontSize: (MediaQuery.of(context).size.height) *
                                              (16 / 926),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(status,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Brandon-med',
                                            fontSize: (MediaQuery.of(context).size.height) *
                                                (16 / 926),
                                          ))
                                    ],
                                  ),
                                )
                              ])
                            ],
                          ),
                        ),

                        Container(
                          height: (MediaQuery.of(context).size.height) * (70 / 926),
                          width: (MediaQuery.of(context).size.width) * (385 / 428),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                 Container(height:40,width:40,decoration: BoxDecoration(color: Color(0xff7F1AF1),borderRadius: BorderRadius.circular(20)),
                                     child: Icon(Icons.show_chart_outlined,size: 20,color:Colors.white))
                                ,Text('Test Analysis',style: TextStyle(
                                    color: Color(0xff7F1AF1),
                                    fontFamily: 'Brandon-med',
                                    fontSize: (MediaQuery.of(context).size.height) * (15 / 926),
                                  ),)
                                ],
                              ),
                              Column(
                                children: [
                                  Container(height:40,width:40,decoration: BoxDecoration(color: Color(0xff7F1AF1),borderRadius: BorderRadius.circular(20)),
                                      child: Icon(Icons.event_note_outlined,size: 20,color:Colors.white))
                                  ,Text('Test Results',style: TextStyle(
                                    color: Color(0xff7F1AF1),
                                    fontFamily: 'Brandon-med',
                                    fontSize: (MediaQuery.of(context).size.height) * (15 / 926),
                                  ),)
                                ],
                              ),
                              Column(
                                children: [
                                  Container(height:40,width:40,decoration: BoxDecoration(color: Color(0xff7F1AF1),borderRadius: BorderRadius.circular(20)),
                                      child: Icon(Icons.arrow_right,size: 40,color:Colors.white))
                                  ,Text('Resume',style: TextStyle(
                                    color: Color(0xff7F1AF1),
                                    fontFamily: 'Brandon-med',
                                    fontSize: (MediaQuery.of(context).size.height) * (15 / 926),
                                  ),)
                                ],
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                      onTap:(){
                        Navigator.of(context).pop();
                      },
                      child:Container(
                    child: Row(
                      children: [Icon(Icons.arrow_back,color: Color(0xff7F1AF1),size: 15,),Text('Back',style: TextStyle(
                        color: Color(0xff7F1AF1),
                        fontFamily: 'Brandon-bld',
                        fontSize: (MediaQuery.of(context).size.height) *
                      (13 / 926),
                      ),)],

                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      );

  }
}
