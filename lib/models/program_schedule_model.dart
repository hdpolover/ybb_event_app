// To parse this JSON data, do
//
//     final programScheduleModel = programScheduleModelFromJson(jsonString);

import 'dart:convert';

ProgramScheduleModel programScheduleModelFromJson(String str) =>
    ProgramScheduleModel.fromJson(json.decode(str));

String programScheduleModelToJson(ProgramScheduleModel data) =>
    json.encode(data.toJson());

class ProgramScheduleModel {
  String? id;
  String? programId;
  String? name;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? orderNumber;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProgramScheduleModel({
    this.id,
    this.programId,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.orderNumber,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgramScheduleModel.fromJson(Map<String, dynamic> json) =>
      ProgramScheduleModel(
        id: json["id"],
        programId: json["program_id"],
        name: json["name"],
        description: json["description"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        orderNumber: json["order_number"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "program_id": programId,
        "name": name,
        "description": description,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "order_number": orderNumber,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
