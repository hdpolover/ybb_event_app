import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_announcement_model.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/components/announcement_detail.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/components/announcement_widget.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/header_page.dart';
import 'package:ybb_event_app/providers/announcement_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/program_announcement_service.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  @override
  void initState() {
    super.initState();

    getAnnouncements();
  }

  Future<void> getAnnouncements() async {
    String programId = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;

    await ProgramAnnouncementService().getAll(programId).then((value) {
      Provider.of<AnnouncementProvider>(context, listen: false)
          .setAnnouncements(value);
    });
  }

  buildAnnouncementList(List<ProgramAnnouncementModel> announcements) {
    return announcements.isEmpty
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Padding(
              padding: blockPadding(context),
              child: const Center(
                child: Text(
                    "There is no announcement available at this moment. Check back later."),
              ),
            ),
          )
        : Padding(
            padding: blockPadding(context),
            child: GridView.builder(
              itemCount: announcements.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenSizeHelper.responsiveValue(context,
                    mobile: 2, desktop: 4),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                return AnnouncementWidget(announcement: announcements[index]);
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var announcementProvider = Provider.of<AnnouncementProvider>(context);
    var announcements = announcementProvider.announcements;
    var currentAnnouncement = announcementProvider.currentAnnouncement;

    return Column(
      children: [
        const HeaderPage(title: "Announcements", desc: "Stay updated with us!"),
        currentAnnouncement == null
            ? buildAnnouncementList(announcements)
            : AnnouncementDetail(announcement: currentAnnouncement),
      ],
    );
  }
}
