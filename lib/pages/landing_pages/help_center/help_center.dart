import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/header_page.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  ProgramInfoByUrlModel? programInfo;

  @override
  void initState() {
    super.initState();

    LandingPageService()
        .getProgramInfo("https://worldyouthfest.com")
        .then((value) {
      setState(() {
        programInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return programInfo == null
        ? const LoadingPage()
        : PageTemplate(
            programInfo: programInfo!,
            pageName: "Help Center",
            contents: [
              const HeaderPage(
                  title: "Help Center", desc: "Keep in touch with us!"),
              Footer(
                programInfo: programInfo!,
              ),
            ],
          );
  }
}
