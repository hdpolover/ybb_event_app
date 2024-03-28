import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/spacing.dart';

/// A convenience widget to wrap main blocks with:
///  - ResponsiveContraints for max width.
///  - A Center to allow constraints to work in a List.
class BlockWrapper extends StatelessWidget {
  final Widget widget;

  const BlockWrapper(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResponsiveConstraints(
        conditionalConstraints:
            blockWidthConstraints as List<Condition<BoxConstraints>>,
        child: widget,
      ),
    );
  }
}
