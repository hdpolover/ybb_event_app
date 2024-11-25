// To parse this JSON data, do
//
//     final paperDetailModel = paperDetailModelFromJson(jsonString);

import 'dart:convert';

PaperDetailModel paperDetailModelFromJson(String str) =>
    PaperDetailModel.fromJson(json.decode(str));

String paperDetailModelToJson(PaperDetailModel data) =>
    json.encode(data.toJson());

class PaperDetailModel {
  String? id;
  String? programId;
  dynamic paperAbstractId;
  dynamic paperId;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaperDetailModel({
    this.id,
    this.programId,
    this.paperAbstractId,
    this.paperId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory PaperDetailModel.fromJson(Map<String, dynamic> json) =>
      PaperDetailModel(
        id: json["id"],
        programId: json["program_id"],
        paperAbstractId: json["paper_abstract_id"],
        paperId: json["paper_id"],
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
        "paper_abstract_id": paperAbstractId,
        "paper_id": paperId,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
