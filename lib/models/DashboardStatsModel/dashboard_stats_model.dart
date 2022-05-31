// To parse this JSON data, do
//
//     final dashboardStatsModel = dashboardStatsModelFromJson(jsonString);

import 'dart:convert';

DashboardStatsModel dashboardStatsModelFromJson(String str) => DashboardStatsModel.fromJson(json.decode(str));

String dashboardStatsModelToJson(DashboardStatsModel data) => json.encode(data.toJson());

class DashboardStatsModel {
  DashboardStatsModel({
    required this.data,
  });

  Data data;

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) => DashboardStatsModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.totalQuestions,
    required this.usedQuestions,
    required this.unUsedQuestions,
    required this.totalQuizzes,
    required this.completedQuizzes,
    required this.suspendedQuizzes,
    required this.answeredQuestions,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.omittedQuestions,
    required this.bestSubject,
    required this.worstSubject,
    required this.allQuizScores,
  });

  bool status;
  int totalQuestions;
  int usedQuestions;
  int unUsedQuestions;
  int totalQuizzes;
  int completedQuizzes;
  int suspendedQuizzes;
  int answeredQuestions;
  int correctQuestions;
  int incorrectQuestions;
  int omittedQuestions;
  String bestSubject;
  String worstSubject;
  List<AllQuizScore> allQuizScores;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    totalQuestions: json["totalQuestions"],
    usedQuestions: json["usedQuestions"],
    unUsedQuestions: json["unUsedQuestions"],
    totalQuizzes: json["totalQuizzes"],
    completedQuizzes: json["completedQuizzes"],
    suspendedQuizzes: json["suspendedQuizzes"],
    answeredQuestions: json["answeredQuestions"],
    correctQuestions: json["correctQuestions"],
    incorrectQuestions: json["incorrectQuestions"],
    omittedQuestions: json["omittedQuestions"],
    bestSubject: json["bestSubject"],
    worstSubject: json["worstSubject"],
    allQuizScores: List<AllQuizScore>.from(json["allQuizScores"].map((x) => AllQuizScore.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalQuestions": totalQuestions,
    "usedQuestions": usedQuestions,
    "unUsedQuestions": unUsedQuestions,
    "totalQuizzes": totalQuizzes,
    "completedQuizzes": completedQuizzes,
    "suspendedQuizzes": suspendedQuizzes,
    "answeredQuestions": answeredQuestions,
    "correctQuestions": correctQuestions,
    "incorrectQuestions": incorrectQuestions,
    "omittedQuestions": omittedQuestions,
    "bestSubject": bestSubject,
    "worstSubject": worstSubject,
    "allQuizScores": List<dynamic>.from(allQuizScores.map((x) => x.toJson())),
  };
}

class AllQuizScore {
  AllQuizScore({
    required this.id,
    required this.score,
  });

  int id;
  double score;

  factory AllQuizScore.fromJson(Map<String, dynamic> json) => AllQuizScore(
    id: json["ID"],
    score: json["Score"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Score": score,
  };
}
