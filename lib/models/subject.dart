// To parse this JSON data, do
//
//     final subject = subjectFromJson(jsonString);

import 'dart:convert';

List<Subject> subjectFromJson(String str) =>
    List<Subject>.from(json.decode(str).map((x) => Subject.fromJson(x)));

String subjectToJson(List<Subject> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subject {
  Subject({this.name, this.isPractical});

  String? name;
  bool? isPractical;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      Subject(name: json["name"], isPractical: json["isPractical"]);

  Map<String, dynamic> toJson() => {"name": name, "isPractical": isPractical};
}
