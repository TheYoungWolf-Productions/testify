import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:http/http.dart' as http;
import 'package:testify/models/GenerateQuizModels/QuizModuleModels/generate_quiz_model.dart';
import 'package:testify/models/GetPreviousQuizzesModel/ResumeQuiz/resume_quiz_model.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/QuizModule/question_explanation.dart';
import 'package:testify/screens/Welcome/QuizModule/quiz_final.dart';
import 'package:testify/screens/Welcome/QuizModule/search_bar.dart';
import 'package:testify/screens/Welcome/side_menu_bar.dart';
import 'package:testify/screens/Welcome//QuizModule/calculator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class QuizModule extends StatefulWidget {
  const QuizModule({Key? key, required this.totalQuestions, required this.questions, required this.timedMode, required this.mode, required this.whatsDone}) : super(key: key);

  final int totalQuestions;
  final List<int> questions;
  final bool timedMode;
  final String mode; // tutor/ exam
  final String whatsDone; // new(From Generate Quiz), resumed, reviewed
  @override
  _QuizModuleState createState() => _QuizModuleState();
}

class _QuizModuleState extends State<QuizModule> with WidgetsBindingObserver{
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  List<String> _questions = ['1', '2', '3', '4'];
  String _currentQuestion = '1';
  int _currentSelected = 0;
  String _labValues="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet finibus elit non luctus. Morbi auctor mattis ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet finibus elit non luctus. Morbi auctor mattis ante.";
  String _note="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet finibus elit non luctus. Morbi auctor mattis ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet finibus elit non luctus. Morbi auctor mattis ante.";
  late TextEditingController _textController;
  double _fontSize = 18; // To change font size
  bool _showTextZoom = false; // To show ths slider

  int timeElapsed = 0;
  /// declare a timer
  Timer? timer;
  // Timer? saveQuiz; // Saves quiz every few seconds.

  //BottomNavBar
  int _selectedIndex = 0;

  // This key is used to open the side drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Shared Pref
  var _token;
  var _userId;

  //Model Data
  var _getGenerateQuizSuccessful;
  var _resumeQuizSuccessful;
  var _quizId;

  //Changing quiz questions
  // This changes the array index which in turn changes the rest.
  int questionNumber = 0;

  //To change Icon and color
  int whichOption = 0;

  // To void null safety error
  bool hasDataLoaded = false;
  bool ranSaveQuizAtTheStart = false; // To auto save the quiz at the start and avoid the quizzes from being suspended
  // if(hasDataLoaded = true) {
  // if(ranSaveQuizAtTheStart = false) {
  // SaveQuizAPI();
  // setState(() {
  // ranSaveQuizAtTheStart = true;
  // });
  // }
  // }

  //Storing the data required to display quiz questions and store their answers
  var questionsData = {
    "title": [],
    "id": [],
    "question": [],
    "correct_msg": [], // This is the explanation
    "options": [], // A list would be added to this list
    "statistics": [], // [1, 0, 0]
    "answeredCorrectly": [], // Stores string and turns true if answered correctly. Can't be a bool since values are correct/incorrect/notAnswered
    "optionSelectedInt": [], //To change Icon and color
    "notes": [],
    "submitData": [],
    "SelectedOptionsArray": []
    // "isSelected": []
  };
  var addToSelectedOptionsArray = {
    "index": "",
    "Correctanswerindex": "", // indexOfOptionThatIsActuallyCorrect
    "correct": "", // Correct = 1 if answer is correct, -1 if answer is omitted and 0 if answer is incorrect
    "optionIndexSelected": ""
  };

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    WidgetsBinding.instance!.addObserver(this);
    if(widget.whatsDone == "new")
      GenerateQuizAPI();
    else if(widget.whatsDone == "resumed")
      ResumeQuizAPI();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(() {
          timeElapsed++;
        });
      },
    );

    // saveQuiz = Timer.periodic(
    //   const Duration(seconds: 10),
    //       (timer) {
    //         SaveQuizAPI();
    //   },
    // );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final isBackground = state == AppLifecycleState.paused;
    final isClosed = state == AppLifecycleState.detached;
    if(isBackground) { // As soon as the user closes the app this runs. The application is still in the app switcher(ram)
      print("xD in Background");
      SaveQuizAPI("suspended");
      // ScaffoldMessenger.of(context)
      //   ..removeCurrentSnackBar()
      //   ..showSnackBar(SnackBar(content: Text("The Quiz has been saved as Suspended!")));
      Navigator.of(context).pop();
    }
    if(isClosed) { // When app is closed from the app switcher. Doesn't run for now for some odd reason.
      print("xD Closed");
    }
  }

  Future<void> ResumeQuizAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrlGenerateQuiz = "https://demo.pookidevs.com/quiz/solver/resumeQuiz";
    var quizID = prefs.getInt("quizId");
    _token = prefs.getString('token')!;
    print(_token);
    _userId = prefs.getInt("userId")!;
    http.post(Uri.parse(apiUrlGenerateQuiz), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "quizId": quizID
        })
    ).then((response) {
      // print(jsonDecode(response.body).toString());
      if((response.statusCode == 200) & (json.decode(response.body).toString().substring(0,14) != "{status: false")) {
        final responseString = (response.body);
        var resumeQuizSuccessful1 = resumeQuizModelFromJson(responseString);
        final ResumeQuizModel resumeQuizSuccessful = resumeQuizSuccessful1;
        setState(() {
          _resumeQuizSuccessful = resumeQuizSuccessful;
          print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.quizMode);
          print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.quizTotalQuestions);
          print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.quizQuestions);
          print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.quizStatus);
          print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.isTimed);
          // print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.quizId.runtimeType);
          // print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.quizScore.runtimeType);
          // _quizId = _getGenerateQuizSuccessful.data.quizId;
          // print(_quizId);
        });
        categoriesGenerateQuizData();
        // categoriesGenerateQuizData();
      }
      else { // Token Invalid

      }
    }
    );
  }

  Future<void> submitAnswerAPI(int? indexOfOptionThatIsActuallyCorrect, int? correct, int? optionIndexSelected) async { // doesn't work properly in exam mode
    final String apiUrlGenerateQuiz = "https://demo.pookidevs.com/quiz/solver/submitAnswer";
    // print(_token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _quizID = prefs.getInt("quizId");

    print(widget.whatsDone);
    print("user id: "+ _userId.toString());
    print("questionId: "+ questionsData["id"]![questionNumber].toString());
    print("quizId" + _quizID.toString());
    print("indexOfOptionThatIsActuallyCorrect: " + indexOfOptionThatIsActuallyCorrect.toString());
    print("correct: " + correct.toString());
    print("optionIndexSelected: " + optionIndexSelected.toString());



    http.post(Uri.parse(apiUrlGenerateQuiz), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "data":{
            "userId": _userId.toString(),
            "questionId": questionsData["id"]![questionNumber].toString(),
            // "quizId": widget.whatsDone == "new" ? _getGenerateQuizSuccessful.data.quizId.toString() : _resumeQuizSuccessful.data.previousQuizzes[0].quizId.toString(),
            "quizId": _quizID.toString(),
            "answerMeta":{
              "index": questionsData["id"]![questionNumber].toString(),
              "Correctanswerindex": indexOfOptionThatIsActuallyCorrect.toString(), // indexOfOptionThatIsActuallyCorrect
              "correct": correct.toString(), // Correct = 1 if answer is correct, -1 if answer is omitted and 0 if answer is incorrect
              "optionIndexSelected": optionIndexSelected.toString()
            }
          }
        })
    ).then((response) {
      if((response.statusCode == 200)) {
        print(jsonDecode(response.body).toString());
        if((jsonDecode(response.body).toString()) == "{data: {status: true, message: Answer Submitted}}") {

        } else {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Error! Answer not Saved!")));
        }
      }
      else { // Token Invalid
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Token Invalid!")));
        final result = Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => const Login(fromWhere:"Home")),
          ModalRoute.withName('/'),
        );
      }
    }
    );
  }


  Future<void> SaveQuizAPI(String saveAs, [bool? hasUserClicked]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.whatsDone == "new" ? prefs.setInt("quizId", _getGenerateQuizSuccessful.data.quizId) : null;
    var _quizID = widget.whatsDone == "new" ? _getGenerateQuizSuccessful.data.quizId.toString() : _resumeQuizSuccessful.data.previousQuizzes[0].quizId.toString();
    final String apiUrlGenerateQuiz = "https://demo.pookidevs.com/quiz/solver/saveQuiz";
    print(widget.totalQuestions);
    var date = new DateTime.now().toString().split(".");
    date = date[0].split(" ");
    print(date);
    int quizScore = 0;
    var addToOmittedQuestionsArray = [];
    var finalSelectedOptionsArray = [];
    var totalQuizTime = timeElapsed.toString();
    for(int i = 0; i<questionsData["answeredCorrectly"]!.length; i++) {
      if(questionsData["answeredCorrectly"]![i] == "correct") {
        quizScore++;
      }
    }
    if(widget.mode == "exam") {
      if ((questionsData["SelectedOptionsArray"] != null) ||
          (questionsData["SelectedOptionsArray"] != [])) {
        for (int i = 0; i < questionsData["answeredCorrectly"]!.length; i++) {
          if (questionsData["answeredCorrectly"]![i] != "notAnswered") {
            // questionsData["SelectedOptionsArray"]!.removeAt(i);
            finalSelectedOptionsArray
                .add(questionsData["SelectedOptionsArray"]![i]);
          }
        }
      }
    }
    if(saveAs == "completed") {
      for(int i = 0; i<questionsData["answeredCorrectly"]!.length; i++) {
        if(questionsData["answeredCorrectly"]![i] == "notAnswered") {
          var addToOmittedQuestions = {
              "index": questionsData["id"]![i].toString(),
              "Correctanswerindex": "-1", // indexOfOptionThatIsActuallyCorrect
              "correct": "-1", // Correct = 1 if answer is correct, -1 if answer is omitted and 0 if answer is incorrect
              "optionIndexSelected": "-1"
          };
          addToOmittedQuestionsArray.add(addToOmittedQuestions);
        }
      }
    }
    if(saveAs == "suspended") {
      addToOmittedQuestionsArray = [];
    }
    // print(addToOmittedQuestionsArray);
    //
    // print("Start: ");
    // print("quizId: " + _quizID.toString());
    // print("quizTitle: " + "Custom Quiz" + date[0].toString());
    // print("quizDate: " + date[0].toString());
    // print("quizScore: " + quizScore.toString());
    // print("quizTotalQuestions: " + widget.totalQuestions.toString());
    // print("quizStatus: " + saveAs);
    // print("quizQuestions: " + questionsData["id"].toString());
    // print("quizMode: " + widget.mode);
    // print("quizTime: " + totalQuizTime.toString());
    // print("isTimed: " + widget.timedMode.toString());
    // print("omittedQuestions: " + addToOmittedQuestionsArray.toString());
    // print("SelectedOptionsArray: " + questionsData["SelectedOptionsArray"].toString());
    // print("finalSelectedOptionsArray: " + finalSelectedOptionsArray.toString());
    // print("userId: " + _userId.toString());
    // print(" :End");

    await http.post(Uri.parse(apiUrlGenerateQuiz), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "data":
          {
            "quiz" : {
              "quizId": widget.whatsDone == "new" ? _getGenerateQuizSuccessful.data.quizId.toString() : _resumeQuizSuccessful.data.previousQuizzes[0].quizId.toString(),
              "quizTitle": "Custom Quiz" + date[0].toString(), // "Custom Quiz" + Date.now()
              "quizDate": date[0].toString(), // "Custom Quiz"
              "quizScore": quizScore.toString(), // total correct
              "quizTotalQuestions": widget.totalQuestions.toString(),
              "quizStatus": saveAs, // == "completed" ? "completed" : "suspended", // "completed", "suspended"
              "quizQuestions": questionsData["id"].toString(), // Question IDs
              "quizMode": widget.mode, // "tutor", "exam"
              "quizTime": totalQuizTime.toString(), // total quiz time in seconds
              "isTimed": widget.timedMode, // bool true or false
              "omittedQuestions": addToOmittedQuestionsArray, // Don't send anything here
              "SelectedOptionsArray": widget.mode == "exam" ? finalSelectedOptionsArray : [] // Don't send anything here
            },
            "userId": _userId.toString()
          }
        }

        )
    ).then((response) async {
      print(jsonDecode(response.body).toString());
      if((response.statusCode == 200) & (json.decode(response.body).toString().substring(0,14) != "{status: false")) {

      }
      else { // Token Invalid
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Token Invalid!")));
        final result = Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => const Login(fromWhere:"Home")),
          ModalRoute.withName('/'),
        );
      }
    }
    ).whenComplete(() {
      if(hasUserClicked == true) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("The Quiz has been saved as $saveAs!")));
        Navigator.of(context)
            .popUntil(ModalRoute.withName("/home"));
        final result = Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizFinal()),
        );
      }
    });

  }

  Future<void> GenerateQuizAPI() async {
    print("Mode: " + widget.mode.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrlGenerateQuiz = "https://demo.pookidevs.com/quiz/generator/generateQuiz";
    _token = prefs.getString('token')!;
    _userId = prefs.getInt("userId")!;
    http.post(Uri.parse(apiUrlGenerateQuiz), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "data":
          {
            "questionIds": widget.questions,
            "count": widget.totalQuestions
          }
        })
    ).then((response) {
      // print("This is: " + jsonDecode(response.body).toString());
      if((response.statusCode == 200) & (json.decode(response.body).toString().substring(0,14) != "{status: false")) {
        final responseString = (response.body);
        var generateQuizSuccessful = generateQuizSuccessfulFromJson(responseString);
        final GenerateQuizSuccessful getGenerateQuizSuccessful = generateQuizSuccessful;
        setState(() {
          _getGenerateQuizSuccessful = getGenerateQuizSuccessful;
          _quizId = _getGenerateQuizSuccessful.data.quizId;
          print(_quizId);
        });
        categoriesGenerateQuizData();
      }
      else { // Token Invalid

      }
    }
    );
  }

  Future<void> BookmarkQuestionAPI() async {
    final String apiUrlGenerateQuiz = "https://demo.pookidevs.com/quiz/solver/markQuestion";
    http.post(Uri.parse(apiUrlGenerateQuiz), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "data": {
            "userId": _userId,
            "questionId": questionsData["id"]![questionNumber].toString(),
            "tableName": "marked_questions",
            "isMarked": true
          }
        })
    ).then((response) {
      if((response.statusCode == 200)) { //  & (json.decode(response.body).toString().substring(0,14) != "{status: false")) {
        print(jsonDecode(response.body).toString());
      }
      else { // Token Invalid
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Token Invalid!")));
        final result = Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => const Login(fromWhere:"Home")),
          ModalRoute.withName('/'),
        );
      }
    }
    );
  }

  Future<void> addNotesAPI() async {
    // print(_userId);
    // print(questionsData["id"]![questionNumber].toString());
    // print(_quizId);
    // print(_note);
    final String apiUrlGenerateQuiz = "https://demo.pookidevs.com/quiz/notes/addNotes";
    http.post(Uri.parse(apiUrlGenerateQuiz), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "data": {
            "userId": _userId,
            "questionId": questionsData["id"]![questionNumber].toString(),
            "quizId": _quizId,
            "note": _note,
            "tableName": "notes"
          }
        }
        )
    ).then((response) {
      // print(jsonDecode(response.body).toString());
      // print(json.decode(response.body).toString().substring(json.decode(response.body).toString().length-12,json.decode(response.body).toString().length));
      if((response.statusCode == 200) & (json.decode(response.body).toString().substring(json.decode(response.body).toString().length-12,json.decode(response.body).toString().length) == "Note Added}}")) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Note Added!")));
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
          ..showSnackBar(SnackBar(content: Text("Note not Added!")));
      }
    }
    );
  }

  void categoriesGenerateQuizData() async {
    setState(() {
      questionsData["id"] = [];
      questionsData["question"] = [];
      questionsData["options"] = [];
      questionsData["statistics"] = [];
      questionsData["correct_msg"] = [];
      questionsData["answeredCorrectly"] = [];
      questionsData["optionSelectedInt"] = [];
      questionsData["notes"] = [];
      questionsData["submitData"] = [];
      questionsData["SelectedOptionsArray"] = [];
      _questions = [];
    });
    if(widget.whatsDone == "new")
    {
      int c = 0;
      if (_getGenerateQuizSuccessful != null) {
        while ((c < _getGenerateQuizSuccessful.data.questions.toList().length) &
            (_getGenerateQuizSuccessful.data.questions.toList().length > 0)) {
          // questionsData
          setState(() {
            questionsData["id"]!
                .add(_getGenerateQuizSuccessful.data.questions[c].id);
            questionsData["question"]!
                .add(_getGenerateQuizSuccessful.data.questions[c].question);
            questionsData["options"]!
                .add(_getGenerateQuizSuccessful.data.questions[c].options);
            questionsData["statistics"]!
                .add(_getGenerateQuizSuccessful.data.questions[c].statistics);
            questionsData["correct_msg"]!.add(_getGenerateQuizSuccessful
                .data.questions[c].correctMsg); //answeredCorrectly
            questionsData["answeredCorrectly"]!.add("notAnswered");
            questionsData["optionSelectedInt"]!.add(0);
            questionsData["SelectedOptionsArray"]!.add(addToSelectedOptionsArray);
            _questions.add((c + 1).toString());
          });
          c++;
        }
        setState(() {
          hasDataLoaded = true;
        });
        if (hasDataLoaded == true) {
          if (ranSaveQuizAtTheStart == false) {
            SaveQuizAPI("suspended");
            setState(() {
              ranSaveQuizAtTheStart = true;
            });
          }
        }
      }
    }
    // print(questionsData);
    else if(widget.whatsDone == "resumed")
    { // Have to complete Exam Mode
      int c = 0;
      if (_resumeQuizSuccessful != null) {
        while ((c < _resumeQuizSuccessful.data.questions.length) &
        (_resumeQuizSuccessful.data.questions.length > 0)) {
          // questionsData
          setState(() {
            questionsData["id"]!
                .add(_resumeQuizSuccessful.data.questions[c].id);
            questionsData["question"]!
                .add(_resumeQuizSuccessful.data.questions[c].question);
            questionsData["options"]!
                .add(_resumeQuizSuccessful.data.questions[c].options);
            questionsData["statistics"]!
                .add(_resumeQuizSuccessful.data.questions[c].statistics);
            questionsData["correct_msg"]!.add(_resumeQuizSuccessful
                .data.questions[c].correctMsg); //answeredCorrectly
            questionsData["answeredCorrectly"]!.add("notAnswered");
            questionsData["optionSelectedInt"]!.add(0);
            // questionsData["SelectedOptionsArray"]![c] = _resumeQuizSuccessful.data.previousQuizzes[0].quiz_meta.selectedOptionsArray
            _questions.add((c + 1).toString());
            if(widget.mode == "exam") {
              questionsData["SelectedOptionsArray"]!.add(addToSelectedOptionsArray);
              // print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray);
            }
            if(_resumeQuizSuccessful.data.questions[c].notes != null) { // notes
              questionsData["notes"]!.add(_resumeQuizSuccessful
                  .data.questions[c].notes);
            } else {
              questionsData["notes"]!.add("");
            }
            if(_resumeQuizSuccessful.data.questions[c].submitData != null) { // submitData
              String str = _resumeQuizSuccessful.data.questions[c].submitData;
              str = str.replaceAll("\\", "");
              var strMap = json.decode(str);
              // print(strMap);
              if(strMap['correct'] == '1') {
                questionsData["answeredCorrectly"]![c] = "correct";
              }
              else if (strMap['correct'] == '0') {
                questionsData["answeredCorrectly"]![c] = "incorrect";
              }
              questionsData["optionSelectedInt"]![c] = int.parse(strMap['optionIndexSelected']);
              questionsData["submitData"]!.add(_resumeQuizSuccessful
                  .data.questions[c].submitData);
            } else {
              questionsData["submitData"]!.add("");
            }
          });
          c++;
        }
        // Adding data to questionsData["SelectedOptionsArray"]
        if(widget.mode == "exam") {
          if((_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray != null) || (_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray != [])) {
            for(int i = 0; i<_resumeQuizSuccessful.data.questions.length; i++) {
              for(int j = 0; j<_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray.length; j++) {
                if(_resumeQuizSuccessful.data.questions[i].id.toString() == _resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray[j].index) {
                  if(_resumeQuizSuccessful.data.questions[i].submitData != null) {
                    setState(() {
                      questionsData["SelectedOptionsArray"]![i] = {
                        "index": _resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray[j].index,
                        "Correctanswerindex": _resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray[j].correctanswerindex, // indexOfOptionThatIsActuallyCorrect
                        "correct": _resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray[j].correct, // Correct = 1 if answer is correct, -1 if answer is omitted and 0 if answer is incorrect
                        "optionIndexSelected": _resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.selectedOptionsArray[j].optionIndexSelected
                      };
                    });
                  }
                }
              }
            }
          }
        }
        print(questionsData["SelectedOptionsArray"]);
        print(questionsData["answeredCorrectly"]);
        setState(() {
          hasDataLoaded = true;
        });
        if (hasDataLoaded == true) {
          if (ranSaveQuizAtTheStart == false) {
            SaveQuizAPI("suspended");
            setState(() {
              ranSaveQuizAtTheStart = true;
            });
          }
        }
      }
    }
    // print(_resumeQuizSuccessful.data.previousQuizzes[0].quizMeta.quizMode);
  }

  // To change text size - text zoom
  Widget _textZoom(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        height: ((MediaQuery.of(context).size.height) * (51 / 926)),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff7F1AF1), Color(0xff482384)])),
        child: new Slider(
          value: _fontSize,
          activeColor: Colors.white,
          inactiveColor: Colors.red,
          onChanged: (double value) {
            setState(() {
              _fontSize = value;
              print(_fontSize);
            });
          },
          divisions: 4,
          min: 14.0,
          max: 22.0,
        ),
      ),
    );
  }


  void onEnd() {
    print('onEnd');
  }

  Widget bookmarkQuestion(BuildContext context) {
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
                  'Bookmark',
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
            Text("Are you sure you want to bookmark this question",
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
                  Navigator.of(context).pop();
                  print(questionsData["id"]![questionNumber].toString());
                  BookmarkQuestionAPI();
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

  Widget labValues(BuildContext context) {
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
                  'Lab Values',
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
            Text(_labValues),
          ],
        ),
      ),
    );
  }
  Widget moreMenu() {
    return Container(
        width: (MediaQuery.of(context).size.width) * 0.3,
        child: Drawer(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[Color(0xff3F2668), Color(0xff482384)])),
              child: ListView(
                  // Remove padding
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      height: (MediaQuery.of(context).size.height),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                          SizedBox(
                            height:
                                (MediaQuery.of(context).size.height) * (47 / 926),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) =>
                                //       labValues(context),
                                // );
                                final result = Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SearchListExample()),
                                );
                              },
                              child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/Images/lab.svg',
                                  height: (MediaQuery.of(context).size.height) *
                                      (37 / 926),
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height) *
                                      (10 / 926),
                                ),
                                Text(
                                  'Lab Values',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Brandon-bld',
                                    fontSize:
                                        (MediaQuery.of(context).size.height) *
                                            (15 / 926),
                                  ),
                                )
                              ],
                            ),
                          )

                              //Divider(),
                              ),
                          SizedBox(
                            height:
                                (MediaQuery.of(context).size.height) * (47 / 926),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              // bookmarkQuestion
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    bookmarkQuestion(context),
                              );
                            },
                              child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.bookmark,
                                  size: 37,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height) *
                                      (10 / 926),
                                ),
                                Text(
                                  'Bookmarks',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Brandon-bld',
                                    fontSize:
                                        (MediaQuery.of(context).size.height) *
                                            (15 / 926),
                                  ),
                                )
                              ],
                            ),
                          )

                              //Divider(),
                              ),
                          SizedBox(
                            height:
                                (MediaQuery.of(context).size.height) * (47 / 926),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          notes(context),
                                    );
                                  },
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.note_rounded,
                                      size: 37,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height) *
                                              (10 / 926),
                                    ),
                                    Text(
                                      'Notes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Brandon-bld',
                                        fontSize:
                                            (MediaQuery.of(context).size.height) *
                                                (15 / 926),
                                      ),
                                    )
                                  ],
                                ),
                              )

                              //Divider(),
                              ),
                          SizedBox(
                            height:
                                (MediaQuery.of(context).size.height) * (47 / 926),
                          ),
                          InkWell(
                            onTap:()  {Navigator.of(context).pop();
                            showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                Calculator(),
                          );},
                              child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/Images/calculator.svg',
                                    height: (MediaQuery.of(context).size.height) *
                                        (37 / 926)),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height) *
                                      (10 / 926),
                                ),
                                Text(
                                  'Calculator',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Brandon-bld',
                                    fontSize:
                                        (MediaQuery.of(context).size.height) *
                                            (15 / 926),
                                  ),
                                )
                              ],
                            ),
                          )),
                          SizedBox(
                            height:
                                (MediaQuery.of(context).size.height) * (47 / 926),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _showTextZoom = true;
                              });
                            },
                              child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/Images/zoom.svg',
                                    height: (MediaQuery.of(context).size.height) *
                                        (37 / 926)),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height) *
                                      (10 / 926),
                                ),
                                Text(
                                  'Text Zoom',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Brandon-bld',
                                    fontSize:
                                        (MediaQuery.of(context).size.height) *
                                            (15 / 926),
                                  ),
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ]),
            )));
  }
  Widget notes(BuildContext context) {
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
                    addNotesAPI();
                    _textController.clear();
                    Navigator.of(context).pop();
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
  Future<bool> _onQuit() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              'Mark Quiz as',
              style: TextStyle(
                color: Color(0xffA1A1A1),
                fontFamily: 'Brandon-bld',
                fontSize: (MediaQuery.of(context).size.height) * (21 / 926),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await SaveQuizAPI("suspended", true);
                  // ScaffoldMessenger.of(context)
                  //   ..removeCurrentSnackBar()
                  //   ..showSnackBar(SnackBar(content: Text("The Quiz has been saved as Suspended!")));
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                },
                child: Text('Suspended',
                    style: TextStyle(
                      color: Color(0xff3F2668),
                      fontFamily: 'Brandon-bld',
                      fontSize:
                      (MediaQuery.of(context).size.height) * (21 / 926),
                    )),
              ),
              TextButton(
                onPressed: () async {
                  await SaveQuizAPI("completed", true);
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop(); // Uncomment when "completed" and omittedQuestionsArray work again.
                  },
                child: Text('Completed',
                    style: TextStyle(
                      color: Color(0xff3F2668),
                      fontFamily: 'Brandon-bld',
                      fontSize:
                          (MediaQuery.of(context).size.height) * (21 / 926),
                    )),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void dispose() {
    _textController.dispose();
    timer?.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    // saveQuiz?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ScaffoldMessenger.of(context)
        //   ..removeCurrentSnackBar()
        //   ..showSnackBar(SnackBar(content: Text("Click on Quit Quiz!")));
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffF8F9FB),
        drawer: SideMenuBar(),
        // drawer: moreMenu(),
        endDrawer: moreMenu(),
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
              DropdownButton(
                value: (questionNumber + 1).toString(),
                underline: Container(),
                iconEnabledColor: Colors.white,
                dropdownColor: Color(0xff3F2668),
                onChanged: (newValue) {
                  setState(() {
                    // print(newValue);
                    _currentQuestion = newValue as String;
                    questionNumber = int.parse(newValue) - 1;
                  });
                },
                items: _questions.map((question) {
                  return DropdownMenuItem(
                    child: new Text(
                      question + ' / ' + widget.totalQuestions.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Brandon-bld',
                        fontSize:
                            (MediaQuery.of(context).size.height) * (20 / 926),
                      ),
                    ),
                    value: question,
                  );
                }).toList(),
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
                SaveQuizAPI("suspended", false);
              },
              child: SvgPicture.asset(
                "assets/Images/logout.svg",
                height: (MediaQuery.of(context).size.height) *(32/926),
              ),
            ),
          ],
        ),
        body: hasDataLoaded == false ? Center(child: CircularProgressIndicator()) : Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showTextZoom = false;
                });
              },
              child: Container(
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
                                          "Question ID: " + questionsData["id"]![questionNumber].toString(), // questionNumber
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
                                  width: (MediaQuery.of(context).size.width) * (87 / 428),
                                  color: Color(0xFF3F2668),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('',
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
                              height: (MediaQuery.of(context).size.height) * (25 / 926),
                            ),
                            Text(
                              questionsData["question"]![questionNumber].toString(),
                              style: TextStyle(
                                color: Color(0xFF483A3A),
                                fontFamily: 'Brandon-med',
                                fontSize:
                                    (MediaQuery.of(context).size.height) * (_fontSize / 926), //38,
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height) * (25 / 926),
                            ),
                            if(questionsData["options"] != null)
                              for(int i = 0; i<questionsData["options"]![questionNumber].length; i++)
                                widget.mode == "tutor" ? Column( // tutor Mode!
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // print("i: " + i.toString());
                                    if(questionsData["answeredCorrectly"]![questionNumber] == "notAnswered") {
                                      int? indexOfOptionThatIsActuallyCorrect;
                                      int? correct;
                                      // whichOption = i; optionSelectedInt
                                      setState(() {
                                        questionsData["optionSelectedInt"]![questionNumber] = i;
                                      });
                                      int j = 0;
                                      for(j = 0; j<10; j++) {
                                        if(questionsData["options"]![questionNumber][i].toString() == questionsData["options"]![questionNumber][j].toString()) {
                                          break;
                                        }
                                      }
                                      if(questionsData["statistics"]![questionNumber][j] == 1) {
                                        setState(() {
                                          questionsData["answeredCorrectly"]![questionNumber] = "correct";
                                        });
                                        correct = 1;
                                        // print("correct: " + correct.toString());
                                        // print(questionsData["answeredCorrectly"]);
                                      }
                                      else if(questionsData["statistics"]![questionNumber][j] == 0) {
                                        setState(() {
                                          questionsData["answeredCorrectly"]![questionNumber] = "incorrect";
                                        });
                                        correct = 0;
                                        // print(questionsData["answeredCorrectly"]);
                                      }
                                      for(int c = 0; c<questionsData["statistics"]![questionNumber].length; c++) {
                                        if(questionsData["statistics"]![questionNumber][c] == 1) {
                                          indexOfOptionThatIsActuallyCorrect = c;
                                          // print("indexOfOptionThatIsActuallyCorrect: " + indexOfOptionThatIsActuallyCorrect.toString());
                                          break;
                                        }
                                      }
                                      submitAnswerAPI(indexOfOptionThatIsActuallyCorrect, correct, i);
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,),
                                  child: Container(
                                      // height: (MediaQuery.of(context).size.height) * (50 / 926),
                                      width: (MediaQuery.of(context).size.width) * (385 / 428),
                                      padding: EdgeInsets.only(
                                        top: (MediaQuery.of(context).size.height) * (8 / 928),
                                          left: (MediaQuery.of(context).size.width) * (13 / 428),
                                        bottom: (MediaQuery.of(context).size.height) * (8 / 928),
                                          ),
                                      decoration: BoxDecoration(
                                          color: ((questionsData["answeredCorrectly"]![questionNumber] == "correct") & (i == questionsData["optionSelectedInt"]![questionNumber])) ? Color(0xFF3F2668) : Color(0xffffffff),
                                          border: Border.all(
                                            width: 2,
                                            color: ((questionsData["answeredCorrectly"]![questionNumber] == "incorrect") & (i == questionsData["optionSelectedInt"]![questionNumber])) ? Color(0xFFD90000) : Colors.white,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(0))
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: (MediaQuery.of(context).size.width) * (300 / 428),
                                            child: Text(questionsData["options"]![questionNumber][i].toString().trim(),
                                                style: TextStyle(
                                                  color: ((questionsData["answeredCorrectly"]![questionNumber] == "correct") & (i == questionsData["optionSelectedInt"]![questionNumber])) ? Colors.white : Color(0xFF6E6D6F),
                                                  fontFamily: 'Brandon-med',
                                                  fontSize: (MediaQuery.of(context).size.height) *
                                                      (_fontSize / 926), //38,
                                                )),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ((questionsData["answeredCorrectly"]![questionNumber] == "notAnswered")) ?
                                              Container(
                                                height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                child: Icon(Icons.radio_button_unchecked,
                                                  color: Color(0xFF3F2668),),
                                              ) : Container(),
                                              ((questionsData["answeredCorrectly"]![questionNumber] == "incorrect") & (i == questionsData["optionSelectedInt"]![questionNumber])) ?
                                              Transform.rotate(
                                                angle: 90 * math.pi / 360,
                                                child: Container(
                                                  height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                  width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                  child: Icon(Icons.add_circle,
                                                  color: Color(0xFFD90000),),
                                                ),
                                              ) : Container(),
                                              ((questionsData["answeredCorrectly"]![questionNumber] == "incorrect") & (i != questionsData["optionSelectedInt"]![questionNumber])) ?
                                              Container(
                                                height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                child: Icon(Icons.radio_button_unchecked,
                                                  color: Color(0xFF3F2668),),
                                              ) : Container(),
                                              ((questionsData["answeredCorrectly"]![questionNumber] == "correct") & (i == questionsData["optionSelectedInt"]![questionNumber])) ?
                                              Container(
                                                height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                child: Icon(Icons.check_circle,
                                                  color: Color(0xFF38D10B),),
                                              ) : Container(),
                                              ((questionsData["answeredCorrectly"]![questionNumber] == "correct") & (i != questionsData["optionSelectedInt"]![questionNumber])) ?
                                              Container(
                                                height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                child: Icon(Icons.radio_button_unchecked,
                                                  color: Color(0xFF3F2668),),
                                              ) : Container(),
                                              SizedBox(
                                                width: (MediaQuery.of(context).size.width) * (5 / 428),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height) * (5 / 926),
                                ),
                                ((questionsData["answeredCorrectly"]![questionNumber] != "notAnswered") & (i == questionsData["optionSelectedInt"]![questionNumber])) ?
                                GestureDetector(
                                  onTap: () {
                                    var correctAns;
                                    for(int c = 0; c<questionsData["statistics"]![questionNumber]!.length; c++) {
                                      if(questionsData["statistics"]![questionNumber]![c] == 1) {
                                        setState(() {
                                          correctAns = questionsData["options"]![questionNumber]![c];
                                        });
                                      }
                                    }
                                    final result = Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => QuestionExplanation(question: questionsData["question"]![questionNumber].toString(), correctAnswer: correctAns.toString(), questionId: questionsData["id"]![questionNumber], explanation: questionsData["correct_msg"]![questionNumber].toString(),)),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "See Explanation",
                                      style: TextStyle(
                                        color: Color(0xFF7F1AF1),
                                        fontFamily: 'Brandon-med',
                                        fontSize: (MediaQuery.of(context).size.height) *
                                            (13 / 926), //38,
                                      ),
                                    ),
                                  ),
                                ) : Container(),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height) * (20 / 926),
                                ),
                              ],
                            ) :
                                Column( // Exam Mode!
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // print("i: " + i.toString());
                                        // if(questionsData["answeredCorrectly"]![questionNumber] == "notAnswered") {
                                        if((questionsData["answeredCorrectly"]![questionNumber] == "notAnswered") || (questionsData["answeredCorrectly"]![questionNumber] != "notAnswered")) {
                                          int? indexOfOptionThatIsActuallyCorrect;
                                          int? correct;
                                          // whichOption = i; optionSelectedInt
                                          setState(() {
                                            questionsData["optionSelectedInt"]![questionNumber] = i;
                                          });
                                          int j = 0;
                                          for(j = 0; j<10; j++) {
                                            if(questionsData["options"]![questionNumber][i].toString() == questionsData["options"]![questionNumber][j].toString()) {
                                              break;
                                            }
                                          }
                                          if(questionsData["statistics"]![questionNumber][j] == 1) {
                                            setState(() {
                                              questionsData["answeredCorrectly"]![questionNumber] = "correct";
                                            });
                                            correct = 1;
                                            // print("correct: " + correct.toString());
                                            // print(questionsData["answeredCorrectly"]);
                                          }
                                          else if(questionsData["statistics"]![questionNumber][j] == 0) {
                                            setState(() {
                                              questionsData["answeredCorrectly"]![questionNumber] = "incorrect";
                                            });
                                            correct = 0;
                                            // print(questionsData["answeredCorrectly"]);
                                          }
                                          for(int c = 0; c<questionsData["statistics"]![questionNumber].length; c++) {
                                            if(questionsData["statistics"]![questionNumber][c] == 1) {
                                              indexOfOptionThatIsActuallyCorrect = c;
                                              // print("indexOfOptionThatIsActuallyCorrect: " + indexOfOptionThatIsActuallyCorrect.toString());
                                              break;
                                            }
                                          }
                                          print(questionsData["answeredCorrectly"]);
                                          addToSelectedOptionsArray = {
                                            "index": questionsData["id"]![questionNumber].toString(),
                                            "Correctanswerindex": indexOfOptionThatIsActuallyCorrect.toString(), // indexOfOptionThatIsActuallyCorrect
                                            "correct": correct.toString(), // Correct = 1 if answer is correct, -1 if answer is omitted and 0 if answer is incorrect
                                            "optionIndexSelected": i.toString()
                                          };
                                          setState(() {
                                            questionsData["SelectedOptionsArray"]![questionNumber] = addToSelectedOptionsArray;
                                          });
                                          // submitAnswerAPI(indexOfOptionThatIsActuallyCorrect, correct, i);
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,),
                                      child: Container(
                                        // height: (MediaQuery.of(context).size.height) * (50 / 926),
                                          width: (MediaQuery.of(context).size.width) * (385 / 428),
                                          padding: EdgeInsets.only(
                                            top: (MediaQuery.of(context).size.height) * (8 / 928),
                                            left: (MediaQuery.of(context).size.width) * (13 / 428),
                                            bottom: (MediaQuery.of(context).size.height) * (8 / 928),
                                          ),
                                          decoration: BoxDecoration(
                                              color: ((questionsData["answeredCorrectly"]![questionNumber] != "notAnswered") & (i == questionsData["optionSelectedInt"]![questionNumber])) ? Color(0xffffffff) : Color(0xffffffff),
                                              border: Border.all(
                                                width: 2,
                                                color: ((questionsData["answeredCorrectly"]![questionNumber] != "notAnswered") & (i == questionsData["optionSelectedInt"]![questionNumber])) ? Color(0xFF3F2668) : Colors.white, // Color(0xFF3F2668)
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(0))
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: (MediaQuery.of(context).size.width) * (300 / 428),
                                                child: Text(questionsData["options"]![questionNumber][i].toString().trim(),
                                                    style: TextStyle(
                                                      color: Color(0xFF6E6D6F),
                                                      fontFamily: 'Brandon-med',
                                                      fontSize: (MediaQuery.of(context).size.height) *
                                                          (_fontSize / 926), //38,
                                                    )),
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  ((questionsData["answeredCorrectly"]![questionNumber] == "notAnswered")) ?
                                                  Container(
                                                    height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    child: Icon(Icons.radio_button_unchecked,
                                                      color: Color(0xFF3F2668),),
                                                  ) : Container(),
                                                  ((questionsData["answeredCorrectly"]![questionNumber] == "incorrect") & (i == questionsData["optionSelectedInt"]![questionNumber])) ?
                                                  Container(
                                                    height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    child: Icon(Icons.check_circle,
                                                      color: Color(0xFF3F2668),),
                                                  ) : Container(),
                                                  ((questionsData["answeredCorrectly"]![questionNumber] == "incorrect") & (i != questionsData["optionSelectedInt"]![questionNumber])) ?
                                                  Container(
                                                    height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    child: Icon(Icons.radio_button_unchecked,
                                                      color: Color(0xFF3F2668),),
                                                  ) : Container(),
                                                  ((questionsData["answeredCorrectly"]![questionNumber] == "correct") & (i == questionsData["optionSelectedInt"]![questionNumber])) ?
                                                  Container(
                                                    height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    child: Icon(Icons.check_circle,
                                                      color: Color(0xFF3F2668),),
                                                  ) : Container(),
                                                  ((questionsData["answeredCorrectly"]![questionNumber] == "correct") & (i != questionsData["optionSelectedInt"]![questionNumber])) ?
                                                  Container(
                                                    height: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    width: (MediaQuery.of(context).size.height) * (30 / 926),
                                                    child: Icon(Icons.radio_button_unchecked,
                                                      color: Color(0xFF3F2668),),
                                                  ) : Container(),
                                                  SizedBox(
                                                    width: (MediaQuery.of(context).size.width) * (5 / 428),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      height: (MediaQuery.of(context).size.height) * (5 / 926),
                                    ),
                                    // ((questionsData["answeredCorrectly"]![questionNumber] != "notAnswered") & (i == questionsData["optionSelectedInt"]![questionNumber])) ?
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     var correctAns;
                                    //     for(int c = 0; c<questionsData["statistics"]![questionNumber]!.length; c++) {
                                    //       if(questionsData["statistics"]![questionNumber]![c] == 1) {
                                    //         setState(() {
                                    //           correctAns = questionsData["options"]![questionNumber]![c];
                                    //         });
                                    //       }
                                    //     }
                                    //     final result = Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(builder: (context) => QuestionExplanation(question: questionsData["question"]![questionNumber].toString(), correctAnswer: correctAns.toString(), questionId: questionsData["id"]![questionNumber], explanation: questionsData["correct_msg"]![questionNumber].toString(),)),
                                    //     );
                                    //   },
                                    //   child: Container(
                                    //     alignment: Alignment.topRight,
                                    //     child: Text(
                                    //       "See Explanation",
                                    //       style: TextStyle(
                                    //         color: Color(0xFF7F1AF1),
                                    //         fontFamily: 'Brandon-med',
                                    //         fontSize: (MediaQuery.of(context).size.height) *
                                    //             (13 / 926), //38,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ) : Container(),
                                    SizedBox(
                                      height: (MediaQuery.of(context).size.height) * (20 / 926),
                                    ),
                                  ],
                                ),// here
                            SizedBox(
                              height: (MediaQuery.of(context).size.height) * (5 / 926),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height) * (96 / 926),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    child: Icon(Icons.power_settings_new,
                                      color: Color(0xFF7F1AF1),
                                    size: (MediaQuery.of(context).size.height) *
                                        (23 / 926),),
                                  ),
                                ),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width) * (5 / 428),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                        child: Text(
                                          "Quit Quiz",
                                          style: TextStyle(
                                            color: Color(0xFF7F1AF1),
                                            fontFamily: 'Brandon-bld',
                                            fontSize: (MediaQuery.of(context).size.height) *
                                                (13 / 926), //38,
                                          ),
                                        ),
                                        onTap: () => _onQuit())),
                              ],
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height) * (26 / 926),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ) ,
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: ((MediaQuery.of(context).size.height) * (51 / 926)),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Color(0xff7F1AF1), Color(0xff482384)])),
                child: _showTextZoom == true ? _textZoom(context) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if(questionNumber > 0) {
                          setState(() {
                            questionNumber--;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,),
                      child: Row(
                        children: [
                          SizedBox(width: (MediaQuery.of(context).size.width) * (16 / 428)),
                          Container(
                            child: Icon(Icons.arrow_back_ios_outlined,
                              color: Colors.white,
                              size: ((MediaQuery.of(context).size.width) * (23.1 / 428)),),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) => TextButton(
                        onPressed: () { Scaffold.of(context).openEndDrawer(); },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,),
                        child: Row(
                          children: [
                            Container(
                              width: ((MediaQuery.of(context).size.height) * (15 / 926)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                            ),
                            SizedBox(width: (MediaQuery.of(context).size.width) * (6 / 428)),
                            Container(
                              width: ((MediaQuery.of(context).size.height) * (15 / 926)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                            ),
                            SizedBox(width: (MediaQuery.of(context).size.width) * (6 / 428)),
                            Container(
                              width: ((MediaQuery.of(context).size.height) * (15 / 926)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if(questionNumber < (widget.totalQuestions - 1)) {
                          setState(() {
                            questionNumber++;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
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
      ),
    );
  }
}
