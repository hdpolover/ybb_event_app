// To parse this JSON data, do
//
//     final participantModel = participantModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

ParticipantModel participantModelFromJson(String str) =>
    ParticipantModel.fromJson(json.decode(str));

String participantModelToJson(ParticipantModel data) =>
    json.encode(data.toJson());

class ParticipantModel {
  String? id;
  String? userId;
  String? accountId;
  String? fullName;
  DateTime? birthdate;
  dynamic refCodeAmbassador;
  String? programId;
  String? gender;
  dynamic originAddress;
  dynamic currentAddress;
  dynamic nationality;
  dynamic occupation;
  dynamic institution;
  dynamic organizations;
  dynamic countryCode;
  dynamic phoneNumber;
  dynamic pictureUrl;
  dynamic instagramAccount;
  dynamic emergencyAccount;
  dynamic contactRelation;
  dynamic diseaseHistory;
  dynamic tshirtSize;
  dynamic experiences;
  dynamic achievements;
  dynamic resumeUrl;
  dynamic knowledgeSource;
  dynamic sourceAccountName;
  dynamic twibbonLink;
  dynamic requirementLink;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ParticipantModel({
    this.id,
    this.userId,
    this.accountId,
    this.fullName,
    this.birthdate,
    this.refCodeAmbassador,
    this.programId,
    this.gender,
    this.originAddress,
    this.currentAddress,
    this.nationality,
    this.occupation,
    this.institution,
    this.organizations,
    this.countryCode,
    this.phoneNumber,
    this.pictureUrl,
    this.instagramAccount,
    this.emergencyAccount,
    this.contactRelation,
    this.diseaseHistory,
    this.tshirtSize,
    this.experiences,
    this.achievements,
    this.resumeUrl,
    this.knowledgeSource,
    this.sourceAccountName,
    this.twibbonLink,
    this.requirementLink,
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
        birthdate: json["birthdate"] == null
            ? null
            : DateTime.parse(json["birthdate"]),
        refCodeAmbassador: json["ref_code_ambassador"],
        programId: json["program_id"],
        gender: json["gender"],
        originAddress: json["origin_address"],
        currentAddress: json["current_address"],
        nationality: json["nationality"],
        occupation: json["occupation"],
        institution: json["institution"],
        organizations: json["organizations"],
        countryCode: json["country_code"],
        phoneNumber: json["phone_number"],
        pictureUrl: json["picture_url"],
        instagramAccount: json["instagram_account"],
        emergencyAccount: json["emergency_account"],
        contactRelation: json["contact_relation"],
        diseaseHistory: json["disease_history"],
        tshirtSize: json["tshirt_size"],
        experiences: json["experiences"],
        achievements: json["achievements"],
        resumeUrl: json["resume_url"],
        knowledgeSource: json["knowledge_source"],
        sourceAccountName: json["source_account_name"],
        twibbonLink: json["twibbon_link"],
        requirementLink: json["requirement_link"],
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
        "id": id.toString(),
        "full_name": fullName,
        "birthdate": birthdate,
        "ref_code_ambassador": refCodeAmbassador,
        "program_id": programId.toString(),
        "gender": gender,
        "origin_address": originAddress,
        "current_address": currentAddress,
        "nationality": nationality,
        "occupation": occupation,
        "institution": institution,
        "organizations": organizations,
        "country_code": countryCode,
        "phone_number": phoneNumber,
        "picture_url": pictureUrl,
        "instagram_account": instagramAccount,
        "emergency_account": emergencyAccount,
        "contact_relation": contactRelation,
        "disease_history": diseaseHistory,
        "tshirt_size": tshirtSize,
        "experiences": experiences,
        "achievements": achievements,
        "resume_url": resumeUrl,
        "knowledge_source": knowledgeSource,
        "source_account_name": sourceAccountName,
        "twibbon_link": twibbonLink,
        "requirement_link": requirementLink,
      };
}
