// To parse this JSON data, do
//
//     final modelUser = modelUserFromJson(jsonString);

import 'dart:convert';

List<ModelUser> modelUserFromJson(String str) => List<ModelUser>.from(json.decode(str).map((x) => ModelUser.fromJson(x)));

String modelUserToJson(List<ModelUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelUser {
  int id;
  String name;
  String email;
  String role;

  ModelUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
  };
}
