// To parse this JSON data, do
//
//     final webSettingAboutModel = webSettingAboutModelFromJson(jsonString);

import 'dart:convert';

WebSettingAboutModel webSettingAboutModelFromJson(String str) =>
    WebSettingAboutModel.fromJson(json.decode(str));

String webSettingAboutModelToJson(WebSettingAboutModel data) =>
    json.encode(data.toJson());

class WebSettingAboutModel {
  String? id;
  String? programId;
  String? pageName;
  String? menuPath;
  String? aboutYbb;
  String? aboutProgram;
  String? whyProgram;
  String? whatProgram;
  String? ybbVideoUrl;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  WebSettingAboutModel({
    this.id,
    this.programId,
    this.pageName,
    this.menuPath,
    this.aboutYbb,
    this.aboutProgram,
    this.whyProgram,
    this.whatProgram,
    this.ybbVideoUrl,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory WebSettingAboutModel.fromJson(Map<String, dynamic> json) =>
      WebSettingAboutModel(
        id: json["id"],
        programId: json["program_id"],
        pageName: json["page_name"],
        menuPath: json["menu_path"],
        aboutYbb: json["about_ybb"],
        aboutProgram: json["about_program"],
        whyProgram: json["why_program"],
        whatProgram: json["what_program"],
        ybbVideoUrl: json["ybb_video_url"],
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
        "page_name": pageName,
        "menu_path": menuPath,
        "about_ybb": aboutYbb,
        "about_program": aboutProgram,
        "why_program": whyProgram,
        "what_program": whatProgram,
        "ybb_video_url": ybbVideoUrl,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
