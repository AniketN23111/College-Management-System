// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

List<Notification> notificationListFromJson(String str) =>
    List<Notification>.from(
        json.decode(str).map((x) => Notification.fromJson(x)));

String notificationListToJson(List<Notification> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notification {
  Notification({
    this.id,
    this.teacher,
    this.teacherEmail,
    this.message,
    this.date,
  });

  int? id;
  String? teacher;
  String? teacherEmail;
  String? message;
  DateTime? date;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        teacher: json["teacher"],
        teacherEmail: json["teacherEmail"],
        message: json["message"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher": teacher,
        "teacherEmail": teacherEmail,
        "message": message,
        "date": date == null ? null : date!.toIso8601String(),
      };
}
