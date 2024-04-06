import 'package:flutter/material.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';

class ProgramProvider extends ChangeNotifier {
  ProgramInfoByUrlModel? _programInfo;

  ProgramInfoByUrlModel? get programInfo => _programInfo;

  void setProgramInfo(ProgramInfoByUrlModel programInfo) {
    _programInfo = programInfo;
    notifyListeners();
  }

  void removeProgramInfo() {
    _programInfo = null;
    notifyListeners();
  }
}
