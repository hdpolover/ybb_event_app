import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/models/program_schedule_model.dart';
import 'package:ybb_event_app/services/schedule_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class TimelineSection extends StatefulWidget {
  final String programId;
  final String? programPhoto;
  final List<ProgramScheduleModel>? programSchedules;

  const TimelineSection(
      {super.key,
      this.programPhoto,
      required this.programId,
      required this.programSchedules});

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  buildTimeline() {
    List<TimelineTile> timeline = [];

    for (int i = 0; i < widget.programSchedules!.length; i++) {
      bool isFirst = i == 0;
      bool isLast = i == widget.programSchedules!.length - 1;
      bool isEven = i % 2 == 0;

      timeline.add(
        buildTimelineItem(
          isFirst,
          isLast,
          isEven,
          widget.programSchedules![i].name!,
          widget.programSchedules![i].startDate!,
          widget.programSchedules![i].endDate!,
        ),
      );
    }

    return timeline;
  }

  buildTimelineItem(bool isFirst, bool isLast, bool isEven, String title,
      DateTime start, DateTime end) {
    String formattedDate = CommonMethods().getEventDate(start, end);

    Widget textWidget = Column(
      children: [
        Text(
          title,
          style: bodyTextStyle.copyWith(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          formattedDate,
          style: bodyTextStyle.copyWith(color: Colors.white, fontSize: 20),
        ),
      ],
    );

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      alignment: TimelineAlign.center,
      indicatorStyle: const IndicatorStyle(
        width: 20,
        color: Colors.white,
        padding: EdgeInsets.all(8),
      ),
      startChild: isEven ? textWidget : null,
      endChild: isEven ? null : textWidget,
    );
  }

  bool isImageError = false;

  @override
  Widget build(BuildContext context) {
    return widget.programSchedules == null
        ? LoadingAnimationWidget.fourRotatingDots(color: primary, size: 20)
        : Container(
            // give a background image from network image and also a transparent color so that texts can be read
            decoration: isImageError
                ? const BoxDecoration(color: primary)
                : BoxDecoration(
                    image: DecorationImage(
                      onError: (exception, stackTrace) {
                        setState(() {
                          isImageError = true;
                        });
                      },
                      image: CachedNetworkImageProvider(
                        widget.programPhoto!,
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.darken),
                    ),
                  ),
            padding: commonPadding(context),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    "Program Timeline",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: buildTimeline(),
                  ),
                ),
              ],
            ),
          );
  }
}
