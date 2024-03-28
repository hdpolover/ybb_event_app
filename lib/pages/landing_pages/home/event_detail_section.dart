import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/components.dart';

class EventDetailSection extends StatefulWidget {
  const EventDetailSection({super.key});

  @override
  State<EventDetailSection> createState() => _EventDetailSectionState();
}

class _EventDetailSectionState extends State<EventDetailSection> {
  buildEventItem(String title, FaIcon icon, String content) {
    return ResponsiveRowColumnItem(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(title, style: smallHeadlineTextStyle),
            const SizedBox(height: 10),
            Text(
              content,
              style: bodyTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: blockPadding(context),
      child: Column(
        children: [
          Text(
            "Event Details",
            style: headlineSecondaryTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ResponsiveRowColumn(
            layout: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildEventItem(
                  "Event Date",
                  const FaIcon(
                    FontAwesomeIcons.calendar,
                    size: 30,
                  ),
                  "July 1 - 4, 2024"),
              buildEventItem(
                  "Event Location",
                  const FaIcon(
                    FontAwesomeIcons.locationPin,
                    size: 30,
                  ),
                  "Osaka, Japan"),
              buildEventItem(
                  "Contact",
                  const FaIcon(
                    FontAwesomeIcons.phone,
                    size: 30,
                  ),
                  "+623232424"),
              buildEventItem(
                  "Mail",
                  const FaIcon(
                    FontAwesomeIcons.envelope,
                    size: 30,
                  ),
                  "Jhk@mail.com"),
            ],
          ),
        ],
      ),
    );
  }
}
