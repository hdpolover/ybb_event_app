import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ybb_event_app/my_app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:web/web.dart' as web;

String mainUrl = "";
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  var url = web.window.location.href;

  debugPrint(url);

  if (url.contains("localhost")) {
    mainUrl = "https://youthacademicforum.com/";
  } else {
    mainUrl = url;
  }

  runApp(const MyApp());

  // Call setup function
  setupNativeCommunication();
}

Future<void> setupNativeCommunication() async {
  // Ensure initialization is completed
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize native communication
  try {
    MethodChannel channel = const MethodChannel('native_communication_channel');
    await channel.invokeMethod('initializeCommunication');
  } catch (e) {
    print('Error during native communication setup: $e');
  }
}
