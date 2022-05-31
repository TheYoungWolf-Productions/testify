
import 'dart:convert';

ResumeQuizModel resumeQuizModelFromJson(String str) => ResumeQuizModel.fromJson(json.decode(str));

String resumeQuizModelToJson(ResumeQuizModel data) => json.encode(data.toJson());

class ResumeQuizModel {
  ResumeQuizModel({
    required this.data,
  });

  Data data;

  factory ResumeQuizModel.fromJson(Map<String, dynamic> json) => ResumeQuizModel(
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
    required this.previousQuizzes,
  });

  bool status;
  List<Question> questions;
  List<PreviousQuizz> previousQuizzes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
    previousQuizzes: List<PreviousQuizz>.from(json["previousQuizzes"].map((x) => PreviousQuizz.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    "previousQuizzes": List<dynamic>.from(previousQuizzes.map((x) => x.toJson())),
  };
}

class PreviousQuizz {
  PreviousQuizz({
    required this.quizId,
    required this.userId,
    required this.quizMeta,
    required this.sortId,
    this.examId,
  });

  int quizId;
  int userId;
  QuizMeta quizMeta;
  DateTime sortId;
  dynamic examId;

  factory PreviousQuizz.fromJson(Map<String, dynamic> json) => PreviousQuizz(
    quizId: json["quiz_id"],
    userId: json["user_id"],
    quizMeta: QuizMeta.fromJson(json["quiz_meta"]),
    sortId: DateTime.parse(json["sortId"]),
    examId: json["exam_id"],
  );

  Map<String, dynamic> toJson() => {
    "quiz_id": quizId,
    "user_id": userId,
    "quiz_meta": quizMeta.toJson(),
    "sortId": sortId.toIso8601String(),
    "exam_id": examId,
  };
}

class QuizMeta {
  QuizMeta({
    required this.quizId,
    required this.quizTitle,
    required this.quizDate,
    required this.quizScore,
    required this.quizTotalQuestions,
    required this.quizStatus,
    required this.quizQuestions,
    required this.quizMode,
    required this.quizTime,
    required this.isTimed,
    required this.omittedQuestions,
    required this.selectedOptionsArray,
  });

  // int quizId;
  // String quizTitle;
  // DateTime quizDate;
  // String quizScore;
  // int quizTotalQuestions;
  // String quizStatus;
  // String quizQuestions;
  // String quizMode;
  // String quizTime;
  // bool isTimed;
  // List<dynamic> omittedQuestions;
  // List<dynamic> selectedOptionsArray;

  dynamic quizId; // Problem
  String quizTitle;
  DateTime quizDate;
  dynamic quizScore; // Problem
  int quizTotalQuestions;
  String quizStatus;
  String quizQuestions;
  String quizMode;
  String quizTime;
  bool isTimed;
  List<dynamic> omittedQuestions;
  // List<dynamic> selectedOptionsArray;
  List<SelectedOptionsArray> selectedOptionsArray;

  factory QuizMeta.fromJson(Map<String, dynamic> json) => QuizMeta(
    quizId: json["quizId"],
    quizTitle: json["quizTitle"],
    quizDate: DateTime.parse(json["quizDate"]),
    quizScore: json["quizScore"],
    quizTotalQuestions: json["quizTotalQuestions"],
    quizStatus: json["quizStatus"],
    quizQuestions: json["quizQuestions"],
    quizMode: json["quizMode"],
    quizTime: json["quizTime"],
    isTimed: json["isTimed"],
    omittedQuestions: List<dynamic>.from(json["omittedQuestions"].map((x) => x)),
    // selectedOptionsArray: List<dynamic>.from(json["selectedOptionsArray"].map((x) => x)),
    selectedOptionsArray: List<SelectedOptionsArray>.from(json["selectedOptionsArray"].map((x) => SelectedOptionsArray.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "quizId": quizId,
    "quizTitle": quizTitle,
    "quizDate": quizDate.toIso8601String(),
    "quizScore": quizScore,
    "quizTotalQuestions": quizTotalQuestions,
    "quizStatus": quizStatus,
    "quizQuestions": quizQuestions,
    "quizMode": quizMode,
    "quizTime": quizTime,
    "isTimed": isTimed,
    "omittedQuestions": List<dynamic>.from(omittedQuestions.map((x) => x)),
    // "selectedOptionsArray": List<dynamic>.from(selectedOptionsArray.map((x) => x)),
    "selectedOptionsArray": List<dynamic>.from(selectedOptionsArray.map((x) => x.toJson())),
  };
}

class SelectedOptionsArray {
  SelectedOptionsArray({
    this.index,
    this.correctanswerindex,
    this.correct,
    this.optionIndexSelected,
    this.time
  });

  dynamic index;
  dynamic correctanswerindex;
  dynamic correct;
  dynamic optionIndexSelected;
  dynamic time;

  factory SelectedOptionsArray.fromJson(Map<String, dynamic> json) => SelectedOptionsArray(
    index: json["index"] == null ? null : json["index"],
    correctanswerindex: json["Correctanswerindex"] == null ? null : json["Correctanswerindex"],
    correct: json["correct"] == null ? null : json["correct"],
    optionIndexSelected: json["optionIndexSelected"] == null ? null : json["optionIndexSelected"],
    time: json["time"] == null ? null : json["time"],
  );

  Map<String, dynamic> toJson() => {
    "index": index,
    "Correctanswerindex": correctanswerindex,
    "correct": correct,
    "optionIndexSelected": optionIndexSelected,
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
    this.userId,
    this.submitData,
    this.notes,
    this.questionId,
    this.noteId,
    this.noteMeta,
    required this.marked,
    required this.options,
    required this.statistics,
  });

  int id;
  String title;
  String question;
  String correctMsg;
  String answerType;
  int postId;
  dynamic userId;
  dynamic submitData;
  dynamic notes;
  dynamic questionId;
  dynamic noteId;
  dynamic noteMeta;
  int marked;
  List<String> options;
  List<int> statistics;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    title: json["title"],
    question: json["question"],
    correctMsg: json["correct_msg"],
    answerType: json["answer_type"],
    postId: json["postId"],
    userId: json["user_id"] == null ? null : json["user_id"],
    submitData: json["submitData"] == null ? null : json["submitData"],
    notes: json["notes"] == null ? null : json["notes"],
    questionId: json["questionId"] == null ? null : json["questionId"],
    noteId: json["noteId"] == null ? null : json["noteId"],
    noteMeta: json["note_meta"] == null ? null : json["note_meta"],
    marked: json["marked"],
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
    "user_id": userId ?? null,
    "submitData": submitData == null ? null : submitData,
    "notes": notes,
    "questionId": questionId,
    "noteId": noteId,
    "note_meta": noteMeta,
    "marked": marked,
    "options": List<dynamic>.from(options.map((x) => x)),
    "statistics": List<dynamic>.from(statistics.map((x) => x)),
  };
}
