import 'package:flutter/material.dart';

abstract class ScreenSizeHelper {
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    required T desktop,
  }) {
    var md = MediaQuery.of(context).size;
    var deviceWidth = md.shortestSide;

    // Devices with width >= 600 are categorized as desktop (including tablets)
    if (deviceWidth >= 600) {
      return desktop;
    } else {
      return mobile;
    }
  }
}
