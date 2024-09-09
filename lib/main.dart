import 'package:flutter/material.dart';
import 'package:ybb_event_app/my_app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:web/web.dart' as web;

String mainUrl = "";

void main() {
  usePathUrlStrategy();

  var url = web.window.location.href;

  print(url);

  if (url == "http://localhost:63405/") {
    mainUrl = "https://istanbulyouthsummit.com/";
  } else {
    mainUrl = url;
  }

  runApp(const MyApp());
}
