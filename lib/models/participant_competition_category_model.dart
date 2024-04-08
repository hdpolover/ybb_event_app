// To parse this JSON data, do
//
//     final participantCompetitionCategoryModel = participantCompetitionCategoryModelFromJson(jsonString);

import 'dart:convert';

ParticipantCompetitionCategoryModel participantCompetitionCategoryModelFromJson(
        String str) =>
    ParticipantCompetitionCategoryModel.fromJson(json.decode(str));

String participantCompetitionCategoryModelToJson(
        ParticipantCompetitionCategoryModel data) =>
    json.encode(data.toJson());

class ParticipantCompetitionCategoryModel {
  String? id;
  String? participantId;
  String? competitionCategoryId;
  String? category;
  String? desc;

  ParticipantCompetitionCategoryModel({
    this.id,
    this.participantId,
    this.competitionCategoryId,
    this.category,
    this.desc,
  });

  factory ParticipantCompetitionCategoryModel.fromJson(
          Map<String, dynamic> json) =>
      ParticipantCompetitionCategoryModel(
        id: json["id"],
        participantId: json["participant_id"],
        competitionCategoryId: json["competition_category_id"],
        category: json["category"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "participant_id": participantId,
        "competition_category_id": competitionCategoryId,
        "category": category,
        "desc": desc,
      };
}
