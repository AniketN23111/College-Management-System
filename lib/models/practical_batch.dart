// To parse this JSON data, do
//
//     final practicalBatch = practicalBatchFromJson(jsonString);

import 'dart:convert';

PracticalBatch practicalBatchFromJson(String str) => PracticalBatch.fromJson(json.decode(str));

String practicalBatchToJson(PracticalBatch data) => json.encode(data.toJson());

List<PracticalBatch> practicalBatchListFromJson(String str) => List<PracticalBatch>.from(json.decode(str).map((x) => PracticalBatch.fromJson(x)));

String practicalBatchListToJson(List<PracticalBatch> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class PracticalBatch {
    PracticalBatch({
        this.id,
        this.batchName,
        this.className,
        this.division,
    });

    int? id;
    String? batchName;
    String? className;
    String? division;

    factory PracticalBatch.fromJson(Map<String, dynamic> json) => PracticalBatch(
        id: json["id"],
        batchName: json["batchName"],
        className: json["className"],
        division: json["division"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "batchName": batchName,
        "className": className,
        "division": division,
    };
}
