// To parse this JSON data, do
//
//     final paperProgramDetailModel = paperProgramDetailModelFromJson(jsonString);

import 'dart:convert';

PaperProgramDetailModel paperProgramDetailModelFromJson(String str) =>
    PaperProgramDetailModel.fromJson(json.decode(str));

String paperProgramDetailModelToJson(PaperProgramDetailModel data) =>
    json.encode(data.toJson());

class PaperProgramDetailModel {
  String? id;
  String? programId;
  String? topics;
  dynamic topicImgUrl;
  String? paperFormat;
  String? committees;
  dynamic committeeImgUrl;
  String? books;
  String? timeline;
  String? contactUs;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaperProgramDetailModel({
    this.id,
    this.programId,
    this.topics,
    this.topicImgUrl,
    this.paperFormat,
    this.committees,
    this.committeeImgUrl,
    this.books,
    this.timeline,
    this.contactUs,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory PaperProgramDetailModel.fromJson(Map<String, dynamic> json) =>
      PaperProgramDetailModel(
        id: json["id"],
        programId: json["program_id"],
        topics: json["topics"],
        topicImgUrl: json["topic_img_url"],
        paperFormat: json["paper_format"],
        committees: json["committees"],
        committeeImgUrl: json["committee_img_url"],
        books: json["books"],
        timeline: json["timeline"],
        contactUs: json["contact_us"],
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
        "topics": topics,
        "topic_img_url": topicImgUrl,
        "paper_format": paperFormat,
        "committees": committees,
        "committee_img_url": committeeImgUrl,
        "books": books,
        "timeline": timeline,
        "contact_us": contactUs,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
