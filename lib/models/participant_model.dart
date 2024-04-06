// To parse this JSON data, do
//
//     final participantModel = participantModelFromJson(jsonString);

import 'dart:convert';

ParticipantModel participantModelFromJson(String str) =>
    ParticipantModel.fromJson(json.decode(str));

String participantModelToJson(ParticipantModel data) =>
    json.encode(data.toJson());

class ParticipantModel {
  String? id;
  String? userId;
  String? accountId;
  String? fullName;
  String? refCodeAmbassador;
  dynamic birthdate;
  dynamic nationality;
  String? gender;
  dynamic countryCode;
  dynamic pictureUrl;
  dynamic phoneNumber;
  String? programId;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ParticipantModel({
    this.id,
    this.userId,
    this.accountId,
    this.fullName,
    this.refCodeAmbassador,
    this.birthdate,
    this.nationality,
    this.gender,
    this.countryCode,
    this.pictureUrl,
    this.phoneNumber,
    this.programId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        id: json["id"],
        userId: json["user_id"],
        accountId: json["account_id"],
        fullName: json["full_name"],
        refCodeAmbassador: json["ref_code_ambassador"],
        birthdate: json["birthdate"],
        nationality: json["nationality"],
        gender: json["gender"],
        countryCode: json["country_code"],
        pictureUrl: json["picture_url"],
        phoneNumber: json["phone_number"],
        programId: json["program_id"],
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
        "user_id": userId,
        "account_id": accountId,
        "full_name": fullName,
        "ref_code_ambassador": refCodeAmbassador,
        "birthdate": birthdate,
        "nationality": nationality,
        "gender": gender,
        "country_code": countryCode,
        "picture_url": pictureUrl,
        "phone_number": phoneNumber,
        "program_id": programId,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
