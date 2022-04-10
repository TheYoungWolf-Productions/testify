import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:testify/screens/Welcome/side_menu_bar.dart';

class QuestionExplanation extends StatefulWidget {
  const QuestionExplanation({Key? key, required this.questionId, required this.question, required this.correctAnswer, required this.explanation}) : super(key: key);

  final int questionId;
  final String question;
  final String correctAnswer;
  final String explanation;

  @override
  State<QuestionExplanation> createState() => _QuestionExplanationState();
}

class _QuestionExplanationState extends State<QuestionExplanation> {
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  void onEnd() {
    print('onEnd');
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.questionId);
    // print(widget.question);
    // print(widget.correctAnswer);
    // print(widget.explanation);
    return Scaffold(
      backgroundColor: Color(0xffF8F9FB),
      drawer: SideMenuBar(),
      // drawer: moreMenu(),
      appBar: AppBar(
        toolbarHeight: (MediaQuery.of(context).size.height) * (73.52 / 926),
        backgroundColor: Color(0xff3F2668),
        elevation: 2,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ',
              style: TextStyle(
                color: Color(0xffffffff),
                fontFamily: 'Brandon-bld',
                fontSize: (MediaQuery.of(context).size.height) * (20 / 926),
              ),
            ),
          ],
        ),
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
             },
            child: SvgPicture.asset(
              "assets/Images/logout.svg",
              height: (MediaQuery.of(context).size.height) *(32/926),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: ((MediaQuery.of(context).size.height) * ((926-73.52-50.88-(MediaQuery.of(context).padding.top)-8.1) / 926)),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                    padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height) * (15 / 926),
                        bottom: (MediaQuery.of(context).size.height) * (8 / 926),
                        left: (MediaQuery.of(context).size.width) * (18 / 428),
                        right: (MediaQuery.of(context).size.width) * (18 / 428)),
                    child: Column(
                      children: <Widget>[
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
                                      "Attempt Your Quiz",
                                      style: TextStyle(
                                        color: Color(0xff232323),
                                        fontFamily: 'Brandon-bld',
                                        fontSize: (MediaQuery.of(context).size.height) *
                                            (20 / 926), //38,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: (MediaQuery.of(context).size.height) *
                                        (2 / 926),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Question ID: " + widget.questionId.toString(), // questionNumber
                                      style: TextStyle(
                                        color: Color(0xFF7F1AF1),
                                        fontFamily: 'Brandon-med',
                                        fontSize: (MediaQuery.of(context).size.height) *
                                            (13 / 926), //38,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width) * (39 / 428),
                            ),
                            // for timer
                            Container(
                              height: (MediaQuery.of(context).size.height) * (25 / 926),
                              width: (MediaQuery.of(context).size.width) * (107 / 428),
                              color: Color(0xFF3F2668),
                              child: Row(
                                children: [
                                  Text('  Time Left  ',
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontFamily: 'Brandon-med',
                                        fontSize: (MediaQuery.of(context).size.height) *
                                            (7 / 926),
                                      )),
                                  CountdownTimer(
                                    textStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontFamily: 'Brandon-med',
                                      fontSize: (MediaQuery.of(context).size.height) *
                                          (13 / 926),
                                    ),
                                    endTime: endTime,
                                    onEnd: onEnd,
                                    endWidget: Text(
                                      "00 : 00 : 00",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontFamily: 'Brandon-med',
                                        fontSize: (MediaQuery.of(context).size.height) *
                                            (13 / 926),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) * (35.47 / 926),
                        ),
                        Text(
                          widget.question,
                          style: TextStyle(
                            color: Color(0xFF483A3A),
                            fontFamily: 'Brandon-med',
                            fontSize:
                            (MediaQuery.of(context).size.height) * (18 / 926), //38,
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) * (25 / 926),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Correct Answer: ", // questionNumber
                            style: TextStyle(
                              color: Color(0xFF7F1AF1),
                              fontFamily: 'Brandon-med',
                              fontSize: (MediaQuery.of(context).size.height) *
                                  (13 / 926), //38,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) * (10.75 / 926),
                        ),
                        Container(
                          // height: (MediaQuery.of(context).size.height) * (50 / 926),
                            // width: (MediaQuery.of(context).size.width) * (385 / 428),
                            padding: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height) * (8 / 928),
                              left: (MediaQuery.of(context).size.width) * (13 / 428),
                              bottom: (MediaQuery.of(context).size.height) * (8 / 928),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFF3F2668),
                                border: Border.all(
                                  color: Color(0xFF3F2668),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(0))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width) * (300 / 428),
                                  child: Text(widget.correctAnswer,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Brandon-med',
                                        fontSize: (MediaQuery.of(context).size.height) *
                                            (18 / 926), //38,
                                      )),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) * (20.2 / 926),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Explanation: ", // questionNumber
                            style: TextStyle(
                              color: Color(0xFF7F1AF1),
                              fontFamily: 'Brandon-med',
                              fontSize: (MediaQuery.of(context).size.height) *
                                  (13 / 926), //38,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) * (10.75 / 926),
                        ),
                        Text(
                          widget.explanation,
                          style: TextStyle(
                            color: Color(0xFF483A3A),
                            fontFamily: 'Brandon-med',
                            fontSize:
                            (MediaQuery.of(context).size.height) * (18 / 926), //38,
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) * (20.75 / 926),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.arrow_back,
                                  color: Color(0xFF7F1AF1),
                                size: (MediaQuery.of(context).size.height) *
                                    (15 / 926),),
                              ),
                              SizedBox(width: (MediaQuery.of(context).size.width) *
                                  (3 / 428),),
                              Text(
                                "Back to Question", // questionNumber
                                style: TextStyle(
                                  color: Color(0xFF7F1AF1),
                                  fontFamily: 'Brandon-med',
                                  fontSize: (MediaQuery.of(context).size.height) *
                                      (13 / 926), //38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ) ,
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ((MediaQuery.of(context).size.height) * (51 / 926)),
              color: Colors.grey,
              // decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: <Color>[Color(0xff7F1AF1), Color(0xff482384)])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,),
                    child: Row(
                      children: [
                        SizedBox(width: (MediaQuery.of(context).size.width) * (16 / 428)),
                        Container(
                          child: Icon(Icons.arrow_back_ios_outlined,
                            color: Color(0xFFE4E4E4),
                            size: ((MediaQuery.of(context).size.width) * (23.1 / 428)),),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,),
                    child: Row(
                      children: [
                        Container(
                          width: ((MediaQuery.of(context).size.height) * (15 / 926)),
                          decoration: BoxDecoration(
                              color: Color(0xFFE4E4E4),
                              shape: BoxShape.circle
                          ),
                        ),
                        SizedBox(width: (MediaQuery.of(context).size.width) * (6 / 428)),
                        Container(
                          width: ((MediaQuery.of(context).size.height) * (15 / 926)),
                          decoration: BoxDecoration(
                              color: Color(0xFFE4E4E4),
                              shape: BoxShape.circle
                          ),
                        ),
                        SizedBox(width: (MediaQuery.of(context).size.width) * (6 / 428)),
                        Container(
                          width: ((MediaQuery.of(context).size.height) * (15 / 926)),
                          decoration: BoxDecoration(
                              color: Color(0xFFE4E4E4),
                              shape: BoxShape.circle
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(Icons.arrow_forward_ios_outlined,
                            color: Color(0xFFE4E4E4),
                            size: ((MediaQuery.of(context).size.width) * (23.1 / 428)),),
                        ),
                        SizedBox(width: (MediaQuery.of(context).size.width) * (16 / 428)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
