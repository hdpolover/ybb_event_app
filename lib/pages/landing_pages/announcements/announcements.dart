import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/components/announcement_list.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';

import '../../../providers/program_provider.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);

    return PageTemplate(
      programInfo: programProvider.programInfo!,
      pageName: "Announcements",
      contents: [
        const AnnouncementList(),
        Footer(programInfo: programProvider.programInfo!),
      ],
    );
  }
}
