// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

List<Attendance> attendanceListFromJson(String str) =>
    List<Attendance>.from(json.decode(str).map((x) => Attendance.fromJson(x)));

Attendance attendanceFromJson(String str) =>
    Attendance.fromJson(json.decode(str));

String attendanceToJson(List<Attendance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attendance {
  Attendance({
    this.id,
    this.attendanceDate,
    this.attendanceTime,
    this.className,
    this.divisionName,
    this.faculty,
    this.subject,
    this.batchName,
    this.presentStudents,
    this.absentStudents,
  });

  int? id;
  DateTime? attendanceDate;
  String? attendanceTime;
  String? className;
  String? divisionName;
  String? faculty;
  String? subject;
  String? batchName;
  String? presentStudents;
  String? absentStudents;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
      id: json["id"],
      attendanceDate: DateTime.parse(json["attendanceDate"]),
      attendanceTime: json["attendanceTime"],
      className: json["className"],
      divisionName: json["divisionName"],
      faculty: json["faculty"],
      subject: json["subject"],
      presentStudents: json["presentStudents"],
      absentStudents: json["absentStudents"],
      batchName: json["batchName"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "attendanceDate": attendanceDate!.toIso8601String(),
        "attendanceTime": attendanceTime,
        "className": className,
        "divisionName": divisionName,
        "faculty": faculty,
        "subject": subject,
        "presentStudents": presentStudents,
        "absentStudents": absentStudents,
        "batchName": batchName
      };
}
