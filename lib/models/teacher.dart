// To parse this JSON data, do
//
//     final teacher = teacherFromJson(jsonString);

import 'dart:convert';

List<Teacher> teachersListFromJson(String str) =>
    List<Teacher>.from(json.decode(str).map((x) => Teacher.fromJson(x)));

Teacher teacherFromJson(String str) => Teacher.fromJson(json.decode(str));

String teacherToJson(Teacher data) => json.encode(data.toJson());

class Teacher {
  Teacher({
    this.email,
    this.password,
    this.name,
    this.designation,
    this.roles,
  });

  String? email;
  String? password;
  String? name;
  String? designation;
  List<dynamic>? roles;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        designation: json["designation"],
        roles: List<dynamic>.from(json["roles"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "designation": designation,
        "roles": List<dynamic>.from(roles!.map((x) => x)),
      };
}
