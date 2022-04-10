// To parse this JSON data, do
//
//     final generateQuizSuccessful = generateQuizSuccessfulFromJson(jsonString);

import 'dart:convert';

GenerateQuizSuccessful generateQuizSuccessfulFromJson(String str) => GenerateQuizSuccessful.fromJson(json.decode(str));

String generateQuizSuccessfulToJson(GenerateQuizSuccessful data) => json.encode(data.toJson());

class GenerateQuizSuccessful {
  GenerateQuizSuccessful({
    required this.data,
  });

  Data data;

  factory GenerateQuizSuccessful.fromJson(Map<String, dynamic> json) => GenerateQuizSuccessful(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.questions,
    required this.totalQuestions,
    required this.quizId,
  });

  bool status;
  List<Question> questions;
  int totalQuestions;
  int quizId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
    totalQuestions: json["totalQuestions"],
    quizId: json["quizId"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    "totalQuestions": totalQuestions,
    "quizId": quizId,
  };
}

class Question {
  Question({
    required this.id,
    required this.title,
    required this.question,
    required this.correctMsg,
    required this.answerType,
    required this.postId,
    required this.options,
    required this.statistics,
  });

  int id;
  String title;
  String question;
  String correctMsg;
  String answerType;
  int postId;
  List<String> options;
  List<int> statistics;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    title: json["title"],
    question: json["question"],
    correctMsg: json["correct_msg"],
    answerType: json["answer_type"],
    postId: json["postId"],
    options: List<String>.from(json["options"].map((x) => x)),
    statistics: List<int>.from(json["statistics"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "question": question,
    "correct_msg": correctMsg,
    "answer_type": answerType,
    "postId": postId,
    "options": List<dynamic>.from(options.map((x) => x)),
    "statistics": List<dynamic>.from(statistics.map((x) => x)),
  };
}
