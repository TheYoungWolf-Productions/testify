import 'package:flutter/material.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/test_details.dart';

class Tile extends StatelessWidget {
  final String name;
  final int quizId;
  final String status;
  final String score;
  final String date;
  final List<dynamic> questions;
  final String totalQuestions;
  final List<dynamic> subjects;
  final List<dynamic> systems;
  final List<dynamic> topics;
  Tile({required this.name, required this.quizId, required this.status, required this.score, required this.totalQuestions, required this.questions, required this.date, required this.subjects, required this.systems, required this.topics});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) * (84 / 926),
      width: (MediaQuery.of(context).size.width) * (385 / 428),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(0, 4), blurRadius: 6)
        ],
      ),
      child: Row(
        children: [
          Container(
              height: (MediaQuery.of(context).size.height) * (84 / 926),
              width: (MediaQuery.of(context).size.width) * (87 / 428),
              color: Color(0xff6D5A8D),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quiz ID',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Brandon-bld',
                      fontSize:
                          (MediaQuery.of(context).size.height) * (18 / 926),
                    ),
                  ),
                  Text(quizId.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Brandon-med',
                        fontSize:
                            (MediaQuery.of(context).size.height) * (17 / 926),
                      ))
                ],
              )),
          Container(
            height: (MediaQuery.of(context).size.height) * (84 / 926),
            width: (MediaQuery.of(context).size.width) * (248 / 428),
            color: Colors.white,
            padding: EdgeInsets.all(
                (MediaQuery.of(context).size.height) * (16 / 926)),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sticky_note_2_rounded,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width) * (12 / 428),
                    ),
                    Text(
                      (name.length >= 17) ? name.substring(0, 17) : name,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Brandon-med',
                        fontSize:
                            (MediaQuery.of(context).size.height) * (18 / 926),
                      ),
                    )
                  ],
                ),
                Divider(
                  height: 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      score + ' / ' + totalQuestions,
                      style: TextStyle(
                        color: Color(0xff6C63FF),
                        fontFamily: 'Brandon-med',
                        fontSize:
                            (MediaQuery.of(context).size.height) * (14 / 926),
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        color: Color(0xff6C63FF),
                        fontFamily: 'Brandon-med',
                        fontSize:
                            (MediaQuery.of(context).size.height) * (14 / 926),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
              height: (MediaQuery.of(context).size.height) * (84 / 926),
              width: (MediaQuery.of(context).size.width) * (50 / 428),
              color: Colors.white,
              child: IconButton(
                  icon: Icon(Icons.arrow_right,
                      color: Color(0xff6D5A8D),
                      size: (MediaQuery.of(context).size.height) * (60 / 926)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestDetails(
                                quizId: quizId,
                                system: systems,
                                subject: subjects,
                                topic: topics,
                                score: score,
                                status: status)));
                  })),
        ],
      ),
    );
  }
}
