import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Margin
const EdgeInsets marginBottom12 = EdgeInsets.only(bottom: 12);
const EdgeInsets marginBottom24 = EdgeInsets.only(bottom: 24);
const EdgeInsets marginBottom40 = EdgeInsets.only(bottom: 40);

// Padding
const EdgeInsets paddingBottom24 = EdgeInsets.only(bottom: 24);
const EdgeInsets symmetric20 = EdgeInsets.symmetric(vertical: 20);

// Block Spacing
const List<Condition> blockWidthConstraints = [
  Condition.equals(name: MOBILE, value: BoxConstraints(maxWidth: 600)),
  Condition.equals(name: TABLET, value: BoxConstraints(maxWidth: 700)),
  Condition.largerThan(name: TABLET, value: BoxConstraints(maxWidth: 1280)),
];

EdgeInsets commonPadding(BuildContext context) =>
    ResponsiveValue<EdgeInsets>(context,
        defaultValue: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        conditionalValues: [
          const Condition.smallerThan(
              name: TABLET,
              value: EdgeInsets.symmetric(horizontal: 15, vertical: 20))
        ]).value;

EdgeInsets blockPadding(BuildContext context) =>
    ResponsiveValue<EdgeInsets>(context,
        defaultValue: const EdgeInsets.symmetric(horizontal: 55, vertical: 80),
        conditionalValues: [
          const Condition.smallerThan(
              name: TABLET,
              value: EdgeInsets.symmetric(horizontal: 15, vertical: 45))
        ]).value;

const EdgeInsets blockMargin = EdgeInsets.fromLTRB(10, 0, 10, 32);

SizedBox verticalSpace(double height) => SizedBox(height: height);
SizedBox horizontalSpace(double width) => SizedBox(width: width);

// Height
SizedBox height05 = SizedBox(height: 5.h);
SizedBox height1 = SizedBox(height: 10.h);
SizedBox height2 = SizedBox(height: 20.h);

// font size
double fontSize12 = 12.sp;
double fontSize14 = 14.sp;
double fontSize16 = 16.sp;
double fontSize18 = 18.sp;
double fontSize20 = 20.sp;
double fontSize24 = 24.sp;
double fontSize28 = 28.sp;
