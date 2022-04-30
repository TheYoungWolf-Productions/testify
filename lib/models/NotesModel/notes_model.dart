// To parse this JSON data, do
//
//     final notesModel = notesModelFromJson(jsonString);

import 'dart:convert';

NotesModel notesModelFromJson(String str) => NotesModel.fromJson(json.decode(str));

String notesModelToJson(NotesModel data) => json.encode(data.toJson());

class NotesModel {
  NotesModel({
    required this.data,
  });

  Data data;

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.notes,
  });

  bool status;
  List<Note> notes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
  };
}

class Note {
  Note({
    required this.idpsasUserNotes,
    required this.questionId,
    required this.userId,
    required this.quizId,
    required this.notes,
    required this.noteMeta,
  });

  int idpsasUserNotes;
  int questionId;
  int userId;
  int quizId;
  String notes;
  String noteMeta;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    idpsasUserNotes: json["idpsas_user_notes"],
    questionId: json["question_id"],
    userId: json["user_id"],
    quizId: json["quiz_id"],
    notes: json["notes"],
    noteMeta: json["note_meta"],
  );

  Map<String, dynamic> toJson() => {
    "idpsas_user_notes": idpsasUserNotes,
    "question_id": questionId,
    "user_id": userId,
    "quiz_id": quizId,
    "notes": notes,
    "note_meta": noteMeta,
  };
}
