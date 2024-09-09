import 'package:flutter/material.dart';
import 'package:ybb_event_app/models/program_announcement_model.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_model.dart';

class AnnouncementProvider extends ChangeNotifier {
  ProgramAnnouncementModel? _currentAnnouncement;
  List<ProgramAnnouncementModel> _announcements = [];

  List<ProgramAnnouncementModel> get announcements => _announcements;

  void setAnnouncements(List<ProgramAnnouncementModel> announcements) {
    _announcements = announcements;
    notifyListeners();
  }

  void addAnnouncement(ProgramAnnouncementModel announcement) {
    _announcements.add(announcement);
    notifyListeners();
  }

  void removeAnnouncement(ProgramAnnouncementModel announcement) {
    _announcements.remove(announcement);
    notifyListeners();
  }

  ProgramAnnouncementModel? get currentAnnouncement => _currentAnnouncement;

  void setCurrentAnnouncement(ProgramAnnouncementModel announcement) {
    _currentAnnouncement = announcement;
    notifyListeners();
  }

  void removeCurrentAnnouncement() {
    _currentAnnouncement = null;
    notifyListeners();
  }

  void removeAnnouncements() {
    _announcements = [];
    notifyListeners();
  }
}
