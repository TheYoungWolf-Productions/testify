import 'package:flutter/material.dart';
import 'package:testify/screens/Welcome/GenerateQuiz/generate_quiz.dart';

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
              color: Color(0xffB0A6C2),
              width: (MediaQuery.of(context).size.width) *0.7,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text('Close'),
                    onTap: () => Navigator.pop(context),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.quiz_outlined),
                    title: Text('Generate Quiz'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GenerateQuiz()),
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