import 'package:flutter/material.dart';
import 'package:ybb_event_app/models/paper_abstract_model.dart';
import 'package:ybb_event_app/models/paper_author_model.dart';
import 'package:ybb_event_app/models/paper_detail_model.dart';

class PaperProvider extends ChangeNotifier {
  List<PaperAuthorModel>? _authors = [];
  PaperAuthorModel? _currentAuthor;
  PaperDetailModel? _currentPaperDetail;
  PaperAbstractModel? _currentPaperAbstract;

  PaperAbstractModel? get currentPaperAbstract => _currentPaperAbstract;

  void setCurrentPaperAbstract(PaperAbstractModel paperAbstract) {
    _currentPaperAbstract = paperAbstract;
    notifyListeners();
  }

  void updatePaperAbstract(PaperAbstractModel paperAbstract) {
    _currentPaperAbstract = paperAbstract;
    notifyListeners();
  }

  void clearCurrentPaperAbstract() {
    _currentPaperAbstract = null;
    notifyListeners();
  }

  PaperDetailModel? get currentPaperDetail => _currentPaperDetail;

  void setCurrentPaperDetail(PaperDetailModel paperDetail) {
    _currentPaperDetail = paperDetail;
    notifyListeners();
  }

  void clearCurrentPaperDetail() {
    _currentPaperDetail = null;
    notifyListeners();
  }

  PaperAuthorModel? get currentAuthor => _currentAuthor;

  void setCurrentAuthor(PaperAuthorModel author) {
    _currentAuthor = author;
    notifyListeners();
  }

  void updateAuthor(PaperAuthorModel author) {
    for (var element in authors!) {
      if (element.id == author.id) {
        element = author;
      }
    }

    notifyListeners();
  }

  void clearCurrentAuthor() {
    _currentAuthor = null;
    notifyListeners();
  }

  List<PaperAuthorModel>? get authors => _authors;

  void setAuthors(List<PaperAuthorModel> authors) {
    _authors = authors;
    notifyListeners();
  }

  void addAuthor(PaperAuthorModel author) {
    _authors!.add(author);
    notifyListeners();
  }

  void removeAuthor(String authorId) {
    _authors!.removeWhere((element) => element.id == authorId);

    notifyListeners();
  }
}
