import 'package:flutter/material.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/components/announcement_widget.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/header_page.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  buildAnnouncementList() {
    List<AnnouncementWidget> anns =
        List.generate(5, (index) => const AnnouncementWidget());

    return GridView.builder(
      itemCount: anns.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            ScreenSizeHelper.responsiveValue(context, mobile: 1, desktop: 3),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
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
    return Column(
      children: [
        const HeaderPage(title: "Announcements", desc: "Stay updated with us!"),
        buildAnnouncementList(),
      ],
    );
  }
}
