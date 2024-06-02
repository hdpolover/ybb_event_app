import 'package:flutter/material.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class UserAnnouncements extends StatefulWidget {
  const UserAnnouncements({super.key});

  @override
  State<UserAnnouncements> createState() => _UserAnnouncementsState();
}

class _UserAnnouncementsState extends State<UserAnnouncements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Announcements"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonMethods().buildNothingToShow(
            "No Announcements Available",
            "There are no announcements available at the moment. Please check back later.",
          ),
        ],
      ),
    );
  }
}
