import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/models/program_announcement_model.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/components/announcement_detail.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/components/announcement_widget.dart';
import 'package:ybb_event_app/providers/announcement_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/payment_service.dart';
import 'package:ybb_event_app/services/program_announcement_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class UserAnnouncements extends StatefulWidget {
  const UserAnnouncements({super.key});

  @override
  State<UserAnnouncements> createState() => _UserAnnouncementsState();
}

class _UserAnnouncementsState extends State<UserAnnouncements> {
  @override
  void initState() {
    super.initState();

    getAnnouncements();
  }

  Future<void> getAnnouncements() async {
    String programId = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;

    String? id = Provider.of<ParticipantProvider>(context, listen: false)
        .participant!
        .id;

    bool isParticipant = false;

    await PaymentService().getAll(id).then((value) async {
      value.any((element) => element.status == "2")
          ? isParticipant = true
          : isParticipant = false;

      // get announcements
      await ProgramAnnouncementService().getAll(programId).then((value) {
        if (isParticipant) {
          value = value.where((element) => element.visibleTo == "2").toList();
        }

        Provider.of<AnnouncementProvider>(context, listen: false)
            .removeAnnouncements();

        Provider.of<AnnouncementProvider>(context, listen: false)
            .setAnnouncements(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var announcementProvider = Provider.of<AnnouncementProvider>(context);

    List<ProgramAnnouncementModel> announcements =
        announcementProvider.announcements;
    var currentAnnouncement = announcementProvider.currentAnnouncement;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Announcements"),
      body: currentAnnouncement == null
          ? announcements.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      return AnnouncementWidget(
                          announcement: announcements[index]);
                    },
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonMethods().buildNothingToShow(
                      "No Announcements Available",
                      "There are no announcements available at the moment. Please check back later.",
                    ),
                  ],
                )
          : AnnouncementDetail(
              announcement: currentAnnouncement,
            ),
    );
  }
}
