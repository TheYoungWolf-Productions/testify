// To parse this JSON data, do
//
//     final getPreviousQuizzesModel = getPreviousQuizzesModelFromJson(jsonString);

import 'dart:convert';

GetPreviousQuizzesModel getPreviousQuizzesModelFromJson(String str) => GetPreviousQuizzesModel.fromJson(json.decode(str));

String getPreviousQuizzesModelToJson(GetPreviousQuizzesModel data) => json.encode(data.toJson());

class GetPreviousQuizzesModel {
  GetPreviousQuizzesModel({
    required this.data,
  });

  Data data;

  factory GetPreviousQuizzesModel.fromJson(Map<String, dynamic> json) => GetPreviousQuizzesModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.quizzes,
  });

  bool status;
  List<Quiz> quizzes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    quizzes: List<Quiz>.from(json["quizzes"].map((x) => Quiz.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "quizzes": List<dynamic>.from(quizzes.map((x) => x.toJson())),
  };
}

class Quiz {
  Quiz({
    required this.quizId,
    required this.name,
    required this.score,
    required this.date,
    required this.status,
    required this.questions,
    required this.totalQuestions,
    required this.subjects,
    required this.systems,
    required this.topics,
  });

  int quizId;
  String name;
  String score;
  String date;
  String status;
  List<int> questions;
  String totalQuestions;
  List<String> subjects;
  List<String> systems;
  List<dynamic> topics;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    quizId: json["quizId"],
    name: json["name"],
    score: json["score"],
    date: json["date"],
    status: json["status"],
    questions: List<int>.from(json["questions"].map((x) => x)),
    totalQuestions: json["totalQuestions"],
    subjects: List<String>.from(json["subjects"].map((x) => x)),
    systems: List<String>.from(json["systems"].map((x) => x)),
    topics: List<dynamic>.from(json["topics"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "quizId": quizId,
    "name": name,
    "score": score,
    "date": date,
    "status": status,
    "questions": List<dynamic>.from(questions.map((x) => x)),
    "totalQuestions": totalQuestions,
    "subjects": List<dynamic>.from(subjects.map((x) => x)),
    "systems": List<dynamic>.from(systems.map((x) => x)),
    "topics": List<dynamic>.from(topics.map((x) => x)),
  };
}
