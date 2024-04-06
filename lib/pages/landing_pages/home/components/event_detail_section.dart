import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class EventDetailSection extends StatefulWidget {
  final ProgramInfoByUrlModel programInfo;
  const EventDetailSection({super.key, required this.programInfo});

  @override
  State<EventDetailSection> createState() => _EventDetailSectionState();
}

class _EventDetailSectionState extends State<EventDetailSection> {
  buildEventItem(String title, IconData icon, String content) {
    return ResponsiveRowColumnItem(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(title, style: smallHeadlineTextStyle),
            const SizedBox(height: 20),
            HtmlWidget(
              content,
              textStyle: bodyTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: blockPadding(context),
        child: Column(
          children: [
            // Text(
            //   "Event Details",
            //   style: headlineSecondaryTextStyle.copyWith(
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // const SizedBox(height: 20),
            ResponsiveRowColumn(
              layout: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildEventItem(
                    "Event Date",
                    FontAwesomeIcons.calendar,
                    CommonMethods().getEventDate(widget.programInfo.startDate!,
                        widget.programInfo.endDate!)),
                buildEventItem("Event Location", FontAwesomeIcons.locationPin,
                    widget.programInfo.location!),
                buildEventItem("Contact", FontAwesomeIcons.phone,
                    widget.programInfo.contact!),
                buildEventItem("Mail", FontAwesomeIcons.envelope,
                    widget.programInfo.email!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
