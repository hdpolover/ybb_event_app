// To parse this JSON data, do
//
//     final programLoaModel = programLoaModelFromJson(jsonString);

import 'dart:convert';

ProgramLoaModel programLoaModelFromJson(String str) =>
    ProgramLoaModel.fromJson(json.decode(str));

String programLoaModelToJson(ProgramLoaModel data) =>
    json.encode(data.toJson());

class ProgramLoaModel {
  String? id;
  String? programId;
  String? templateName;
  String? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProgramLoaModel({
    this.id,
    this.programId,
    this.templateName,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgramLoaModel.fromJson(Map<String, dynamic> json) =>
      ProgramLoaModel(
        id: json["id"],
        programId: json["program_id"],
        templateName: json["template_name"],
        isActive: json["is_active"],
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
        "template_name": templateName,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
