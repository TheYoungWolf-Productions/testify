
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/models/GenerateQuizModels/get_system_categories_successful.dart';
import 'package:testify/models/GenerateQuizModels/get_system_categories_unsuccessful.dart';
import 'package:testify/models/GetPreviousQuizzesModel/get_previous_quizzes_model.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/test_details.dart';
import 'package:testify/screens/Welcome/PreviousQuiz/tile.dart';
import '../side_menu_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreviousQuiz extends StatefulWidget {
  @override
  _PreviousQuizState createState() => _PreviousQuizState();
}

class _PreviousQuizState extends State<PreviousQuiz> {
  final filterList=['Filter By','Subjects','Systems','Topics'];
  int filterIndex = 0;
  String _currentfilter='Filter By';
  String _currentsubfilter='Filter By';
  int subFilterIndex = 0;
  List<String> subFilterList=['option1','option2'];
  List<String> subjectsSubFilterList = ["Select"];
  List<String> systemsSubFilterList = ["Select"];
  List<String> topicsSubFilterList = ["Select"];
  List<String> filterSubFilterSelected = ["",""]; // 0: Filter, 1: SubFilter.
  double? _swipeStartX;
  String? _swipeDirection;

  bool hasPreviousQuizzesDataLoaded = false;
  var previousQuizzesData = {
    "quizId": [],
    "name": [],
    "score": [],
    "date": [],
    "status": [],
    "questions": [],
    "totalQuestions": [],
    "subjects": [],
    "systems": [],
    "topics": [],
  };

  var previousQuizzesDataFiltered = {
    "quizId": [],
    "name": [],
    "score": [],
    "date": [],
    "status": [],
    "questions": [],
    "totalQuestions": [],
    "subjects": [],
    "systems": [],
    "topics": [],
  };

  //Shared Pref
  var _token;
  var _userId;

  // Token Valid
  var _getSystemCategoriesSuccessful;
  // Token Incorrect
  var _getSystemCategoriesUnsuccessful;

  //Get Previous Quizzes
  var _getPreviousQuizzesSuccessful;

  @override
  void initState() {
    super.initState();
    getPreviousQuizzes();
    getUserDataSST();
  }

  Future<void> getPreviousQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrlSystemCategories = "https://demo.pookidevs.com/quiz/generator/getPreviousQuizzes";
    _token = prefs.getString('token')!;
    _userId = prefs.getInt("userId")!;
    http.get(Uri.parse(apiUrlSystemCategories), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8', 'Authorization' : _token.toString(),
    },).then((response) {
      // print(jsonDecode(response.body));
      if(response.statusCode == 200) {
        if(json.decode(response.body).toString().substring(0,20) == "{data: {status: true"){
          final responseString = (response.body);
          var getPrevQuiz = getPreviousQuizzesModelFromJson(responseString);
          final GetPreviousQuizzesModel getPreviousQuizzesSuccessful = getPrevQuiz;
          setState(() {
            _getPreviousQuizzesSuccessful = getPreviousQuizzesSuccessful;
          });
          // print(_getPreviousQuizzesSuccessful.data.quizzes[0].quizId);
          categorizePreviousQuizzesData();
        }
      }
      else {
        //Token is Invalid
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Token Expired!")));
        final result = Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login(fromWhere:"Home")),
        );
      }
    }
    );
  }

  categorizePreviousQuizzesData() {
    int c = 0;
    while((c<_getPreviousQuizzesSuccessful.data.quizzes.toList().length) & (_getPreviousQuizzesSuccessful.data.quizzes.toList().length > 0)) {
      setState(() {
        previousQuizzesData["quizId"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].quizId);
        previousQuizzesData["name"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].name);
        previousQuizzesData["score"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].score);
        previousQuizzesData["date"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].date);
        previousQuizzesData["status"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].status);
        previousQuizzesData["questions"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].questions);
        previousQuizzesData["totalQuestions"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].totalQuestions);
        previousQuizzesData["subjects"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].subjects);
        previousQuizzesData["systems"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].systems);
        previousQuizzesData["topics"]!.add(_getPreviousQuizzesSuccessful.data.quizzes[c].topics);
      });
      c++;
    }
    setState(() {
      hasPreviousQuizzesDataLoaded = true;
    });
    // print(previousQuizzesData);
  }

  applyingPreviousQuizzesFilters() {
    setState(() {
      previousQuizzesDataFiltered["quizId"] = [];
      previousQuizzesDataFiltered["name"] = [];
      previousQuizzesDataFiltered["score"] = [];
      previousQuizzesDataFiltered["date"] = [];
      previousQuizzesDataFiltered["status"] = [];
      previousQuizzesDataFiltered["questions"] = [];
      previousQuizzesDataFiltered["totalQuestions"] = [];
      previousQuizzesDataFiltered["subjects"] = [];
      previousQuizzesDataFiltered["systems"] = [];
      previousQuizzesDataFiltered["topics"] = [];
    });
    if(filterSubFilterSelected[0] == "Subjects") {
      for(int j = 0; j<previousQuizzesData["subjects"]!.length; j++) {
        for(int k = 0; k<previousQuizzesData["subjects"]![j].length; k++) {
          if(filterSubFilterSelected[1] == previousQuizzesData["subjects"]![j][k]) {
            setState(() {
              previousQuizzesDataFiltered["quizId"]!.add(previousQuizzesData["quizId"]![j]);
              previousQuizzesDataFiltered["name"]!.add(previousQuizzesData["name"]![j]);
              previousQuizzesDataFiltered["score"]!.add(previousQuizzesData["score"]![j]);
              previousQuizzesDataFiltered["date"]!.add(previousQuizzesData["date"]![j]);
              previousQuizzesDataFiltered["status"]!.add(previousQuizzesData["status"]![j]);
              previousQuizzesDataFiltered["questions"]!.add(previousQuizzesData["questions"]![j]);
              previousQuizzesDataFiltered["totalQuestions"]!.add(previousQuizzesData["totalQuestions"]![j]);
              previousQuizzesDataFiltered["subjects"]!.add(previousQuizzesData["subjects"]![j]);
              previousQuizzesDataFiltered["systems"]!.add(previousQuizzesData["systems"]![j]);
              previousQuizzesDataFiltered["topics"]!.add(previousQuizzesData["topics"]![j]);
            });
          }
        }
      }
    }
    else if(filterSubFilterSelected[0] == "Systems") {
      for(int j = 0; j<previousQuizzesData["systems"]!.length; j++) {
        for(int k = 0; k<previousQuizzesData["systems"]![j].length; k++) {
          if(filterSubFilterSelected[1] == previousQuizzesData["systems"]![j][k]) {
            setState(() {
              previousQuizzesDataFiltered["quizId"]!.add(previousQuizzesData["quizId"]![j]);
              previousQuizzesDataFiltered["name"]!.add(previousQuizzesData["name"]![j]);
              previousQuizzesDataFiltered["score"]!.add(previousQuizzesData["score"]![j]);
              previousQuizzesDataFiltered["date"]!.add(previousQuizzesData["date"]![j]);
              previousQuizzesDataFiltered["status"]!.add(previousQuizzesData["status"]![j]);
              previousQuizzesDataFiltered["questions"]!.add(previousQuizzesData["questions"]![j]);
              previousQuizzesDataFiltered["totalQuestions"]!.add(previousQuizzesData["totalQuestions"]![j]);
              previousQuizzesDataFiltered["subjects"]!.add(previousQuizzesData["subjects"]![j]);
              previousQuizzesDataFiltered["systems"]!.add(previousQuizzesData["systems"]![j]);
              previousQuizzesDataFiltered["topics"]!.add(previousQuizzesData["topics"]![j]);
            });
          }
        }
      }
    }
    else if(filterSubFilterSelected[0] == "Topics") {
      for(int j = 0; j<previousQuizzesData["topics"]!.length; j++) {
        for(int k = 0; k<previousQuizzesData["topics"]![j].length; k++) {
          if(filterSubFilterSelected[1] == previousQuizzesData["topics"]![j][k]) {
            setState(() {
              previousQuizzesDataFiltered["quizId"]!.add(previousQuizzesData["quizId"]![j]);
              previousQuizzesDataFiltered["name"]!.add(previousQuizzesData["name"]![j]);
              previousQuizzesDataFiltered["score"]!.add(previousQuizzesData["score"]![j]);
              previousQuizzesDataFiltered["date"]!.add(previousQuizzesData["date"]![j]);
              previousQuizzesDataFiltered["status"]!.add(previousQuizzesData["status"]![j]);
              previousQuizzesDataFiltered["questions"]!.add(previousQuizzesData["questions"]![j]);
              previousQuizzesDataFiltered["totalQuestions"]!.add(previousQuizzesData["totalQuestions"]![j]);
              previousQuizzesDataFiltered["subjects"]!.add(previousQuizzesData["subjects"]![j]);
              previousQuizzesDataFiltered["systems"]!.add(previousQuizzesData["systems"]![j]);
              previousQuizzesDataFiltered["topics"]!.add(previousQuizzesData["topics"]![j]);
            });
          }
        }
      }
    }
    else {
      // categorizePreviousQuizzesData();
    }
    // print(previousQuizzesDataFiltered);
  }

  Future<void> getUserDataSST() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrlSystemCategories = "https://demo.pookidevs.com/quiz/generator/getAllCategories";
    _token = prefs.getString('token')!;
    _userId = prefs.getInt("userId")!;
    // print(_userId);
    // print(_token);
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
              systemsSubFilterList.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].title.toString());
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
              subjectsSubFilterList.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].title.toString());
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
              topicsSubFilterList.add(_getSystemCategoriesSuccessful.data.categories[c].subCategories[i].title.toString());
              i++;
            }
          });
        }
      }
      c++;
    }
    print(subjectsSubFilterList);
    print(systemsSubFilterList);
    print(topicsSubFilterList);
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
        title: const Text("Previous Quiz",
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
                          child: Text("Previous Quiz",
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
                      "assets/Images/prevQuiz.svg",
                      height: (MediaQuery.of(context).size.height) *(100/926),
                      //width: (MediaQuery.of(context).size.width) *(132/428),
                    ),
                  ),
                ],
              ),
              SizedBox(height: (MediaQuery.of(context).size.height)*(30/926),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Filter By:  ",
                        style: TextStyle(
                          color: Color(0xFF483A3A),
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) *(16/926),//38,
                        ),),
                      DropdownButton(
                        value: filterList[filterIndex],
                        underline: Container(),
                        iconEnabledColor: Color(0xff3F2668),
                        dropdownColor:Colors.white ,
                        onChanged: (newValue) {
                          setState(() {
                            // print(newValue);
                            _currentfilter = newValue as String;
                            if(_currentfilter == filterList[1]){
                              filterIndex = 1;
                              subFilterIndex = 0;
                              subFilterList = subjectsSubFilterList;}
                            else if(_currentfilter == filterList[2]){
                              filterIndex = 2;
                              subFilterIndex = 0;
                              subFilterList = systemsSubFilterList;}
                            else if(_currentfilter == filterList[3]){
                              filterIndex = 3;
                              subFilterIndex = 0;
                              subFilterList = topicsSubFilterList;}
                            else if(_currentfilter == filterList[0]){
                              filterIndex = 0;
                              subFilterIndex = 0;}
                            filterSubFilterSelected[0] = _currentfilter;
                            applyingPreviousQuizzesFilters();
                            // print(filterSubFilterSelected);
                          });
                        },
                        items: filterList.map((filter){
                          return DropdownMenuItem(
                            child: Text(filter,style: TextStyle(
                              color: Color(0xff3F2668),
                              fontFamily: 'Brandon-bld',
                              fontSize:
                              (MediaQuery.of(context).size.height) * (16 / 926),
                            ),),
                            value: filter,
                          );
                        }).toList(),


                      ),
                    ],
                  ),
                  // This below row is just for the if statement
                  if(_currentfilter != "Filter By")
                    Row(
                    children: [
                      //SizedBox(width: (MediaQuery.of(context).size.width)*(40/428),),
                      Text(_currentfilter + ":  ",
                        style: TextStyle(
                          color: Color(0xFF483A3A),
                          fontFamily: 'Brandon-med',
                          fontSize: (MediaQuery.of(context).size.height) *(16/926),//38,
                        ),),
                      DropdownButton(
                        value: (subFilterList.length<(subFilterIndex+1)) ? subFilterList[0] : subFilterList[subFilterIndex],
                        underline: Container(),
                        iconEnabledColor: Color(0xff3F2668),
                        dropdownColor:Colors.white ,
                        onChanged: (newValue) {
                          setState(() {
                            // print(newValue);
                            subFilterIndex = 0;
                            _currentsubfilter = newValue as String;
                            for(int i = 0; i<subFilterList.length; i++){
                              if(subFilterList[i] == _currentsubfilter){
                                subFilterIndex = i;
                                filterSubFilterSelected[1] = _currentsubfilter;
                                applyingPreviousQuizzesFilters();
                                // print(filterSubFilterSelected);
                              }
                            }
                          });
                        },
                        items: subFilterList.map((filter){
                          return DropdownMenuItem(
                            child: Text(filter,style: TextStyle(
                              color: Color(0xff3F2668),
                              fontFamily: 'Brandon-bld',
                              fontSize:
                              (MediaQuery.of(context).size.height) * (16 / 926),
                            ),),
                            value: filter,
                          );
                        }).toList(),


                      ),
                    ],
                  ),
                ],

              ),
              if(hasPreviousQuizzesDataLoaded == false)
                CircularProgressIndicator(color: Color(0xff3F2668),),
              if(hasPreviousQuizzesDataLoaded == true)
                for(int i = 0; i<(subFilterIndex != 0 ? previousQuizzesDataFiltered["quizId"]!.length : previousQuizzesData["quizId"]!.length); i++)
                  subFilterIndex != 0 ? Column(
                children: [
                  SizedBox(height: (MediaQuery.of(context).size.height)*(30/926),),
                  GestureDetector(child: Tile(
                    name: previousQuizzesDataFiltered["name"]![i],
                    quizId: previousQuizzesDataFiltered["quizId"]![i],
                    status: previousQuizzesDataFiltered["status"]![i],
                    score: previousQuizzesDataFiltered["score"]![i],
                    systems: previousQuizzesDataFiltered["systems"]![i],
                    questions: previousQuizzesDataFiltered["questions"]![i],
                    date: previousQuizzesDataFiltered["date"]![i],
                    topics: previousQuizzesDataFiltered["topics"]![i],
                    subjects: previousQuizzesDataFiltered["subjects"]![i],
                    totalQuestions: previousQuizzesDataFiltered["totalQuestions"]![i],),
                    onHorizontalDragStart: (e) {
                      _swipeStartX = e.globalPosition.dx;
                    },
                    onHorizontalDragUpdate: (e) {
                      _swipeDirection =
                      (e.globalPosition.dx > _swipeStartX!) ? "Right" : "Left";
                    },
                    onHorizontalDragEnd: (e) async {
                      if (_swipeDirection == "Right")
                        print("left");
                      else if (_swipeDirection == "Left") {
                        print(previousQuizzesDataFiltered["system"]![i].toString());
                        // final result = await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => TestDetails(
                        //             quizId: previousQuizzesData["quizId"]![i],
                        //             system: previousQuizzesData["system"]![i],
                        //             subject: previousQuizzesData["subject"]![i],
                        //             topic: previousQuizzesData["topic"]![i],
                        //             score: previousQuizzesData["score"]![i],
                        //             status: previousQuizzesData["status"]![i])));
                      }
                    },),
                ],
              ) :
                  Column(
                    children: [
                      SizedBox(height: (MediaQuery.of(context).size.height)*(30/926),),
                      GestureDetector(child: Tile(
                        name: previousQuizzesData["name"]![i],
                        quizId: previousQuizzesData["quizId"]![i],
                        status: previousQuizzesData["status"]![i],
                        score: previousQuizzesData["score"]![i],
                        systems: previousQuizzesData["systems"]![i],
                        questions: previousQuizzesData["questions"]![i],
                        date: previousQuizzesData["date"]![i],
                        topics: previousQuizzesData["topics"]![i],
                        subjects: previousQuizzesData["subjects"]![i],
                        totalQuestions: previousQuizzesData["totalQuestions"]![i],),
                        onHorizontalDragStart: (e) {
                          _swipeStartX = e.globalPosition.dx;
                        },
                        onHorizontalDragUpdate: (e) {
                          _swipeDirection =
                          (e.globalPosition.dx > _swipeStartX!) ? "Right" : "Left";
                        },
                        onHorizontalDragEnd: (e) async {
                          if (_swipeDirection == "Right")
                            print("left");
                          else if (_swipeDirection == "Left") {
                            print(previousQuizzesData["system"]![i].toString());
                            // final result = await Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => TestDetails(
                            //             quizId: previousQuizzesData["quizId"]![i],
                            //             system: previousQuizzesData["system"]![i],
                            //             subject: previousQuizzesData["subject"]![i],
                            //             topic: previousQuizzesData["topic"]![i],
                            //             score: previousQuizzesData["score"]![i],
                            //             status: previousQuizzesData["status"]![i])));
                          }
                        },),
                    ],
                  ),
              SizedBox(height: (MediaQuery.of(context).size.height)*(30/926),),

            ],
          ),
        ),
      ),
    );
  }
}
