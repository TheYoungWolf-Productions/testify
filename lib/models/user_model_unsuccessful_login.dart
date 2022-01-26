// To parse this JSON data, do
//
//     final userModelUnsuccessfulLogin = userModelUnsuccessfulLoginFromJson(jsonString);

import 'dart:convert';

UserModelUnsuccessfulLogin userModelUnsuccessfulLoginFromJson(String str) => UserModelUnsuccessfulLogin.fromJson(json.decode(str));

String userModelUnsuccessfulLoginToJson(UserModelUnsuccessfulLogin data) => json.encode(data.toJson());

class UserModelUnsuccessfulLogin {
  UserModelUnsuccessfulLogin({
    required this.data,
  });

  Data data;

  factory UserModelUnsuccessfulLogin.fromJson(Map<String, dynamic> json) => UserModelUnsuccessfulLogin(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
