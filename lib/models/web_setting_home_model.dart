// To parse this JSON data, do
//
//     final webSettingHomeModel = webSettingHomeModelFromJson(jsonString);

import 'dart:convert';

WebSettingHomeModel webSettingHomeModelFromJson(String str) =>
    WebSettingHomeModel.fromJson(json.decode(str));

String webSettingHomeModelToJson(WebSettingHomeModel data) =>
    json.encode(data.toJson());

class WebSettingHomeModel {
  String? id;
  String? programId;
  String? pageName;
  String? menuPath;
  String? banner1ImgUrl;
  String? banner1MobileImgUrl;
  String? banner1Title;
  String? banner1Description;
  String? banner1Date;
  String? banner2ImgUrl;
  String? banner2MobileImgUrl;
  String? banner2Title;
  String? banner2Description;
  String? banner2Date;
  String? summary;
  String? reason;
  String? agenda;
  String? introduction;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  WebSettingHomeModel({
    this.id,
    this.programId,
    this.pageName,
    this.menuPath,
    this.banner1ImgUrl,
    this.banner1MobileImgUrl,
    this.banner1Title,
    this.banner1Description,
    this.banner1Date,
    this.banner2ImgUrl,
    this.banner2MobileImgUrl,
    this.banner2Title,
    this.banner2Description,
    this.banner2Date,
    this.summary,
    this.reason,
    this.agenda,
    this.introduction,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory WebSettingHomeModel.fromJson(Map<String, dynamic> json) =>
      WebSettingHomeModel(
        id: json["id"],
        programId: json["program_id"],
        pageName: json["page_name"],
        menuPath: json["menu_path"],
        banner1ImgUrl: json["banner1_img_url"],
        banner1MobileImgUrl: json["banner1_mobile_img_url"],
        banner1Title: json["banner1_title"],
        banner1Description: json["banner1_description"],
        banner1Date: json["banner1_date"],
        banner2ImgUrl: json["banner2_img_url"],
        banner2MobileImgUrl: json["banner2_mobile_img_url"],
        banner2Title: json["banner2_title"],
        banner2Description: json["banner2_description"],
        banner2Date: json["banner2_date"],
        summary: json["summary"],
        reason: json["reason"],
        agenda: json["agenda"],
        introduction: json["introduction"],
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
        "banner1_img_url": banner1ImgUrl,
        "banner1_mobile_img_url": banner1MobileImgUrl,
        "banner1_title": banner1Title,
        "banner1_description": banner1Description,
        "banner1_date": banner1Date,
        "banner2_img_url": banner2ImgUrl,
        "banner2_mobile_img_url": banner2MobileImgUrl,
        "banner2_title": banner2Title,
        "banner2_description": banner2Description,
        "banner2_date": banner2Date,
        "summary": summary,
        "reason": reason,
        "agenda": agenda,
        "introduction": introduction,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
