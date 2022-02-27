import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/models/GenerateQuizModels/get_system_categories_successful.dart';
import 'package:testify/models/GenerateQuizModels/get_system_categories_unsuccessful.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/QuizModule/quiz_module.dart';
import 'package:testify/screens/Welcome/side_menu_bar.dart';
import 'dart:math' as math;

class GenerateQuiz extends StatefulWidget {
  @override
  State<GenerateQuiz> createState() => _GenerateQuizState();
}

class _GenerateQuizState extends State<GenerateQuiz> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Once the data is loaded only then it shows the containers.
  bool _hasDataLoaded = false;

  //Total Questions returned by the API.
  // First gets its value when getUserData is run and then gets updated as getQuestionCounts is run.
  int _totalQuestions = 0;
  List<int> _questions = [];

  //Tab 1 Data:
  //Not allowing Subjects or topics to be selected if Systems is empty
  bool _systemsDisabled = true;
  bool _topicsDisabled = true;
  //Title, ID, questions(total questions available), isSelected(which checkbox is clicked), finalTitles(titles that work on getQuestionsCount).
  var systemsEverything = {
    "title": [], // Saves titles
    "finalTitles": [], // Save the final titles that are to be sent to getQuestionsCount
    "ID": [], // Saves IDs
    "questions": [], // Saves questions
    "isSelected": [] // Whichever checkbox is true that bool turns true.
  };

  // Tab 2 Data:
  var subjectsEverything = {
    "title": [],
    "finalTitles": [], // Save the final titles that are to be sent to getQuestionsCount
    "ID": [],
    "questions": [],
    "isSelected": []
  };

  // Tab 3 Data:
  var topicsEverything = {
    "title": [],
    "finalTitles": [], // Save the final titles that are to be sent to getQuestionsCount
    "ID": [],
    "questions": [],
    "isSelected": []
  };

  //Tab 4 Data:
  //If no option is selected everything stays false and zero is sent.
  /*None is not populated*/
  List<String> _questionTypesTitle = ["None", "Unused Questions", "Incorrect Questions", "Correct Questions", "Omitted Questions", "Marked Questions", "All"];
  List<bool> _questionTypeSelectedBool = [true, false, false, false, false, false, false];
  int _questionTypeInt = 0;

  //Tab 5 Data:
  List<String> _difficultyLevelTitle = ["Very Easy", "Easy", "Medium", "Hard", "Very Hard"];
  List<bool> _difficultyLevelBool = [false, false, false, false, false];
  List<int> _difficultyLevel = [];
  //Generate Quiz
  bool _tutorMode = true;
  bool _timedMode = false;
  // Just a form key for the questionCount
  final _numberOfQuestionsKey = GlobalKey<FormState>();
  var _questionsCount;

  //Shared Pref
  var _token;
  var _userId;

  // Token Valid
  var _getSystemCategoriesSuccessful;
  // Token Incorrect
  var _getSystemCategoriesUnsuccessful;

  //When getQuestionCount is run(Just used to get the totalQuestions
  var _getQuestionsCountCategoriesSuccessful;
  var _getQuestionsCountCategoriesUnsuccessful;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    getUserDataSST();
  }

  //This is run only once.
  Future<void> getUserDataSST() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrlSystemCategories = "https://demo.pookidevs.com/quiz/generator/getAllCategories";
    _token = prefs.getString('token')!;
    _userId = prefs.getInt("userId")!;
    http.get(Uri.parse(apiUrlSystemCategories), headers: <String, String>{
    'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    },).then((response) {
      // print(jsonDecode(response.body).toString());
      if(response.statusCode == 200) {
        if(json.decode(response.body).toString().substring(0,20) == "{data: {status: true") {
          final responseString = (response.body);
          var systemCategoriesDataSuccessful = getSystemCategoriesSuccessfulModelFromJson(responseString);
          final GetSystemCategoriesSuccessfulModel getSystemCategoriesSuccessful = systemCategoriesDataSuccessful;
          setState(() {
            _getSystemCategoriesSuccessful = getSystemCategoriesSuccessful;
            _hasDataLoaded = true;
            _totalQuestions = _getSystemCategoriesSuccessful.data.totalQuestions;
            _questions = _getSystemCategoriesSuccessful.data.questions;
          });
          // print(_questions);
        } else {

        }
        //Adds data to lists
        categorizeUserData();
      }
      else { // Status Code is 401 here that is why if written in the above if statement it would not work.
        //Token is Invalid
        if(json.decode(response.body).toString().substring(0,14) == "{status: false") {
          final responseString = (response.body);
          var systemCategoriesDataUnsuccessful = getSystemCategoriesUnsuccessfulModelFromJson(responseString);
          final GetSystemCategoriesUnsuccessfulModel getSystemCategoriesUnsuccessful = systemCategoriesDataUnsuccessful;
          setState(() {
            _getSystemCategoriesUnsuccessful = getSystemCategoriesUnsuccessful;
          });
          print(_getSystemCategoriesUnsuccessful.msg);
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Token Expired!")));
          final result = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login(fromWhere:"Home")),
          );
        }
        else {

        }
      }
      }
      );
  }

  Future<void> getQuestionsCount() async {
    // print(subjectsEverything["finalTitles"]);
    // print(systemsEverything["finalTitles"]);
    // print(topicsEverything["finalTitles"]);
    // print(_userId);
    // print(_questionTypeInt);
    // print(_difficultyLevel);

    final String apiUrl = "https://demo.pookidevs.com/quiz/generator/getQuestionCounts";
    http.post(Uri.parse(apiUrl), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    }, body: json.encode(
        {
          "data":
          {
            "subjects": subjectsEverything["finalTitles"],
            "systems": systemsEverything["finalTitles"],
            "topics": topicsEverything["finalTitles"],
            "userId": _userId, // Add _userId here.
            "statusLevels": _questionTypeInt, // Add _questionType here
            "difficultyLevels": _difficultyLevel, // Add _difficultyLevels here
          }
        })
    ).then((response) {
      if(response.statusCode == 200) {
        // print("getQuestionsCount() : " + response.body.toString());
        if(json.decode(response.body).toString().substring(0,20) == "{data: {status: true") {
          final responseString = (response.body);
          var QuestionsCountCategoriesSuccessful = getSystemCategoriesSuccessfulModelFromJson(responseString);
          final GetSystemCategoriesSuccessfulModel getQuestionsCountCategoriesSuccessful = QuestionsCountCategoriesSuccessful;
          setState(() {
            _getQuestionsCountCategoriesSuccessful = getQuestionsCountCategoriesSuccessful;
            _totalQuestions = _getQuestionsCountCategoriesSuccessful.data.totalQuestions;
            _questions = _getQuestionsCountCategoriesSuccessful.data.questions;
          });
          // print(_getSystemCategoriesSuccessful);
          print(_totalQuestions);
          print(_questions);
        } else {

        }
      } else {
        //Token is Invalid
        if(json.decode(response.body).toString().substring(0,14) == "{status: false") {
          final responseString = (response.body);
          var QuestionsCountCategoriesDataUnsuccessful = getSystemCategoriesUnsuccessfulModelFromJson(responseString);
          final GetSystemCategoriesUnsuccessfulModel getQuestionsCountCategoriesUnsuccessful = QuestionsCountCategoriesDataUnsuccessful;
          setState(() {
            _getQuestionsCountCategoriesUnsuccessful = getQuestionsCountCategoriesUnsuccessful;
          });
          print(_getQuestionsCountCategoriesUnsuccessful.msg);
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Token Expired!")));
          final result = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login(fromWhere:"Home")),
          );
        }
        else {

        }
      }
    });

  }

  //Add data to lists. Only done the first time.
  categorizeUserData() {
    //To clear any past data
    int c = 0;
    while((c<_getSystemCategoriesSuccessful.data.categories.toList().length) & (_getSystemCategoriesSuccessful.data.categories.toList().length > 0)) {
      var tempLength = _getSystemCategoriesSuccessful.data.categories.toList().length;
      if(_getSystemCategoriesSuccessful.data.categories[c].subCategories != null) {
        if(_getSystemCategoriesSuccessful.data.categories[c].parentCategory.toString() == "systems") {
          //Gets the length of subjects(Number of Subjects)
          var lenSystems = _getSystemCategoriesSuccessful.data.categories[c].subCategories.toList().length;
          int i = 0;
          setState(() {
            while((lenSystems>0) & (i<lenSystems)) {
              //Adding things to Systems
              systemsEverything["title"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].title.toString());
              systemsEverything["ID"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].id.toString());
              systemsEverything["questions"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].questions);
              systemsEverything["isSelected"]!.add(false);
              // print(systemsEverything);
              i++;
            }
          });
        }
      }
      // print(_getSystemCategoriesSuccessful.data.categories[0].parentCategory.toString());
      if(_getSystemCategoriesSuccessful.data.categories[c].subCategories != null) {
        if(_getSystemCategoriesSuccessful.data.categories[c].parentCategory.toString() == "subjects") {
          //Gets the length of subjects(Number of Subjects)
          var lenSubjects = _getSystemCategoriesSuccessful.data.categories[c].subCategories.toList().length;
          int i = 0;
          setState(() {
            while((lenSubjects>0) & (i<lenSubjects)) {
              subjectsEverything["title"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].title.toString());
              subjectsEverything["ID"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].id.toString());
              subjectsEverything["questions"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].questions);
              subjectsEverything["isSelected"]!.add(false);
              // print(subjectsEverything);
              i++;
            }
          });
        }
      }
      if(_getSystemCategoriesSuccessful.data.categories[c].subCategories != null) {
        if(_getSystemCategoriesSuccessful.data.categories[c].parentCategory.toString() == "topics") {
          //Gets the length of subjects(Number of Subjects)
          var lenTopics = _getSystemCategoriesSuccessful.data.categories[c].subCategories.toList().length;
          int i = 0;
          setState(() {
            while((lenTopics>0) & (i<lenTopics)) {
              topicsEverything["title"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].title.toString());
              topicsEverything["ID"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].id.toString());
              topicsEverything["questions"]!.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].questions);
              topicsEverything["isSelected"]!.add(false);
              // print(topicsEverything);
              i++;
            }
          });
        }
      }
      c++;
    }
      // Text(_getSystemCategoriesSuccessful.data.categories[0].subCategories[0].title.toString(),
  }

  // Question Types Buttons Logic
  void _questionTypesLogic(int i) {
    setState(() {
      if(_questionTypeSelectedBool[i] == false) {
        _questionTypeSelectedBool[i] = true;
        _questionTypeInt = i;
        _questionTypeSelectedBool[0] = false;
        for(int j = 1; j<7; j++) {
          if(j == i) {
            print("sda");
          }
          else {
            _questionTypeSelectedBool[j] = false;
          }
        }
      }

      else if(_questionTypeSelectedBool[i] == true) {
        _questionTypeSelectedBool[i] = false;
        _questionTypeSelectedBool[0] = true;
        _questionTypeInt = 0;
        for(int j = 1; j<7; j++) {
          if(j == i) {
            print("sda");
          }
          else {
            _questionTypeSelectedBool[j] = false;
          }
        }
      }
      print(_questionTypeInt);
      print(_questionTypeSelectedBool);
    });
  }

  //User goes to the next tab
  void _nextTab() {
    _tabController.animateTo((_tabController.index + 1) % 5);
  }

  //User goes back to the previous tab
  void _backTab() {
    _tabController.animateTo((_tabController.index - 1) % 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            child: SvgPicture.asset(
              "assets/Images/logout.svg",
              height: (MediaQuery.of(context).size.height) *(32/926),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
                          "assets/Images/create_quiz.svg",
                        height: (MediaQuery.of(context).size.height) *(100/926),
                        //width: (MediaQuery.of(context).size.width) *(132/428),
                      ),
                  ),
                ],
              ),
              SizedBox(height: (MediaQuery.of(context).size.height) *(25/926),),
              Container(
                // padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width) *(28/428), right: (MediaQuery.of(context).size.width) *(28/428)),
                height: (MediaQuery.of(context).size.height) *(35.32/926),
                width: double.infinity,
                // decoration: BoxDecoration(
                //   color: Color(0xff3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                // ),
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Color(0xFF3F2668),
                  labelStyle: TextStyle(
                    color: Color(0xFF3F2668),
                    fontFamily: 'Brandon-bld',
                    fontSize: (MediaQuery.of(context).size.height) *(16/926),
                  ),
                  indicator: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  indicatorColor: Color(0xFF3F2668),
                  unselectedLabelColor: Color(0xFFA1A1A1),
                  unselectedLabelStyle: TextStyle(
                    color: Color(0xFFA1A1A1),
                    fontFamily: 'Brandon-bld',
                    fontSize: (MediaQuery.of(context).size.height) *(16/926),
                  ),
                  labelPadding: EdgeInsets.only(top: (MediaQuery.of(context).size.height) *(0/926), bottom: (MediaQuery.of(context).size.height) *(0/926),
                  left: (MediaQuery.of(context).size.height) *(0/926), right: (MediaQuery.of(context).size.height) *(0/926)),
                  tabs: [
                    Container(
                        width: (MediaQuery.of(context).size.width) *(5.5/43),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Tab(text: "Subjects"),
                          ],
                        ),
                    ),
                    Container(
                        width: (MediaQuery.of(context).size.width) *(7.5/43),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.arrow_forward_ios,
                                size: (MediaQuery.of(context).size.width) *(15/428),),),
                            SizedBox(width: (MediaQuery.of(context).size.width) *(5/428)),
                            Tab(text: "Systems"),
                          ],
                        )
                    ),
                    Container(
                        width: (MediaQuery.of(context).size.width) *(6.5/43),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.arrow_forward_ios,
                                size: (MediaQuery.of(context).size.width) *(15/428),),),
                            SizedBox(width: (MediaQuery.of(context).size.width) *(5/428)),
                            Tab(text: "Topics"),
                          ],
                        )
                    ),
                    Container(
                        width: (MediaQuery.of(context).size.width) *(8.5/43),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.arrow_forward_ios,
                                size: (MediaQuery.of(context).size.width) *(15/428),),),
                            SizedBox(width: (MediaQuery.of(context).size.width) *(5/428)),
                            Tab(text: "Questions"),
                          ],
                        )
                    ),
                    Container(
                        width: (MediaQuery.of(context).size.width) *(10.5/43),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.arrow_forward_ios,
                                size: (MediaQuery.of(context).size.width) *(15/428),),),
                            SizedBox(width: (MediaQuery.of(context).size.width) *(5/428)),
                            Tab(text: "Generate Quiz"),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: (MediaQuery.of(context).size.height) *(13.28/926),),
              Container(
                height: (MediaQuery.of(context).size.height) *(596/926),
                width: double.infinity,
                child: TabBarView(
                  // physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    //Tab1: Subjects
                    Column(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height) *(40.32/926),
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          decoration: BoxDecoration(
                            color: Color(0xFF3F2668),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text("Select Subjects",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brandon-bld',
                                fontSize: (MediaQuery.of(context).size.height) *(26.31/926),//38,
                              ),),
                          ),
                        ),
                        SizedBox(height: (MediaQuery.of(context).size.height) *(33/926)),
                        Container(
                          width: (MediaQuery.of(context).size.width) *(386/428),
                            child: _hasDataLoaded == false ?
                            Container(height: (MediaQuery.of(context).size.height) *(460/926),child: Center(child: CircularProgressIndicator(color: Color(0xFF3F2668),)))
                                :
                            Container(
                              height: (MediaQuery.of(context).size.height) *(460/926),
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  Container(
                                      height: (MediaQuery.of(context).size.height) *(120.9/926),
                                      child: GridView(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: (MediaQuery.of(context).size.width) *(30/428),
                                          mainAxisExtent: (MediaQuery.of(context).size.height) *(40.224/926),),
                                        children: <Widget>[
                                          for(int i = 0; i<subjectsEverything["title"]!.length; i++)
                                            Container(
                                              color: subjectsEverything["isSelected"]![i] == true ? Color(0xFF3F2668) : Colors.white,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,),
                                                child: Text(subjectsEverything["title"]![i],
                                                  style: TextStyle(
                                                    color: subjectsEverything["isSelected"]![i] == true ? Colors.white : Color(0xFF3F3D56),
                                                    fontFamily: 'Brandon-med',
                                                    fontSize: (MediaQuery.of(context).size.height)*(19/926),
                                                  ),),
                                                onPressed: () {
                                                  setState(() {
                                                    if(subjectsEverything["isSelected"]![i] == false) {
                                                      subjectsEverything["isSelected"]![i] = true;

                                                      //This if statement is used becaseu this gives an error otherwise. = subjectsEverything["finalTitles"]!.add(subjectsEverything["title"]![i].toString());
                                                      if(subjectsEverything["finalTitles"] == null || subjectsEverything["finalTitles"] == []) {
                                                        print('addasdas');
                                                        subjectsEverything["finalTitles"] = [""];
                                                        subjectsEverything["finalTitles"]!.add(subjectsEverything["title"]![i].toString());
                                                        subjectsEverything["finalTitles"]!.removeAt(0);
                                                      }
                                                      else {
                                                        subjectsEverything["finalTitles"]!.add(subjectsEverything["title"]![i].toString());
                                                      }
                                                      // print(subjectsEverything["finalTitles"]);
                                                    }
                                                    else if(subjectsEverything["isSelected"]![i] == true) {
                                                      subjectsEverything["isSelected"]![i] = false;
                                                      subjectsEverything["finalTitles"]!.remove(subjectsEverything["title"]![i].toString());
                                                      // print(subjectsEverything["finalTitles"]);
                                                    }
                                                  });

                                                  int count = 0;
                                                  for(int j = 0; j<subjectsEverything["isSelected"]!.length; j++) {
                                                    if(subjectsEverything["isSelected"]![j] == true) {
                                                      setState(() {
                                                        count++;
                                                      });
                                                    }
                                                    else {
                                                      setState(() {
                                                        _systemsDisabled = true;
                                                      });
                                                    }
                                                  }

                                                  print(count);
                                                  if(count > 0) {
                                                    setState(() {
                                                      _systemsDisabled = false;
                                                    });
                                                  }

                                                  //Unchecking the previously checked boxes.
                                                  if(subjectsEverything["isSelected"]![i] == false) {
                                                    if(systemsEverything["isSelected"]!.length > 0) {
                                                      for(int i = 0; i<systemsEverything["isSelected"]!.length; i++) {
                                                        setState(() {
                                                          systemsEverything["isSelected"]![i] = false;
                                                          systemsEverything["finalTitles"] = [];
                                                        });
                                                      }
                                                    } // topicsEverything
                                                    if(topicsEverything["isSelected"]!.length > 0) {
                                                      for(int i = 0; i<topicsEverything["isSelected"]!.length; i++) {
                                                        setState(() {
                                                          topicsEverything["isSelected"]![i] = false;
                                                          topicsEverything["finalTitles"] = [];
                                                        });
                                                      }
                                                    }
                                                  }
                                                  // print(subjectsEverything["finalTitles"]);
                                                  // print(systemsEverything["finalTitles"]);
                                                  // print(topicsEverything["finalTitles"]);
                                                  getQuestionsCount();
                                                },
                                              ),
                                            ),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                        ),
                        SizedBox(height: (MediaQuery.of(context).size.height) *(10.74/926)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                    //Animates to next tab
                                    _nextTab();
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
                    //Tab 1 is complete.

                    //Tab2: Systems
                    Column(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height) *(40.32/926),
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          //color: Colors.red,
                          decoration: BoxDecoration(
                            color: Color(0xFF3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,//Color(0xff00000029),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text("Select Systems",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brandon-bld',
                                fontSize: (MediaQuery.of(context).size.height) *(26.31/926),//38,
                              ),),
                          ),
                        ),
                        SizedBox(height: (MediaQuery.of(context).size.height) *(33/926)),
                        Container(
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          child: Container(
                            height: (MediaQuery.of(context).size.height) *(460/926),
                            child: _hasDataLoaded == false ? Text("") : ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                Container(
                                    height: (MediaQuery.of(context).size.height) *(120.9/926),
                                    child: GridView(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: (MediaQuery.of(context).size.width) *(30/428),
                                        mainAxisExtent: (MediaQuery.of(context).size.height) *(40.224/926),),
                                      children: <Widget>[
                                        for(int i = 0; i<systemsEverything["title"]!.length; i++)
                                          Container(
                                            color: systemsEverything["isSelected"]![i] == true ? Color(0xFF3F2668) : Colors.white,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,),
                                              child: Text(systemsEverything["title"]![i],
                                                style: TextStyle(
                                                  color: systemsEverything["isSelected"]![i] == true ? Colors.white : Color(0xFF3F3D56),
                                                  fontFamily: 'Brandon-med',
                                                  fontSize: (MediaQuery.of(context).size.height)*(19/926),
                                                ),),
                                              onPressed: () {
                                                if(_systemsDisabled == false) {
                                                  setState(() {
                                                    if(systemsEverything["isSelected"]![i] == false) {
                                                      systemsEverything["isSelected"]![i] = true;

                                                      //This if statement is used becaseu this gives an error otherwise. = subjectsEverything["finalTitles"]!.add(subjectsEverything["title"]![i].toString());
                                                      if(systemsEverything["finalTitles"] == null || systemsEverything["finalTitles"] == []) {
                                                        print('addasdas');
                                                        systemsEverything["finalTitles"] = [""];
                                                        systemsEverything["finalTitles"]!.add(systemsEverything["title"]![i].toString());
                                                        systemsEverything["finalTitles"]!.removeAt(0);
                                                      }
                                                      else {
                                                        systemsEverything["finalTitles"]!.add(systemsEverything["title"]![i].toString());
                                                      }
                                                    }
                                                    else if(systemsEverything["isSelected"]![i] == true) {
                                                      systemsEverything["isSelected"]![i] = false;
                                                      systemsEverything["finalTitles"]!.remove(systemsEverything["title"]![i].toString());
                                                    }
                                                  });

                                                  int countTopic = 0;
                                                  for(int j = 0; j<systemsEverything["isSelected"]!.length; j++) {
                                                    if(systemsEverything["isSelected"]![j] == true) {
                                                      setState(() {
                                                        countTopic++;
                                                      });
                                                    }
                                                    else {
                                                      setState(() {
                                                        _topicsDisabled = true;
                                                      });
                                                    }
                                                  }

                                                  if(countTopic > 0) {
                                                    setState(() {
                                                      _topicsDisabled = false;
                                                    });
                                                  }

                                                  //Unchecking the previously checked boxes.
                                                  if(systemsEverything["isSelected"]![i] == false) {
                                                    // topicsEverything
                                                    if(topicsEverything["isSelected"]!.length > 0) {
                                                      for(int i = 0; i<topicsEverything["isSelected"]!.length; i++) {
                                                        setState(() {
                                                          topicsEverything["isSelected"]![i] = false;
                                                          topicsEverything["finalTitles"] = [];
                                                        });
                                                      }
                                                    }
                                                  }
                                                  // print(subjectsEverything["finalTitles"]);
                                                  // print(systemsEverything["finalTitles"]);
                                                  // print(topicsEverything["finalTitles"]);
                                                  getQuestionsCount();
                                                }
                                                else {
                                                  ScaffoldMessenger.of(context)
                                                    ..removeCurrentSnackBar()
                                                    ..showSnackBar(SnackBar(content: Text("Select Subjects First!")));
                                                }
                                              },
                                            ),
                                          ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
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
                                    //Animates to next tab
                                    _backTab();
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
                                  onPressed: () {
                                    //Animates to next tab
                                    _nextTab();
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

                    //Tab3: Topics
                    Column(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height) *(40.32/926),
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          //color: Colors.red,
                          decoration: BoxDecoration(
                            color: Color(0xFF3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,//Color(0xff00000029),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text("Select Topics",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brandon-bld',
                                fontSize: (MediaQuery.of(context).size.height) *(26.31/926),//38,
                              ),),
                          ),
                        ),
                        SizedBox(height: (MediaQuery.of(context).size.height) *(33/926)),
                        Container(
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          child: Container(
                            height: (MediaQuery.of(context).size.height) *(460/926),
                            child: _hasDataLoaded == false ? Text("") : ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                Container(
                                    height: (MediaQuery.of(context).size.height) *(120.9/926),
                                    child: GridView(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: (MediaQuery.of(context).size.width) *(30/428),
                                        mainAxisExtent: (MediaQuery.of(context).size.height) *(40.224/926),),
                                      children: <Widget>[
                                        for(int i = 0; i<topicsEverything["title"]!.length; i++)
                                          Container(
                                            color: topicsEverything["isSelected"]![i] == true ? Color(0xFF3F2668) : Colors.white,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,),
                                              child: Text(topicsEverything["title"]![i],
                                                style: TextStyle(
                                                  color: topicsEverything["isSelected"]![i] == true ? Colors.white : Color(0xFF3F3D56),
                                                  fontFamily: 'Brandon-med',
                                                  fontSize: (MediaQuery.of(context).size.height)*(19/926),
                                                ),),
                                              onPressed: () {
                                                if((_systemsDisabled == false) & (_topicsDisabled == false)) {
                                                  setState(() {
                                                    if(topicsEverything["isSelected"]![i] == false) {
                                                      topicsEverything["isSelected"]![i] = true;

                                                      //This if statement is used becaseu this gives an error otherwise. = subjectsEverything["finalTitles"]!.add(subjectsEverything["title"]![i].toString());
                                                      if(topicsEverything["finalTitles"] == null || topicsEverything["finalTitles"] == []) {
                                                        print('addasdas');
                                                        topicsEverything["finalTitles"] = [""];
                                                        topicsEverything["finalTitles"]!.add(topicsEverything["title"]![i].toString());
                                                        topicsEverything["finalTitles"]!.removeAt(0);
                                                      }
                                                      else {
                                                        topicsEverything["finalTitles"]!.add(topicsEverything["title"]![i].toString());
                                                      }
                                                    }
                                                    else if(topicsEverything["isSelected"]![i] == true) {
                                                      topicsEverything["isSelected"]![i] = false;
                                                      topicsEverything["finalTitles"]!.remove(topicsEverything["title"]![i].toString());
                                                    }
                                                  });
                                                }
                                                else {
                                                  ScaffoldMessenger.of(context)
                                                    ..removeCurrentSnackBar()
                                                    ..showSnackBar(SnackBar(content: Text("Select Systems First!")));
                                                }
                                                // print(subjectsEverything["finalTitles"]);
                                                // print(systemsEverything["finalTitles"]);
                                                // print(topicsEverything["finalTitles"]);
                                                getQuestionsCount();
                                              },
                                            ),
                                          ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
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
                                    //Animates to next tab
                                    _backTab();
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
                                  onPressed: () {
                                    //Animates to next tab
                                    _nextTab();
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

                    //Tab4: Question Types
                    Column(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height) *(40.32/926),
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          //color: Colors.red,
                          decoration: BoxDecoration(
                            color: Color(0xFF3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,//Color(0xff00000029),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text("Select Question Types",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brandon-bld',
                                fontSize: (MediaQuery.of(context).size.height) *(26.31/926),//38,
                              ),),
                          ),
                        ),
                        SizedBox(height: (MediaQuery.of(context).size.height) *(33/926)),
                        Container(
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          height: (MediaQuery.of(context).size.height) *(460/926),
                          child: Column(
                            children: [
                              for(int i = 1; i<7; i++)
                                Column(
                                  children: [
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: (MediaQuery.of(context).size.height) *(40.224/926),
                                        width: (MediaQuery.of(context).size.width) *(312/428),
                                        color: _questionTypeSelectedBool[i] == false ? Colors.white : Color(0xFF3F2668),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,),
                                          child: Text(_questionTypesTitle[i],
                                            style: TextStyle(
                                              color: _questionTypeSelectedBool[i] == false ? Color(0xFF3F3D56) : Colors.white,
                                              fontFamily: 'Brandon-med',
                                              fontSize: (MediaQuery.of(context).size.height)*(19/926),
                                            ),),
                                          onPressed: () {
                                            _questionTypesLogic(i);
                                            getQuestionsCount();
                                          },
                                        ),
                                      ),
                                      _questionTypeSelectedBool[i] == false ?
                                      GestureDetector(
                                        onTap: () {
                                          _questionTypesLogic(i);
                                          getQuestionsCount();
                                        },
                                        child: Container(
                                          height: (MediaQuery.of(context).size.height) *(34.224/926),
                                          width: (MediaQuery.of(context).size.width) *(29.224/428),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 9, color: Color(0xFFA1A1A1)),
                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                          ),
                                        ),
                                      )
                                          :
                                      GestureDetector(
                                        onTap: () {
                                          _questionTypesLogic(i);
                                          getQuestionsCount();
                                        },
                                            child: Container(
                                              child: Icon(Icons.check,
                                              size: (MediaQuery.of(context).size.height) *(34.224/926),
                                              color: Color(0xFF3F2668),)
                                            ),
                                          ),
                                    ],
                                    ),
                                    SizedBox(height: (MediaQuery.of(context).size.height) *(25.224/926)),
                                  ],
                                ),
                            ],
                          ),
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
                                    //Animates to next tab
                                    _backTab();
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
                                  onPressed: () {
                                    //Animates to next tab
                                    _nextTab();
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

                    //Tab5: Generate Quiz
                    Column(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height) *(40.32/926),
                          width: (MediaQuery.of(context).size.width) *(386/428),
                          //color: Colors.red,
                          decoration: BoxDecoration(
                            color: Color(0xFF3F2668),//0xffB0A6C2, rgba(176, 166, 194, 1)
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,//Color(0xff00000029),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text("Generate Quiz",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brandon-bld',
                                fontSize: (MediaQuery.of(context).size.height) *(26.31/926),//38,
                              ),),
                          ),
                        ),
                        SizedBox(height: (MediaQuery.of(context).size.height) *(22.8/926)),
                        Container(
                          width: (MediaQuery.of(context).size.width) *(386/428), // 460/926
                          height: (MediaQuery.of(context).size.height) *(460/926),
                          child: Column(
                            children: [
                              Center(
                                child: Text("Set Difficulty Level",
                                  style: TextStyle(
                                    color: Color(0xFF232323),
                                    fontFamily: 'Brandon-med',
                                    fontSize: (MediaQuery.of(context).size.height) *(16/926),
                                  ),
                                ),
                              ),
                              SizedBox(height: (MediaQuery.of(context).size.height) *(26.59/926),),
                              Row(
                                children: [
                                  for(int i = 1; i<6; i++)
                                    Row(
                                      children: [
                                        Container(
                                        height: (MediaQuery.of(context).size.height) *(40.224/926),
                                        width: (MediaQuery.of(context).size.width) *((60)/428),
                                        color: _difficultyLevelBool[i-1] == false ? Color(0xFFE4E4E4) : Color(0xFF7F1AF1),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,),
                                          child: Text(_difficultyLevelTitle[i-1],
                                            style: TextStyle(
                                              color: _difficultyLevelBool[i-1] == false ? Color(0xFF3F2668) : Colors.white,
                                              fontFamily: 'Brandon-med',
                                              fontSize: (MediaQuery.of(context).size.height)*(13/926),
                                            ),),
                                          onPressed: () {
                                            setState(() {
                                              if(_difficultyLevelBool[i-1] == false) {
                                                _difficultyLevelBool[i-1] = true;
                                                _difficultyLevel.add(i);
                                              }
                                              else if(_difficultyLevelBool[i-1] == true) {
                                                _difficultyLevelBool[i-1] = false;
                                                _difficultyLevel.remove(i);
                                              }
                                            });
                                            getQuestionsCount();
                                          },
                                        ),
                                  ),
                                        if(i != 5)
                                          // SizedBox(width: (MediaQuery.of(context).size.width) *(46/926)),
                                          for(int j = 0; j<6; j++)
                                            Row(
                                              children: [
                                                Container(
                                                child: Container(
                                                  height: (MediaQuery.of(context).size.height) *(2/926),
                                                  width: (MediaQuery.of(context).size.width) *(3.55/428),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFE4E4E4),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                          ),
                                              ],
                                            )
                                      ],
                                    ),
                                ],
                              ),
                              SizedBox(height: (MediaQuery.of(context).size.height) *(48/926),),
                              Center(
                                child: Text("Generate Quiz",
                                  style: TextStyle(
                                    color: Color(0xFF232323),
                                    fontFamily: 'Brandon-med',
                                    fontSize: (MediaQuery.of(context).size.height) *(16/926),
                                  ),
                                ),
                              ),
                              SizedBox(height: (MediaQuery.of(context).size.height) *(28/926),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          height: (MediaQuery.of(context).size.height) *(30/926),
                                          width: (MediaQuery.of(context).size.width) *(98/428),
                                          padding: EdgeInsets.zero,
                                          margin: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: _tutorMode? Color(0xff3F2668) : Colors.white,
                                            border: Border.all(color: Color(0xff3F2668)),
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                                          ),
                                          //color: Colors.red,
                                          child: InkWell(
                                            onTap: () {
                                              if(_tutorMode == false) {
                                                setState(() {
                                                  _tutorMode = true;
                                                });
                                              }
                                            },
                                            child: Center(
                                              child: Text("Tutor Mode",
                                                style: TextStyle(
                                                    color: _tutorMode? Colors.white : Color(0xff3F2668),
                                                    fontFamily: 'Brandon-med',
                                                    fontSize: (MediaQuery.of(context).size.height) *(15/926)
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      Container(
                                          height: (MediaQuery.of(context).size.height) *(30/926),
                                          width: (MediaQuery.of(context).size.width) *(98/428),
                                          padding: EdgeInsets.zero,
                                          margin: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: _tutorMode? Colors.white : Color(0xff3F2668),
                                            border: Border.all(color: Color(0xff3F2668)),
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                                          ),
                                          //color: Colors.red,
                                          child: InkWell(
                                            onTap: () {
                                              if(_tutorMode == true) {
                                                setState(() {
                                                  _tutorMode = false;
                                                });
                                              }
                                            },
                                            child: Center(
                                              child: Text("Exam Mode",
                                                style: TextStyle(
                                                    color: _tutorMode? Color(0xff3F2668) : Colors.white,
                                                    fontFamily: 'Brandon-med',
                                                    fontSize: (MediaQuery.of(context).size.height) *(15/926)
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 0.82,
                                        child: Container(
                                          height: (MediaQuery.of(context).size.height) *(20/926),
                                          child: Switch(
                                            value: _timedMode,
                                            onChanged: (value) {
                                              setState(() {
                                                _timedMode = value;
                                                print(_timedMode);
                                              });
                                            },
                                            activeColor: Color(0xff3F2668),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text("Timed Mode",
                                          style: TextStyle(
                                              color: Color(0xff483A3A),
                                              fontFamily: 'Brandon-med',
                                              fontSize: (MediaQuery.of(context).size.height) *(13/926)
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: (MediaQuery.of(context).size.width) *(10/428)),

                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: (MediaQuery.of(context).size.height) *(40/926)),
                              Container(
                                padding: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height) *(15/926)),
                                child: Row(
                                  children: [
                                    Text("Enter The Number Of Questions: ",
                                      style: TextStyle(
                                          color: Color(0xff3F3D56),
                                          fontFamily: 'Brandon-med',
                                          fontSize: (MediaQuery.of(context).size.height) *(15/926)
                                      ),
                                    ),
                                    Container(
                                      height: (MediaQuery.of(context).size.height) *(24/926),
                                      width: (MediaQuery.of(context).size.width) *(40.01/428),
                                      color: Colors.white,
                                      child: Form(
                                        key: _numberOfQuestionsKey,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly
                                          ], // Only numbers can be entered
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "4",
                                            hintStyle: TextStyle(color: Color(0xffAEAEAE),
                                              fontSize: (MediaQuery.of(context).size.height)*(15/926),
                                              fontFamily: 'Brandon-med',),
                                            contentPadding: EdgeInsets.fromLTRB(2.0, 1, 2.0, 1),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF7070709E),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(3.0),
                                            ),
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
                                          onChanged: (val) {
                                            final number = num.tryParse(val);
                                            if(number != null) {
                                              var totalQuestions;
                                              try {
                                                totalQuestions = _totalQuestions;
                                              } catch (error) {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(SnackBar(content: Text("Error")));
                                              }
                                              if((int.parse(val)>totalQuestions) || (int.parse(val)>=40)) {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(SnackBar(content: Text("Enter a smaller number")));
                                                setState(() {
                                                  _questionsCount = 0;
                                                });
                                              }
                                              else{
                                                setState(() {
                                                  _questionsCount = int.parse(val);
                                                });
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Text("  /" + _totalQuestions.toString(),
                                    style: TextStyle(
                                      color: Color(0xFF98A4A4),
                                      fontSize: (MediaQuery.of(context).size.height)*(15/926),
                                      fontFamily: 'Brandon-med',
                                    ),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: (MediaQuery.of(context).size.height) *(21/926),),

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
                                    //Animates to next tab
                                    _backTab();
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
                                width: (MediaQuery.of(context).size.width) *(100/428),
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
                                    print("adsdsa");
                                    // print(num.tryParse(_questionsCount));
                                    if(_questionsCount > 0) {
                                      final result = Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => QuizModule(totalQuestions: _questionsCount, questions: _questions)),
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Text("Create Quiz",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}