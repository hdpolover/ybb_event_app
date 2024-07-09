// To parse this JSON data, do
//
//     final agreementLetterModel = agreementLetterModelFromJson(jsonString);

import 'dart:convert';

AgreementLetterModel agreementLetterModelFromJson(String str) =>
    AgreementLetterModel.fromJson(json.decode(str));

String agreementLetterModelToJson(AgreementLetterModel data) =>
    json.encode(data.toJson());

class AgreementLetterModel {
  String? id;
  String? participantId;
  String? fileLink;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  AgreementLetterModel({
    this.id,
    this.participantId,
    this.fileLink,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory AgreementLetterModel.fromJson(Map<String, dynamic> json) =>
      AgreementLetterModel(
        id: json["id"],
        participantId: json["participant_id"],
        fileLink: json["file_link"],
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
        "participant_id": participantId,
        "file_link": fileLink,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
