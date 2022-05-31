// To parse this JSON data, do
//
//     final getSystemCategoriesSuccessfulModel = getSystemCategoriesSuccessfulModelFromJson(jsonString);

import 'dart:convert';

GetSystemCategoriesSuccessfulModel getSystemCategoriesSuccessfulModelFromJson(String str) => GetSystemCategoriesSuccessfulModel.fromJson(json.decode(str));

String getSystemCategoriesSuccessfulModelToJson(GetSystemCategoriesSuccessfulModel data) => json.encode(data.toJson());

class GetSystemCategoriesSuccessfulModel {
  GetSystemCategoriesSuccessfulModel({
    required this.data,
  });

  Data data;

  factory GetSystemCategoriesSuccessfulModel.fromJson(Map<String, dynamic> json) => GetSystemCategoriesSuccessfulModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.categories,
    required this.totalQuestions,
    required this.questions,
  });

  bool status;
  List<Category> categories;
  int totalQuestions;
  List<int> questions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    totalQuestions: json["totalQuestions"],
    questions: List<int>.from(json["questions"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "totalQuestions": totalQuestions,
    "questions": List<dynamic>.from(questions.map((x) => x)),
  };
}

class Category {
  Category({
    required this.parentCategory,
    required this.subCategories,
  });

  String parentCategory;
  List<SubCategory> subCategories;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    parentCategory: json["parentCategory"],
    subCategories: List<SubCategory>.from(json["subCategories"].map((x) => SubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "parentCategory": parentCategory,
    "subCategories": List<dynamic>.from(subCategories.map((x) => x.toJson())),
  };
}

class SubCategory {
  SubCategory({
    required this.id,
    required this.title,
    required this.questions,
  });

  String id;
  String title;
  int questions;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["ID"],
    title: json["Title"],
    questions: json["Questions"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Title": title,
    "Questions": questions,
  };
}
