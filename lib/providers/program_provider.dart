import 'package:flutter/material.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_model.dart';

class ProgramProvider extends ChangeNotifier {
  ProgramInfoByUrlModel? _programInfo;
  ProgramModel? _currentProgram;
  List<ProgramModel>? _programs;

  List<ProgramModel>? get programs => _programs;

  void setPrograms(List<ProgramModel> programs) {
    _programs = programs;
    notifyListeners();
  }

  void addProgram(ProgramModel program) {
    _programs!.add(program);
    notifyListeners();
  }

  void removeProgram(ProgramModel program) {
    _programs!.remove(program);
    notifyListeners();
  }

  ProgramModel? get currentProgram => _currentProgram;

  void setCurrentProgram(ProgramModel program) {
    _currentProgram = program;
    notifyListeners();
  }

  void removeCurrentProgram() {
    _currentProgram = null;
    notifyListeners();
  }

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
