// To parse this JSON data, do
//
//     final userModelSuccessfulLogin = userModelSuccessfulLoginFromJson(jsonString);

import 'dart:convert';

UserModelSuccessfulLogin userModelSuccessfulLoginFromJson(String str) => UserModelSuccessfulLogin.fromJson(json.decode(str));

String userModelSuccessfulLoginToJson(UserModelSuccessfulLogin data) => json.encode(data.toJson());

class UserModelSuccessfulLogin {
  UserModelSuccessfulLogin({
    required this.data,
  });

  Data data;

  factory UserModelSuccessfulLogin.fromJson(Map<String, dynamic> json) => UserModelSuccessfulLogin(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
    required this.id,
    required this.username,
    required this.ifAdmin,
    required this.token,
  });

  bool status;
  int id;
  String username;
  bool ifAdmin;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    id: json["ID"],
    username: json["username"],
    ifAdmin: json["ifAdmin"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "ID": id,
    "username": username,
    "ifAdmin": ifAdmin,
    "token": token,
  };
}
