// To parse this JSON data, do
//
//     final testimonyModel = testimonyModelFromJson(jsonString);

import 'dart:convert';

TestimonyModel testimonyModelFromJson(String str) =>
    TestimonyModel.fromJson(json.decode(str));

String testimonyModelToJson(TestimonyModel data) => json.encode(data.toJson());

class TestimonyModel {
  String? id;
  String? programId;
  String? personName;
  String? testimony;
  String? occupation;
  String? institution;
  String? imgUrl;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  TestimonyModel({
    this.id,
    this.programId,
    this.personName,
    this.testimony,
    this.occupation,
    this.institution,
    this.imgUrl,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory TestimonyModel.fromJson(Map<String, dynamic> json) => TestimonyModel(
        id: json["id"],
        programId: json["program_id"],
        personName: json["person_name"],
        testimony: json["testimony"],
        occupation: json["occupation"],
        institution: json["institution"],
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
        "program_id": programId,
        "person_name": personName,
        "testimony": testimony,
        "occupation": occupation,
        "institution": institution,
        "img_url": imgUrl,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
