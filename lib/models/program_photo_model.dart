// To parse this JSON data, do
//
//     final programPhotoModel = programPhotoModelFromJson(jsonString);

import 'dart:convert';

ProgramPhotoModel programPhotoModelFromJson(String str) =>
    ProgramPhotoModel.fromJson(json.decode(str));

String programPhotoModelToJson(ProgramPhotoModel data) =>
    json.encode(data.toJson());

class ProgramPhotoModel {
  String? id;
  String? programCategoryId;
  String? description;
  String? imgUrl;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProgramPhotoModel({
    this.id,
    this.programCategoryId,
    this.description,
    this.imgUrl,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgramPhotoModel.fromJson(Map<String, dynamic> json) =>
      ProgramPhotoModel(
        id: json["id"],
        programCategoryId: json["program_category_id"],
        description: json["description"],
        imgUrl: json["img_url"],
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
        "description": description,
        "img_url": imgUrl,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
