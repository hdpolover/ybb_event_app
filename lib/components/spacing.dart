import 'package:flutter/material.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

// Margin
const EdgeInsets marginBottom12 = EdgeInsets.only(bottom: 12);
const EdgeInsets marginBottom24 = EdgeInsets.only(bottom: 24);
const EdgeInsets marginBottom40 = EdgeInsets.only(bottom: 40);

// Padding
const EdgeInsets paddingBottom24 = EdgeInsets.only(bottom: 24);
const EdgeInsets symmetric20 = EdgeInsets.symmetric(vertical: 20);

EdgeInsets commonPadding(BuildContext context) =>
    ScreenSizeHelper.responsiveValue(context,
        desktop: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        mobile: const EdgeInsets.symmetric(horizontal: 15, vertical: 20));

EdgeInsets blockPadding(BuildContext context) =>
    ScreenSizeHelper.responsiveValue(context,
        desktop: const EdgeInsets.symmetric(horizontal: 55, vertical: 80),
        mobile: const EdgeInsets.symmetric(horizontal: 15, vertical: 45));

const EdgeInsets blockMargin = EdgeInsets.fromLTRB(10, 0, 10, 32);

SizedBox verticalSpace(double height) => SizedBox(height: height);
SizedBox horizontalSpace(double width) => SizedBox(width: width);

// // Height
// SizedBox height05 = SizedBox(height: 5.h);
// SizedBox height1 = SizedBox(height: 10.h);
// SizedBox height2 = SizedBox(height: 20.h);

// // font size
// double fontSize12 = 12.sp;
// double fontSize14 = 14.sp;
// double fontSize16 = 16.sp;
// double fontSize18 = 18.sp;
// double fontSize20 = 20.sp;
// double fontSize24 = 24.sp;
// double fontSize28 = 28.sp;
