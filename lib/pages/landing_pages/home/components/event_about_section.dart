import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/spacing.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/models/web_setting_home_model.dart';

class EventAboutSection extends StatefulWidget {
  final ProgramInfoByUrlModel programInfo;
  final WebSettingHomeModel webSettingHome;
  final ProgramPhotoModel programPhoto;

  const EventAboutSection(
      {super.key,
      required this.programInfo,
      required this.webSettingHome,
      required this.programPhoto});

  @override
  State<EventAboutSection> createState() => _EventAboutSectionState();
}

class _EventAboutSectionState extends State<EventAboutSection> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumnItem(
      child: Container(
        color: Colors.white,
        child: ResponsiveRowColumn(
          layout: ResponsiveRowColumnType.COLUMN,
          rowMainAxisAlignment: MainAxisAlignment.start,
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          columnMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Event Details",
            //   style: headlineSecondaryTextStyle.copyWith(
            //     fontWeight: FontWeight.bold,
            //     color: primary,
            //     decoration: TextDecoration.underline,
            //     decorationStyle: TextDecorationStyle.solid,
            //     decorationColor: primary,
            //   ),
            // ),
            ResponsiveRowColumnItem(
              child: ResponsiveRowColumn(
                layout:
                    ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                children: [
                  ResponsiveRowColumnItem(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveBreakpoints.of(context)
                                .smallerOrEqualTo(MOBILE)
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width * 0.5,
                        maxHeight: 600,
                      ),
                      child: Image.network(widget.programPhoto.imgUrl!,
                          fit: BoxFit.cover),
                    ),
                  ),
                  buildAboutItem("What is ${widget.programInfo.name!}?",
                      "${widget.webSettingHome.introduction}"),
                ],
              ),
            ),
            const ResponsiveRowColumnItem(child: SizedBox(height: 20)),
            ResponsiveRowColumnItem(
              child: ResponsiveRowColumn(
                layout:
                    ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                rowPadding: commonPadding(context),
                columnCrossAxisAlignment: CrossAxisAlignment.start,
                rowCrossAxisAlignment: CrossAxisAlignment.start,
                columnMainAxisAlignment: MainAxisAlignment.start,
                rowMainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildAboutSecondItem(
                      "Why should you join ${widget.programInfo.name!}?",
                      "${widget.webSettingHome.reason}"),
                  buildAboutSecondItem(
                      "What are the objectives of the ${widget.programInfo.name!}?",
                      "${widget.webSettingHome.summary}"),
                  buildAboutSecondItem(
                      "What are the agendas of the ${widget.programInfo.name!}?",
                      "${widget.webSettingHome.agenda}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildAboutSecondItem(String title, String desc) {
    return ResponsiveRowColumnItem(
      child: Expanded(
        child: Padding(
          padding: blockPadding(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FaIcon(FontAwesomeIcons.arrowRight,
                  color: primary, size: 40),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      softWrap: true,
                      style: headlineSecondaryTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primary,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    HtmlWidget(
                      desc,
                      textStyle: bodyTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildAboutItem(String title, String desc) {
    return ResponsiveRowColumnItem(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                title,
                softWrap: true,
                style: headlineSecondaryTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              HtmlWidget(
                desc,
                textStyle: bodyTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildAboutCard(String title, String desc) {
    return ResponsiveRowColumnItem(
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
            minWidth: 300,
            minHeight: 400,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  title,
                  style: smallHeadlineTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(desc),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
