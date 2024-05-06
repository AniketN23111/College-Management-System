// To parse this JSON data, do
//
//     final deptClass = deptClassFromJson(jsonString);

import 'dart:convert';

List<DeptClass> deptClassListFromJson(String str) =>
    List<DeptClass>.from(json.decode(str).map((x) => DeptClass.fromJson(x)));

DeptClass deptClassFromJson(String str) => DeptClass.fromJson(json.decode(str));

String deptClassToJson(List<DeptClass> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeptClass {
  DeptClass({
    this.id,
    this.className,
    this.subjects,
  });

  int? id;
  String? className;
  List<Subject>? subjects;

  factory DeptClass.fromJson(Map<String, dynamic> json) => DeptClass(
        id: json["id"],
        className: json["className"],
        subjects: List<Subject>.from(
            json["subjects"].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "className": className,
        "subjects": List<dynamic>.from(subjects!.map((x) => x.toJson())),
      };
}

class Subject {
  Subject({
    this.name,
  });

  String? name;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
