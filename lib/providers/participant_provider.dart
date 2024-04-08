import 'package:flutter/material.dart';
import 'package:ybb_event_app/models/participant_competition_category_model.dart';
import 'package:ybb_event_app/models/participant_essay_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/models/participant_subtheme_model.dart';

class ParticipantProvider extends ChangeNotifier {
  ParticipantModel? _participant;
  List<ParticipantModel>? _participants;
  ParticipantCompetitionCategoryModel? _participantCompetitionCategory;
  List<ParticipantEssayModel>? _participantEssays;
  ParticipantSubthemeModel? _participantSubtheme;

  ParticipantSubthemeModel? get participantSubtheme => _participantSubtheme;

  void setParticipantSubtheme(ParticipantSubthemeModel participantSubtheme) {
    _participantSubtheme = participantSubtheme;
    notifyListeners();
  }

  void clearParticipantSubtheme() {
    _participantSubtheme = null;
    notifyListeners();
  }

  List<ParticipantEssayModel>? get participantEssays => _participantEssays;

  void setParticipantEssays(List<ParticipantEssayModel> participantEssays) {
    _participantEssays = participantEssays;
    notifyListeners();
  }

  void clearParticipantEssays() {
    _participantEssays = null;
    notifyListeners();
  }

  ParticipantCompetitionCategoryModel? get participantCompetitionCategory =>
      _participantCompetitionCategory;

  void setParticipantCompetitionCategory(
      ParticipantCompetitionCategoryModel participantCompetitionCategory) {
    _participantCompetitionCategory = participantCompetitionCategory;
    notifyListeners();
  }

  void clearParticipantCompetitionCategory() {
    _participantCompetitionCategory = null;
    notifyListeners();
  }

  List<ParticipantModel>? get participants => _participants;

  void setParticipants(List<ParticipantModel> participants) {
    _participants = participants;
    notifyListeners();
  }

  void clearParticipants() {
    _participants = null;
    notifyListeners();
  }

  ParticipantModel? get participant => _participant;

  void setParticipant(ParticipantModel participant) {
    _participant = participant;
    notifyListeners();
  }

  void clearParticipant() {
    _participant = null;
    notifyListeners();
  }
}
