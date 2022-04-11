// To parse this JSON data, do
//
//     final getSystemCategoriesUnsuccessfulModel = getSystemCategoriesUnsuccessfulModelFromJson(jsonString);

import 'dart:convert';

GetSystemCategoriesUnsuccessfulModel getSystemCategoriesUnsuccessfulModelFromJson(String str) => GetSystemCategoriesUnsuccessfulModel.fromJson(json.decode(str));

String getSystemCategoriesUnsuccessfulModelToJson(GetSystemCategoriesUnsuccessfulModel data) => json.encode(data.toJson());

class GetSystemCategoriesUnsuccessfulModel {
  GetSystemCategoriesUnsuccessfulModel({
    required this.status,
    required this.msg,
  });

  bool status;
  String msg;

  factory GetSystemCategoriesUnsuccessfulModel.fromJson(Map<String, dynamic> json) => GetSystemCategoriesUnsuccessfulModel(
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
  };
}
