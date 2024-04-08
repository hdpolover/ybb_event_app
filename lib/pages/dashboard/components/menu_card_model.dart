import 'package:flutter/material.dart';

class MenuCardModel {
  final String title;
  final String desc;
  final IconData icon;
  final bool isActive;
  final String route;

  MenuCardModel({
    required this.title,
    required this.desc,
    required this.icon,
    required this.isActive,
    required this.route,
  });
}
