import 'package:flutter/material.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/other_pages/paper_other_page_template.dart';

class MenuCardModel {
  final int orderNumber;
  final String title;
  final String desc;
  final IconData icon;
  final bool isActive;
  String? statusText;
  final String route;
  PaperOtherPageModel? extraItem;

  MenuCardModel({
    required this.orderNumber,
    required this.title,
    required this.desc,
    required this.icon,
    required this.isActive,
    required this.route,
    this.statusText,
    this.extraItem,
  });
}
