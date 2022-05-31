// To parse this JSON data, do
//
//     final testAnalysisModel = testAnalysisModelFromJson(jsonString);

import 'dart:convert';

TestAnalysisModel testAnalysisModelFromJson(String str) => TestAnalysisModel.fromJson(json.decode(str));

String testAnalysisModelToJson(TestAnalysisModel data) => json.encode(data.toJson());

class TestAnalysisModel {
  TestAnalysisModel({
    required this.data,
  });

  Data data;

  factory TestAnalysisModel.fromJson(Map<String, dynamic> json) => TestAnalysisModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.bestSubject,
    required this.worstSubject,
    required this.timeTaken,
    required this.totalQuestionsAnswered,
    required this.totalCorrect,
    required this.totalIncorrect,
    required this.totalOmitted,
    required this.totalCorrectToCorrect,
    required this.totalCorrectToIncorrect,
    required this.totalIncorrectToCorrect,
    required this.totalIncorrectToIncorrect,
    required this.subjects,
    required this.systems,
    required this.topics,
  });

  bool status;
  String bestSubject;
  String worstSubject;
  String timeTaken;
  int totalQuestionsAnswered;
  int totalCorrect;
  int totalIncorrect;
  int totalOmitted;
  int totalCorrectToCorrect;
  int totalCorrectToIncorrect;
  int totalIncorrectToCorrect;
  int totalIncorrectToIncorrect;
  List<Subject> subjects;
  List<Subject> systems;
  List<Subject> topics;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    bestSubject: json["bestSubject"],
    worstSubject: json["worstSubject"],
    timeTaken: json["timeTaken"],
    totalQuestionsAnswered: json["totalQuestionsAnswered"],
    totalCorrect: json["totalCorrect"],
    totalIncorrect: json["totalIncorrect"],
    totalOmitted: json["totalOmitted"],
    totalCorrectToCorrect: json["totalCorrectToCorrect"],
    totalCorrectToIncorrect: json["totalCorrectToIncorrect"],
    totalIncorrectToCorrect: json["totalIncorrectToCorrect"],
    totalIncorrectToIncorrect: json["totalIncorrectToIncorrect"],
    subjects: List<Subject>.from(json["subjects"].map((x) => Subject.fromJson(x))),
    systems: List<Subject>.from(json["systems"].map((x) => Subject.fromJson(x))),
    topics: List<Subject>.from(json["topics"].map((x) => Subject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "bestSubject": bestSubject,
    "worstSubject": worstSubject,
    "timeTaken": timeTaken,
    "totalQuestionsAnswered": totalQuestionsAnswered,
    "totalCorrect": totalCorrect,
    "totalIncorrect": totalIncorrect,
    "totalOmitted": totalOmitted,
    "totalCorrectToCorrect": totalCorrectToCorrect,
    "totalCorrectToIncorrect": totalCorrectToIncorrect,
    "totalIncorrectToCorrect": totalIncorrectToCorrect,
    "totalIncorrectToIncorrect": totalIncorrectToIncorrect,
    "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
    "systems": List<dynamic>.from(systems.map((x) => x.toJson())),
    "topics": List<dynamic>.from(topics.map((x) => x.toJson())),
  };
}

class Subject {
  Subject({
    required this.srNo,
    this.category,
    required this.totalQuestions,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.omittedQuestions,
  });

  int srNo;
  dynamic category;
  int totalQuestions;
  int correctQuestions;
  int incorrectQuestions;
  int omittedQuestions;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    srNo: json["SrNo"],
    category: json["Category"] == null ? null : json["Category"],
    totalQuestions: json["TotalQuestions"],
    correctQuestions: json["CorrectQuestions"],
    incorrectQuestions: json["IncorrectQuestions"],
    omittedQuestions: json["OmittedQuestions"],
  );

  Map<String, dynamic> toJson() => {
    "SrNo": srNo,
    "Category": category == null ? null : category,
    "TotalQuestions": totalQuestions,
    "CorrectQuestions": correctQuestions,
    "IncorrectQuestions": incorrectQuestions,
    "OmittedQuestions": omittedQuestions,
  };
}
