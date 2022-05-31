// To parse this JSON data, do
//
//     final getPerformanceStatsModel = getPerformanceStatsModelFromJson(jsonString);

import 'dart:convert';

GetPerformanceStatsModel getPerformanceStatsModelFromJson(String str) => GetPerformanceStatsModel.fromJson(json.decode(str));

String getPerformanceStatsModelToJson(GetPerformanceStatsModel data) => json.encode(data.toJson());

class GetPerformanceStatsModel {
  GetPerformanceStatsModel({
    required this.data,
  });

  Data data;

  factory GetPerformanceStatsModel.fromJson(Map<String, dynamic> json) => GetPerformanceStatsModel(
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
    required this.omittedSubject,
    required this.totalQuizzes,
    required this.completedQuizzes,
    required this.suspendedQuizzes,
    required this.subjects,
    required this.systems,
    required this.topics,
  });

  bool status;
  String bestSubject;
  String worstSubject;
  String omittedSubject;
  int totalQuizzes;
  int completedQuizzes;
  int suspendedQuizzes;
  List<Subject> subjects;
  List<Subject> systems;
  List<Subject> topics;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    bestSubject: json["bestSubject"],
    worstSubject: json["worstSubject"],
    omittedSubject: json["omittedSubject"],
    totalQuizzes: json["totalQuizzes"],
    completedQuizzes: json["completedQuizzes"],
    suspendedQuizzes: json["suspendedQuizzes"],
    subjects: List<Subject>.from(json["subjects"].map((x) => Subject.fromJson(x))),
    systems: List<Subject>.from(json["systems"].map((x) => Subject.fromJson(x))),
    topics: List<Subject>.from(json["topics"].map((x) => Subject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "bestSubject": bestSubject,
    "worstSubject": worstSubject,
    "omittedSubject": omittedSubject,
    "totalQuizzes": totalQuizzes,
    "completedQuizzes": completedQuizzes,
    "suspendedQuizzes": suspendedQuizzes,
    "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
    "systems": List<dynamic>.from(systems.map((x) => x.toJson())),
    "topics": List<dynamic>.from(topics.map((x) => x.toJson())),
  };
}

class Subject {
  Subject({
    required this.srNo,
    required this.category,
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
