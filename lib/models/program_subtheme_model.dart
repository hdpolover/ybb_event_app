// To parse this JSON data, do
//
//     final programSubthemeModel = programSubthemeModelFromJson(jsonString);

import 'dart:convert';

ProgramSubthemeModel programSubthemeModelFromJson(String str) =>
    ProgramSubthemeModel.fromJson(json.decode(str));

String programSubthemeModelToJson(ProgramSubthemeModel data) =>
    json.encode(data.toJson());

class ProgramSubthemeModel {
  String? id;
  String? programId;
  String? name;
  String? desc;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProgramSubthemeModel({
    this.id,
    this.programId,
    this.name,
    this.desc,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgramSubthemeModel.fromJson(Map<String, dynamic> json) =>
      ProgramSubthemeModel(
        id: json["id"],
        programId: json["program_id"],
        name: json["name"],
        desc: json["desc"],
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
        "desc": desc,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
