import 'package:flutter/material.dart';

import 'components.dart';

const String fontFamily = "Google Sans";

// Simple
const TextStyle headlineTextStyle = TextStyle(
    fontSize: 44, color: textPrimary, height: 1.2, fontFamily: fontFamily);

const TextStyle headlineSecondaryTextStyle = TextStyle(
    fontSize: 28, color: textPrimary, height: 1.2, fontFamily: fontFamily);

const TextStyle smallHeadlineTextStyle = TextStyle(
    fontSize: 21,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    height: 1.2,
    fontFamily: fontFamily);

const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16, color: textPrimary, height: 1.5, fontFamily: "Roboto");

TextStyle bodyLinkTextStyle = bodyTextStyle.copyWith(color: primary);

const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18, color: Colors.white, height: 1, fontFamily: fontFamily);

// Carousel
const TextStyle carouselBlueTextStyle = TextStyle(
    fontSize: 100,
    color: Color(0xFF008AFE),
    fontFamily: fontFamily,
    shadows: [
      Shadow(
        color: Color(0x40000000),
        offset: Offset(1, 1),
        blurRadius: 2,
      )
    ]);

const TextStyle carouselWhiteTextStyle = TextStyle(
    fontSize: 100,
    color: Colors.white,
    fontFamily: fontFamily,
    shadows: [
      Shadow(
        color: Color(0x40000000),
        offset: Offset(1, 1),
        blurRadius: 2,
      )
    ]);

ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primary),
    overlayColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return buttonPrimaryDark;
        }
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.pressed)) {
          return buttonPrimaryDarkPressed;
        }
        return primary;
      },
    ),
    // Shape sets the border radius from default 3 to 0.
    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.pressed)) {
          return const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)));
        }
        return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)));
      },
    ),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 22, horizontal: 28)),
    // Side adds pressed highlight outline.
    side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return const BorderSide(width: 3, color: buttonPrimaryPressedOutline);
      }
      // Transparent border placeholder as Flutter does not allow
      // negative margins.
      return const BorderSide(width: 3, color: Colors.white);
    }));

BoxDecoration imageBgDecorStyle = BoxDecoration(
  color: primary,
  image: DecorationImage(
    image: const AssetImage("assets/images/pattern_1.png"),
    fit: BoxFit.cover,
    // blend image with color
    colorFilter: ColorFilter.mode(
      primary.withOpacity(0.5),
      BlendMode.dstATop,
    ),
  ),
);
