// To parse this JSON data, do
//
//     final division = divisionFromJson(jsonString);

import 'dart:convert';

Division divisionFromJson(String str) => Division.fromJson(json.decode(str));
List<Division> divisionListFromJson(String str) =>
    List<Division>.from(json.decode(str).map((x) => Division.fromJson(x)));
String divisionToJson(Division data) => json.encode(data.toJson());

class Division {
  Division({
    this.id,
    this.divisionName,
  });

  int? id;
  String? divisionName;

  factory Division.fromJson(Map<String, dynamic> json) => Division(
        id: json["div_id"],
        divisionName: json["divisionName"],
      );

  Map<String, dynamic> toJson() => {
        "div_id": id,
        "divisionName": divisionName,
      };
}
