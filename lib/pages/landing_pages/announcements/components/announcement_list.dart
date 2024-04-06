import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/components/announcement_widget.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/header_page.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  buildAnnouncementList() {
    List<AnnouncementWidget> anns =
        List.generate(5, (index) => const AnnouncementWidget());

    return ResponsiveGridView.builder(
      itemCount: anns.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      gridDelegate: const ResponsiveGridDelegate(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 200,
      ),
      itemBuilder: (context, index) {
        return anns[index];
      },
    );

    // return ResponsiveRowColumn(
    //   layout: ResponsiveRowColumnType.COLUMN,
    //   children: List.generate(
    //       anns.length, (index) => ResponsiveRowColumnItem(child: anns[index])),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumnItem(
      child: Column(
        children: [
          const HeaderPage(
              title: "Announcements", desc: "Stay updated with us!"),
          buildAnnouncementList(),
        ],
      ),
    );
  }
}
