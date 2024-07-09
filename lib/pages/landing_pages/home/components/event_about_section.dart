import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/spacing.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/models/web_setting_home_model.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

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
  buildForMobile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: ScreenSizeHelper.responsiveValue(context,
                  mobile: MediaQuery.of(context).size.width,
                  desktop: MediaQuery.of(context).size.width * 0.5),
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              minHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: FancyShimmerImage(
              imageUrl: widget.programPhoto.imgUrl!,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              boxFit: BoxFit.cover,
            ),
          ),
          buildAboutItem("What is ${widget.programInfo.name!}?",
              "${widget.webSettingHome.introduction}"),
          const SizedBox(height: 20),
          buildAboutItem("Why should you join ${widget.programInfo.name!}?",
              "${widget.webSettingHome.reason}"),
          const SizedBox(height: 20),
          buildAboutItem(
              "What are the objectives of the ${widget.programInfo.name!}?",
              "${widget.webSettingHome.summary}"),
          const SizedBox(height: 20),
          buildAboutItem(
              "What are the agendas of the ${widget.programInfo.name!}?",
              "${widget.webSettingHome.agenda}"),
        ],
      ),
    );
  }

  buildForDesktop() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              FancyShimmerImage(
                imageUrl: widget.programPhoto.imgUrl!,
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.7,
                boxFit: BoxFit.cover,
              ),
              Expanded(
                child: buildAboutItem("What is ${widget.programInfo.name!}?",
                    "${widget.webSettingHome.introduction}"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSizeHelper.responsiveValue(
      context,
      mobile: buildForMobile(),
      desktop: buildForDesktop(),
    );
  }

  buildAboutSecondItem(String title, String desc) {
    return SizedBox(
      width: ScreenSizeHelper.responsiveValue(context,
          mobile: MediaQuery.sizeOf(context).width,
          desktop: MediaQuery.sizeOf(context).width * 0.3),
      child: Padding(
        padding: blockPadding(context),
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
    );
  }

  buildAboutItem(String title, String desc) {
    return Padding(
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
    );
  }

  buildAboutCard(String title, String desc) {
    return Card(
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
            mainAxisSize: MainAxisSize.min,
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
    );
  }
}
