// To parse this JSON data, do
//
//     final competitionCategoryModel = competitionCategoryModelFromJson(jsonString);

import 'dart:convert';

CompetitionCategoryModel competitionCategoryModelFromJson(String str) =>
    CompetitionCategoryModel.fromJson(json.decode(str));

String competitionCategoryModelToJson(CompetitionCategoryModel data) =>
    json.encode(data.toJson());

class CompetitionCategoryModel {
  String? id;
  String? programCategoryId;
  String? category;
  String? desc;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  CompetitionCategoryModel({
    this.id,
    this.programCategoryId,
    this.category,
    this.desc,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory CompetitionCategoryModel.fromJson(Map<String, dynamic> json) =>
      CompetitionCategoryModel(
        id: json["id"],
        programCategoryId: json["program_category_id"],
        category: json["category"],
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
        "program_category_id": programCategoryId,
        "category": category,
        "desc": desc,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
