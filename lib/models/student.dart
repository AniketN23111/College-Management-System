// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

List<Student> studentFromJson(String str) =>
    List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

String studentToJson(List<Student> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Student {
  Student({
    this.rollNo,
    this.prnNo,
    this.name,
  });

  String? rollNo;
  String? prnNo;
  String? name;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        rollNo: json["rollNo"],
        prnNo: json["prnNo"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "rollNo": rollNo,
        "prnNo": prnNo,
        "name": name,
      };
}
