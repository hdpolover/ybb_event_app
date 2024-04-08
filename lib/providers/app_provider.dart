import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }
}
