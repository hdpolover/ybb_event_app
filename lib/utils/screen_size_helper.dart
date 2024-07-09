import 'package:flutter/material.dart';

abstract class ScreenSizeHelper {
  static T responsiveValue<T>(
    BuildContext context, {
    T? mobile,
    T? desktop,
  }) {
    var md = MediaQuery.of(context).size;
    var deviceWidth = md.shortestSide;
    // print(deviceWidth);
    if (deviceWidth >= 800 && desktop != null) {
      return desktop;
    } else {
      return mobile!;
    }
  }
}
