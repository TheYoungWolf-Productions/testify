import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/GenerateQuiz/generate_quiz_last.dart';
import 'package:testify/screens/Welcome/GenerateQuiz/question_types.dart';
import 'package:testify/screens/Welcome/side_menu_bar.dart';

class Difficulty extends StatefulWidget {
  @override
  State<Difficulty> createState() => _DifficultyState();
}

class _DifficultyState extends State<Difficulty> {
  //Fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F9FB),
      drawer: SideMenuBar(),
      appBar: AppBar(
        backgroundColor: Color(0xff3F2668),
        elevation: 2,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff7F1AF1),
                    Color(0xff482384)
                  ])
          ),
        ),
        title: const Text("Generate Quiz",
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
                MaterialPageRoute(builder: (context) => const Login(fromWhere:"Home")),
              );
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top:(MediaQuery.of(context).size.height) *(15/926),
            bottom: (MediaQuery.of(context).size.height) *(8/926),
            left: (MediaQuery.of(context).size.width) *(18/428),
            right: (MediaQuery.of(context).size.width) *(18/428)),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width) *(221/428),
                  //height: (MediaQuery.of(context).size.height) *(91/926),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Create Quiz",
                          style: TextStyle(
                            color: Color(0xff232323),
                            fontFamily: 'Brandon-bld',
                            fontSize: (MediaQuery.of(context).size.height) *(20/926),//38,
                          ),),
                      ),
                      SizedBox(height: (MediaQuery.of(context).size.height) *(2/926),),
                      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet finibus elit non luctus. Morbi auctor mattis ante.",
                        style: TextStyle(
                          color: Color(0xFF483A3A),
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) *(10/926),//38,
                        ),),
                    ],
                  ),
                ),
                SizedBox(width: (MediaQuery.of(context).size.width) *(39/428),),
                Container(
                  //color: Colors.transparent,
                  child: SvgPicture.asset(
                    "assets/Images/create_quiz.svg",
                    height: (MediaQuery.of(context).size.height) *(100/926),
                    //width: (MediaQuery.of(context).size.width) *(132/428),
                  ),
                ),
              ],
            ),
            SizedBox(height: (MediaQuery.of(context).size.height) *(25/926),),
            //a
            Container(
              height: (MediaQuery.of(context).size.height) *(35.32/926),
              decoration: BoxDecoration(
                color: Color(0xff3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,//Color(0xff00000029),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: (MediaQuery.of(context).size.width) *(28/428),),
                  Container(
                    padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height) *(9/926), bottom: (MediaQuery.of(context).size.height) *(4/926)),
                    height: (MediaQuery.of(context).size.height) *(35.32/926),
                    width: (MediaQuery.of(context).size.width) *(113/428),
                    color: Color(0xFF3F2668),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" Systems/Subjects/Topics ",
                          style: TextStyle(
                            color: Color(0xffFEFEFE),
                            fontFamily: 'Brandon-bld',
                            fontSize: (MediaQuery.of(context).size.height) *(12/926),
                          ),),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height) *(5/926), bottom: (MediaQuery.of(context).size.height) *(5/926)),
                    height: (MediaQuery.of(context).size.height) *(35.32/926),
                    width: (MediaQuery.of(context).size.width) *(80/428),
                    color: Color(0xFF3F2668),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Question Types",
                          style: TextStyle(
                            color: Color(0xffFEFEFE),
                            fontFamily: 'Brandon-bld',
                            fontSize: (MediaQuery.of(context).size.height) *(12/926),
                          ),),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height) *(5/926), bottom: (MediaQuery.of(context).size.height) *(5/926)),
                    height: (MediaQuery.of(context).size.height) *(35.32/926),
                    width: (MediaQuery.of(context).size.width) *(65/428),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Difficulty",
                          style: TextStyle(
                            color: Color(0xFF3F2668),//0xFF3F2668
                            fontFamily: 'Brandon-bld',
                            fontSize: (MediaQuery.of(context).size.height) *(12/926),
                          ),),
                        Container(
                          padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width) *(13/428), right: (MediaQuery.of(context).size.width) *(13/428)),
                          //margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height) *(1/926)),
                          child: Divider(height: 3,
                            thickness: 2,
                            color: Color(0xFF3F2668),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height) *(5/926), bottom: (MediaQuery.of(context).size.height) *(5/926)),
                    height: (MediaQuery.of(context).size.height) *(35.32/926),
                    width: (MediaQuery.of(context).size.width) *(75/428),
                    color: Color(0xFF3F2668),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Generate Quiz",
                          style: TextStyle(
                            color: Color(0xffFEFEFE),
                            fontFamily: 'Brandon-bld',
                            fontSize: (MediaQuery.of(context).size.height) *(12/926),
                          ),),
                      ],
                    ),
                  ),
                  SizedBox(width: (MediaQuery.of(context).size.width) *(28/428),),
                ],
              ),
            ),
            SizedBox(height: (MediaQuery.of(context).size.height) *(15.28/926),),
            Container(
              height: (MediaQuery.of(context).size.height) *(167.52/926),
              color: Colors.red,
            ),
            SizedBox(height: (MediaQuery.of(context).size.height) *(10.74/926),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    height: (MediaQuery.of(context).size.height) *(42/926),
                    width: (MediaQuery.of(context).size.width) *(68/428),
                    decoration: BoxDecoration(
                      color: Color(0xff3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,//Color(0xff00000029),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text("Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Brandon-med',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    height: (MediaQuery.of(context).size.height) *(42/926),
                    width: (MediaQuery.of(context).size.width) *(68/428),
                    decoration: BoxDecoration(
                      color: Color(0xff3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,//Color(0xff00000029),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GenerateQuizLast()),
                        );
                      },
                      child: Center(
                        child: Text("Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Brandon-med',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}