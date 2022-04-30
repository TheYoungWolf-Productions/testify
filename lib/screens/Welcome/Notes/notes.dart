import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/models/NotesModel/notes_model.dart';
import 'package:testify/screens/Welcome/Notes/notesTile.dart';
import 'package:http/http.dart' as http;

import '../../Authentication/login.dart';
import '../side_menu_bar.dart';
class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  bool _hasNotesDataLoaded = false;

  //Shared Pref
  var _token;
  var _userId;

  var _notesSuccessful;

  var _notesData = {
    "idpsas_user_notes": [],
    "question_id": [],
    "user_id": [],
    "quiz_id": [],
    "notes": [],
    "note_meta": [],
  };

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future<void> getNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String NotesAPI = "https://demo.pookidevs.com/quiz/notes/getNotes";
    _token = prefs.getString('token')!;
    _userId = prefs.getInt("userId")!;
    http.get(Uri.parse(NotesAPI), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    },).then((response) {
      // print(jsonDecode(response.body));
      if(response.statusCode == 200) {
        if(json.decode(response.body).toString().substring(0,20) == "{data: {status: true"){
          final responseString = (response.body);
          var getNotes = notesModelFromJson(responseString);
          final NotesModel getNotesSuccessful = getNotes;
          setState(() {
            _notesSuccessful = getNotesSuccessful;
          });
          print(_notesSuccessful);
          // print(_getPreviousQuizzesSuccessful.data.quizzes[0].quizId);
          categorizeNotesData();
        }
      }
      else {
        //Token is Invalid
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Token Expired!")));
        final result = Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => const Login(fromWhere:"Home")),
          ModalRoute.withName('/'),
        );
      }
    }
    );
  }

  categorizeNotesData() {
    var noteMetaEntry = {
      "noteTopic": "",
      "noteSystem": "",
      "noteSubject": ""
    };
    String notesMetaString;
    var decodeNotesMetaString;
    int c = 0;
    while((c<_notesSuccessful.data.notes.toList().length) & (_notesSuccessful.data.notes.toList().length > 0)) {
      setState(() {
        _notesData["idpsas_user_notes"]!.add(_notesSuccessful.data.notes[c].idpsasUserNotes);
        _notesData["question_id"]!.add(_notesSuccessful.data.notes[c].questionId);
        _notesData["user_id"]!.add(_notesSuccessful.data.notes[c].userId);
        _notesData["quiz_id"]!.add(_notesSuccessful.data.notes[c].quizId);
        _notesData["notes"]!.add(_notesSuccessful.data.notes[c].notes);
        notesMetaString = _notesSuccessful.data.notes[c].noteMeta;
        notesMetaString = notesMetaString.replaceAll("\\", "");
        decodeNotesMetaString = jsonDecode(notesMetaString);
        noteMetaEntry["noteTopic"] = decodeNotesMetaString["noteTopic"];
        noteMetaEntry["noteSystem"] = decodeNotesMetaString["noteSystem"];
        noteMetaEntry["noteSubject"] = decodeNotesMetaString["noteSubject"];
        _notesData["note_meta"]!.add(noteMetaEntry);
      });
      c++;
    }
    setState(() {
      _hasNotesDataLoaded = true;
    });
    print(_notesData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F9FB),
      drawer: SideMenuBar(),
      appBar: AppBar(
        toolbarHeight: (MediaQuery.of(context).size.height) *(73.52/926),
        backgroundColor: Color(0xff3F2668),
        elevation: 2,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff7F1AF1),
                    Color(0xff482384)
                  ])
          ),
        ),
        title: const Text("Notes",
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
            child: SvgPicture.asset(
              "assets/Images/logout.svg",
              height: (MediaQuery.of(context).size.height) *(32/926),
            ),
          ),
        ],
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.only(top:(MediaQuery.of(context).size.height) *(15/926),
            bottom: (MediaQuery.of(context).size.height) *(8/926),
            left: (MediaQuery.of(context).size.width) *(18/428),
            right: (MediaQuery.of(context).size.width) *(18/428)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width) *(221/428),
                  //height: (MediaQuery.of(context).size.height) *(91/926),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Notes",
                          style: TextStyle(
                            color: Color(0xff232323),
                            fontFamily: 'Brandon-bld',
                            fontSize: (MediaQuery.of(context).size.height) *(25/926),//38,
                          ),),
                      ),
                      SizedBox(height: (MediaQuery.of(context).size.height) *(2/926),),
                      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet finibus elit non luctus. Morbi auctor mattis ante.",
                        style: TextStyle(
                          color: Color(0xFF483A3A),
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) *(13/926),//38,
                        ),),
                    ],
                  ),
                ),
                SizedBox(width: (MediaQuery.of(context).size.width) *(39/428),),
                Container(
                  //color: Colors.transparent,
                  child: SvgPicture.asset(
                    "assets/Images/notes_screen.svg",
                    height: (MediaQuery.of(context).size.height) *(100/926),
                    //width: (MediaQuery.of(context).size.width) *(132/428),
                  ),
                ),
              ],
            ),
            SizedBox(height: (MediaQuery.of(context).size.height)*(30/926),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _hasNotesDataLoaded == false ? CircularProgressIndicator(color: Color(0xFF3F2668)) :
                  GridView.count(shrinkWrap:true,crossAxisCount: 2,crossAxisSpacing:(MediaQuery.of(context).size.width) *(68/428) ,mainAxisSpacing: (MediaQuery.of(context).size.height) *(41/926),childAspectRatio: 1,children: [
                    for(int i = 0; i<_notesData["idpsas_user_notes"]!.length; i++)
                      NotesTile(noteId: _notesData["idpsas_user_notes"]![i], noteText: _notesData["notes"]![i]),
                  ],),
                  // SizedBox(height: (MediaQuery.of(context).size.height)*(92/926),),
                  // InkWell(
                  //   child: Container(
                  //     height: (MediaQuery.of(context).size.height) *(30/926),
                  //     width: (MediaQuery.of(context).size.width) *(110/428),
                  //     decoration: BoxDecoration(
                  //       color: Color(0xff3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                  //       borderRadius: BorderRadius.all(Radius.circular(2)),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black12,//Color(0xff00000029),
                  //           spreadRadius: 2,
                  //           blurRadius: 2,
                  //           offset: Offset(0, 0),
                  //         ),
                  //       ],
                  //     ),
                  //     child: TextButton(
                  //       onPressed: () {
                  //
                  //       },
                  //       child: Center(
                  //         child: Text("Show More",
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontFamily: 'Brandon-med',
                  //             fontSize: (MediaQuery.of(context).size.height) *(20/926)
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
