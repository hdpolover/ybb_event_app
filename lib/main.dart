import 'package:flutter/material.dart';
import 'package:ybb_event_app/my_app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();

  runApp(const MyApp());
}
