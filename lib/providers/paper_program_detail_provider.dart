import 'package:flutter/material.dart';
import 'package:ybb_event_app/models/paper_program_detail_model.dart';

class PaperProgramDetailProvider extends ChangeNotifier {
  PaperProgramDetailModel? _paperProgramDetail;

  PaperProgramDetailModel? get paperProgramDetail => _paperProgramDetail;

  void setPaperProgramDetail(PaperProgramDetailModel paperProgramDetail) {
    _paperProgramDetail = paperProgramDetail;
    notifyListeners();
  }

  void removePaperProgramDetail() {
    _paperProgramDetail = null;
    notifyListeners();
  }
}
