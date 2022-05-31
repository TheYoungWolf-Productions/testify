// To parse this JSON data, do
//
//     final resultDetailsModel = resultDetailsModelFromJson(jsonString);

import 'dart:convert';

ResultDetailsModel resultDetailsModelFromJson(String str) => ResultDetailsModel.fromJson(json.decode(str));

String resultDetailsModelToJson(ResultDetailsModel data) => json.encode(data.toJson());

class ResultDetailsModel {
  ResultDetailsModel({
    required this.data,
  });

  Data data;

  factory ResultDetailsModel.fromJson(Map<String, dynamic> json) => ResultDetailsModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.quizId,
    required this.score,
    required this.timeTaken,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.totalCorrect,
    required this.totalIncorrect,
    required this.totalOmitted,
    required this.quizResults,
  });

  String status;
  int quizId;
  int score;
  String timeTaken;
  int totalQuestions;
  int answeredQuestions;
  int totalCorrect;
  int totalIncorrect;
  int totalOmitted;
  List<QuizResult> quizResults;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    quizId: json["quizId"],
    score: json["score"],
    timeTaken: json["timeTaken"],
    totalQuestions: json["totalQuestions"],
    answeredQuestions: json["answeredQuestions"],
    totalCorrect: json["totalCorrect"],
    totalIncorrect: json["totalIncorrect"],
    totalOmitted: json["totalOmitted"],
    quizResults: List<QuizResult>.from(json["quizResults"].map((x) => QuizResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "quizId": quizId,
    "score": score,
    "timeTaken": timeTaken,
    "totalQuestions": totalQuestions,
    "answeredQuestions": answeredQuestions,
    "totalCorrect": totalCorrect,
    "totalIncorrect": totalIncorrect,
    "totalOmitted": totalOmitted,
    "quizResults": List<dynamic>.from(quizResults.map((x) => x.toJson())),
  };
}

class QuizResult {
  QuizResult({
    required this.questionId,
    required this.subject,
    required this.system,
    required this.topic,
    required this.status,
    required this.averageCorrectToOthers,
  });

  int questionId;
  String subject;
  String system;
  dynamic topic;
  int status;
  int averageCorrectToOthers;

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    questionId: json["QuestionID"],
    subject: json["Subject"],
    system: json["System"],
    topic: json["Topic"],
    status: json["Status"],
    averageCorrectToOthers: json["AverageCorrectToOthers"],
  );

  Map<String, dynamic> toJson() => {
    "QuestionID": questionId,
    "Subject": subject,
    "System": system,
    "Topic": topic,
    "Status": status,
    "AverageCorrectToOthers": averageCorrectToOthers,
  };
}
