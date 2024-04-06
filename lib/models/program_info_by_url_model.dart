// To parse this JSON data, do
//
//     final programInfoByUrlModel = programInfoByUrlModelFromJson(jsonString);

import 'dart:convert';

ProgramInfoByUrlModel programInfoByUrlModelFromJson(String str) =>
    ProgramInfoByUrlModel.fromJson(json.decode(str));

String programInfoByUrlModelToJson(ProgramInfoByUrlModel data) =>
    json.encode(data.toJson());

class ProgramInfoByUrlModel {
  String? id;
  String? programCategoryId;
  String? name;
  String? logoUrl;
  String? description;
  String? guideline;
  String? twibbon;
  DateTime? startDate;
  DateTime? endDate;
  String? registrationVideoUrl;
  String? sponsorCanvaUrl;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? programTypeId;
  String? webUrl;
  String? contact;
  String? location;
  String? email;
  String? instagram;
  String? tiktok;
  String? youtube;
  String? telegram;

  ProgramInfoByUrlModel({
    this.id,
    this.programCategoryId,
    this.name,
    this.logoUrl,
    this.description,
    this.guideline,
    this.twibbon,
    this.startDate,
    this.endDate,
    this.registrationVideoUrl,
    this.sponsorCanvaUrl,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.programTypeId,
    this.webUrl,
    this.contact,
    this.location,
    this.email,
    this.instagram,
    this.tiktok,
    this.youtube,
    this.telegram,
  });

  factory ProgramInfoByUrlModel.fromJson(Map<String, dynamic> json) =>
      ProgramInfoByUrlModel(
        id: json["id"],
        programCategoryId: json["program_category_id"],
        name: json["name"],
        logoUrl: json["logo_url"],
        description: json["description"],
        guideline: json["guideline"],
        twibbon: json["twibbon"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        registrationVideoUrl: json["registration_video_url"],
        sponsorCanvaUrl: json["sponsor_canva_url"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        programTypeId: json["program_type_id"],
        webUrl: json["web_url"],
        contact: json["contact"],
        location: json["location"],
        email: json["email"],
        instagram: json["instagram"],
        tiktok: json["tiktok"],
        youtube: json["youtube"],
        telegram: json["telegram"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "program_category_id": programCategoryId,
        "name": name,
        "logo_url": logoUrl,
        "description": description,
        "guideline": guideline,
        "twibbon": twibbon,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "registration_video_url": registrationVideoUrl,
        "sponsor_canva_url": sponsorCanvaUrl,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "program_type_id": programTypeId,
        "web_url": webUrl,
        "contact": contact,
        "location": location,
        "email": email,
        "instagram": instagram,
        "tiktok": tiktok,
        "youtube": youtube,
        "telegram": telegram,
      };
}
