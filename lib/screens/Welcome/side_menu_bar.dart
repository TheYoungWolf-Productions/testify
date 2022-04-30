import 'package:flutter/material.dart';
import 'package:testify/screens/Welcome/GenerateQuiz/generate_quiz.dart';
import 'package:testify/screens/Welcome/Notes/notes.dart';

import 'PreviousQuiz/previous_quiz.dart';

class SideMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width) *0.7,
      child: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: (MediaQuery.of(context).size.height),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[Color(0xff3F2668), Color(0xff482384)])),
              width: (MediaQuery.of(context).size.width) *0.7,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.arrow_back, color: Colors.white,),
                    title: Text('Close', style: TextStyle(color: Colors.white),),
                    onTap: () => Navigator.pop(context),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.quiz_outlined, color: Colors.white,),
                    title: Text('Generate Quiz', style: TextStyle(color: Colors.white),),
                    onTap: () async {
                      // Navigator.of(context).pop();
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName("/home"));
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GenerateQuiz()),
                      );
                    //   final result = Navigator.pushAndRemoveUntil<void>(
                    //     context,
                    //     MaterialPageRoute<void>(builder: (BuildContext context) => GenerateQuiz()),
                    //     ModalRoute.withName('/home'),
                    //   );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.quiz_outlined, color: Colors.white,),
                    title: Text('Previous Quiz', style: TextStyle(color: Colors.white),),
                    onTap: () async {
                      // Navigator.of(context).pop();

                      Navigator.of(context)
                          .popUntil(ModalRoute.withName("/home"));
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreviousQuiz()),
                      );

                      // final result = Navigator.pushAndRemoveUntil<void>(
                      //   context,
                      //   MaterialPageRoute<void>(builder: (BuildContext context) => PreviousQuiz()),
                      //   ModalRoute.withName('/home'),
                      // );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notes_outlined, color: Colors.white,),
                    title: Text('Notes', style: TextStyle(color: Colors.white),),
                    onTap: () async {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName("/home"));
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Notes()),
                      );
                    },
                  ),
                ],
              ),
            ),
            //Divider(),
          ],
        ),
      ),
    );
  }
}