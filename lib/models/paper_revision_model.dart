// To parse this JSON data, do
//
//     final paperRevisionModel = paperRevisionModelFromJson(jsonString);

import 'dart:convert';

PaperRevisionModel paperRevisionModelFromJson(String str) =>
    PaperRevisionModel.fromJson(json.decode(str));

String paperRevisionModelToJson(PaperRevisionModel data) =>
    json.encode(data.toJson());

class PaperRevisionModel {
  String? id;
  String? paperDetailId;
  String? paperReviewerId;
  String? comment;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? programId;
  String? name;
  String? email;
  String? institution;
  String? password;

  PaperRevisionModel({
    this.id,
    this.paperDetailId,
    this.paperReviewerId,
    this.comment,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.programId,
    this.name,
    this.email,
    this.institution,
    this.password,
  });

  factory PaperRevisionModel.fromJson(Map<String, dynamic> json) =>
      PaperRevisionModel(
        id: json["id"],
        paperDetailId: json["paper_detail_id"],
        paperReviewerId: json["paper_reviewer_id"],
        comment: json["comment"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        programId: json["program_id"],
        name: json["name"],
        email: json["email"],
        institution: json["institution"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paper_detail_id": paperDetailId,
        "paper_reviewer_id": paperReviewerId,
        "comment": comment,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "program_id": programId,
        "name": name,
        "email": email,
        "institution": institution,
        "password": password,
      };
}
