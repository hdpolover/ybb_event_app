// To parse this JSON data, do
//
//     final participantSubthemeModel = participantSubthemeModelFromJson(jsonString);

import 'dart:convert';

ParticipantSubthemeModel participantSubthemeModelFromJson(String str) =>
    ParticipantSubthemeModel.fromJson(json.decode(str));

String participantSubthemeModelToJson(ParticipantSubthemeModel data) =>
    json.encode(data.toJson());

class ParticipantSubthemeModel {
  String? id;
  String? programSubthemeId;
  String? participantId;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? logoUrl;
  String? description;
  String? desc;

  ParticipantSubthemeModel({
    this.id,
    this.programSubthemeId,
    this.participantId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.logoUrl,
    this.description,
    this.desc,
  });

  factory ParticipantSubthemeModel.fromJson(Map<String, dynamic> json) =>
      ParticipantSubthemeModel(
        id: json["id"],
        programSubthemeId: json["program_subtheme_id"],
        participantId: json["participant_id"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        name: json["name"],
        logoUrl: json["logo_url"],
        description: json["description"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "program_subtheme_id": programSubthemeId,
        "participant_id": participantId,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "logo_url": logoUrl,
        "description": description,
        "desc": desc,
      };
}
