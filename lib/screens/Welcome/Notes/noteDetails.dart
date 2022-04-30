import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/screens/Welcome/Notes/notes.dart';

import '../../Authentication/login.dart';
import '../side_menu_bar.dart';
class NoteDetails extends StatefulWidget {
  final int noteId;
  final String noteText;
  NoteDetails({required this.noteId,required this.noteText});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  var _note;
  late TextEditingController _textController;

  //Shared Pref
  var _token;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> editNotesAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token')!;
    final String editNotesAPI = "https://demo.pookidevs.com/quiz/notes/editNotes";
    http.post(Uri.parse(editNotesAPI), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "note": {
            "noteId": widget.noteId,
            "description": _note
          }
        }
    )
    ).then((response) {
      print(jsonDecode(response.body).toString());
      // print(json.decode(response.body).toString().substring(json.decode(response.body).toString().length-12,json.decode(response.body).toString().length));
      if((response.statusCode == 200) & (json.decode(response.body).toString().substring(json.decode(response.body).toString().length-13,json.decode(response.body).toString().length) == "Note Edited}}")) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Note Edited!")));
        Navigator.of(context).pop();
      }
      else if((response.statusCode == 200) & (json.decode(response.body).toString().substring(0,14) == "{status: false")) { // Token Invalid
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Token Expired!")));
        final result = Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login(fromWhere:"Home")),
        );
      }
      else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Note not Edited!")));
      }
    }
    );
  }

  Future<void> deleteNotesAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token')!;
    final String editNotesAPI = "https://demo.pookidevs.com/quiz/notes/editNotes";
    http.post(Uri.parse(editNotesAPI), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "noteId": widget.noteId
        }
    )
    ).then((response) {
      print(jsonDecode(response.body).toString());
      // print(json.decode(response.body).toString().substring(json.decode(response.body).toString().length-12,json.decode(response.body).toString().length));
      if((response.statusCode == 200) & (json.decode(response.body).toString().substring(json.decode(response.body).toString().length-14,json.decode(response.body).toString().length) == "Note Deleted}}")) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Note Deleted!")));
        Navigator.of(context).pop();
      }
      else if((response.statusCode == 200) & (json.decode(response.body).toString().substring(0,14) == "{status: false")) { // Token Invalid
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Token Expired!")));
        final result = Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login(fromWhere:"Home")),
        );
      }
      else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Note not Deleted!")));
      }
    }
    );
  }

  Widget editNotes(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width*(15/428)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Take Notes',
                  style: TextStyle(
                    color: Color(0xffB0A6C2),
                    fontFamily: 'Brandon-bld',
                    fontSize: (MediaQuery.of(context).size.height) * (18 / 926),
                  ),
                ),
                IconButton(icon:Icon(Icons.cancel),iconSize:23,color: Color(0xFF3F2668),onPressed: () {
                  Navigator.of(context).pop();
                },),
              ],
            ),
            Divider(),
            TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              minLines: 1,//Normal textInputField will be displayed
              maxLines: 5,// when user presses enter it will adapt to it
              decoration: InputDecoration(
                hintText: "Add notes here...",
                hintStyle: TextStyle(color: Color(0xffAEAEAE),
                  fontSize: (MediaQuery.of(context).size.height)*(15/926),
                  fontFamily: 'Brandon-med',),
                contentPadding: EdgeInsets.fromLTRB(2.0, 1, 2.0, 1),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: (MediaQuery.of(context).size.height)*(15/926),
                fontFamily: 'Brandon-med',
              ),
              onChanged: (String value) {
                setState(() {
                  _note = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed:(){
                  setState((){
                    _note='';
                    _textController.clear();
                  }
                  );
                } , iconSize: 21 ,icon: Icon(Icons.refresh,color: Color(0xFF3F2668))),
                TextButton(
                  onPressed: () {
                    editNotesAPI();
                    _textController.clear();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,),
                  child: Container(
                      height: (MediaQuery.of(context).size.height) * (31 / 926),
                      width:(MediaQuery.of(context).size.width) * (97 / 428),
                      decoration: BoxDecoration(borderRadius:BorderRadius.circular(4),color: Color(0xFFDDDAE2),),
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(Icons.save,color: Color(0xFF3F2668),),
                            SizedBox(
                              height: (MediaQuery.of(context).size.width) *
                                  (14 / 428),
                            ),
                            Text(
                              'Save',
                              style: TextStyle(
                                color: Color(0xff3F2668),
                                fontFamily: 'Brandon-bld',
                                fontSize: (MediaQuery.of(context).size.height) * (19 / 926),
                              ),
                            ),
                          ])
                  ),)
              ],
            )
          ],
        ),
      ),);}

  Widget deleteNote(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width*(15/428)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delete Note',
                  style: TextStyle(
                    color: Color(0xffB0A6C2),
                    fontFamily: 'Brandon-bld',
                    fontSize: (MediaQuery.of(context).size.height) * (18 / 926),
                  ),
                ),
                IconButton(icon:Icon(Icons.cancel),iconSize:23,color: Color(0xFF3F2668),onPressed: () {
                  Navigator.of(context).pop();
                },),
              ],
            ),
            Divider(),
            Text("Are you sure you want to delete this note?",
            ),
          ],
        ),
        actions: <Widget>[
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
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
              Divider(),
              TextButton(
                onPressed: () {
                  deleteNotesAPI();
                  // print(questionsData["id"]![questionNumber].toString());
                  // BookmarkQuestionAPI();
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Press back button!")));
        return false;
      },
      child: Scaffold(
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
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top:(MediaQuery.of(context).size.height) *(28/926),
              bottom: (MediaQuery.of(context).size.height) *(28/926),
              left: (MediaQuery.of(context).size.width) *(24/428),
              right: (MediaQuery.of(context).size.width) *(24/428)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notes',style: TextStyle(color: Color(0xFF3F2668),fontFamily: 'Brandon-bld',fontSize: MediaQuery.of(context).size.height*20/926),),
              SizedBox(height: (MediaQuery.of(context).size.height) *(10/926),),
              Container(
                height: (MediaQuery.of(context).size.height) *(488/926),
                padding: EdgeInsets.all( (MediaQuery.of(context).size.height) *(25/926)),
                decoration: BoxDecoration(
                  color: Color(0xffB0A6C2),
                ),
                child: Column(
                  children: [
                    Container(height:(MediaQuery.of(context).size.height*380/926),child: Text(_note != null ? _note : widget.noteText,style: TextStyle(color: Color(0xFF3F2668),fontFamily: 'Brandon-med',fontSize: MediaQuery.of(context).size.height*18/926),)),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                              deleteNote(context),
                          );
                        },
                        child: Column(
                          children: [
                            Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFF3F2668) ),
                              child: Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height*5/926),
                                child: Icon(Icons.delete,size: MediaQuery.of(context).size.height*25/926,color: Colors.white,),
                              ),),
                            Text('Delete',style: TextStyle(color: Color(0xFF3F2668),fontFamily: 'Brandon-med',fontSize: MediaQuery.of(context).size.height*10/926))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width) * (20 / 428),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                editNotes(context),
                          );
                        },
                        child: Column(
                          children: [
                            Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFF3F2668) ),
                              child: Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height*5/926),
                                child: Icon(Icons.edit,size: MediaQuery.of(context).size.height*25/926,color: Colors.white,),
                              ),),
                            Text('Edit',style: TextStyle(color: Color(0xFF3F2668),fontFamily: 'Brandon-med',fontSize: MediaQuery.of(context).size.height*10/926))
                          ],
                        ),
                      )],)
                  ],
                ),

              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName("/home"));
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notes()),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_outlined, color: Color(0xFF3F2668), size: MediaQuery.of(context).size.height*(18/926),),
                    SizedBox(width: 3,),
                    Text('Back',style: TextStyle(color: Color(0xFF3F2668),fontFamily: 'Brandon-med',fontSize: MediaQuery.of(context).size.height*15/926)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
