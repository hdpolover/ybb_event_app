// To parse this JSON data, do
//
//     final programEssayModel = programEssayModelFromJson(jsonString);

import 'dart:convert';

ProgramEssayModel programEssayModelFromJson(String str) =>
    ProgramEssayModel.fromJson(json.decode(str));

String programEssayModelToJson(ProgramEssayModel data) =>
    json.encode(data.toJson());

class ProgramEssayModel {
  String? id;
  String? programId;
  String? questions;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProgramEssayModel({
    this.id,
    this.programId,
    this.questions,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgramEssayModel.fromJson(Map<String, dynamic> json) =>
      ProgramEssayModel(
        id: json["id"],
        programId: json["program_id"],
        questions: json["questions"],
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
        "questions": questions,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
