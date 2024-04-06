import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  AuthUserModel? _authUser;

  AuthUserModel? get authUser => _authUser;

  void setAuthUser(AuthUserModel user) {
    _authUser = user;
    notifyListeners();
  }

  void removeAuthUser() {
    _authUser = null;
    notifyListeners();
  }

  void updateAuthUser({String? email, String? fullName}) {
    _authUser!.email = email;
    _authUser!.fullName = fullName;
    notifyListeners();
  }
}

class AuthUserModel {
  String? id;
  String? email;
  String? fullName;

  AuthUserModel({this.id, this.email, this.fullName});
}
