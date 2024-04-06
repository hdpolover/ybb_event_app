import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/web_setting_about_model.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/about_us/components/detail_section.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/header_page.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/video_player_widget.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  WebSettingAboutModel? aboutSetting;

  @override
  void initState() {
    super.initState();

    getAboutSetting();
  }

  getAboutSetting() {
    String id =
        Provider.of<ProgramProvider>(context, listen: false).programInfo!.id!;

    LandingPageService().getAboutSetting(id).then((value) {
      setState(() {
        aboutSetting = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);

    return aboutSetting == null
        ? const LoadingPage()
        : PageTemplate(
            programInfo: programProvider.programInfo!,
            pageName: "About Us",
            contents: [
              const HeaderPage(title: "About Us", desc: "Learn more about us!"),
              //VideoPlayerWidget(videoUrl: aboutSetting!.ybbVideoUrl!),
              DetailSection(
                programInfo: programProvider.programInfo!,
                aboutSetting: aboutSetting!,
              ),
              Footer(programInfo: programProvider.programInfo!),
            ],
          );
  }
}

List<Widget> blocks = [
  // MaxWidthBox(
  //   maxWidth: 1200,
  //   child: FittedBox(
  //     fit: BoxFit.fitWidth,
  //     alignment: Alignment.topCenter,
  //     child: Container(
  //         width: 1200,
  //         height: 640,
  //         alignment: Alignment.center,
  //         child: RepaintBoundary(child: Carousel())),
  //   ),
  // ),
  // const BlockWrapper(GetStarted()),
  // const BlockWrapper(Features()),
  // const BlockWrapper(FastDevelopment()),
  // const BlockWrapper(BeautifulUI()),
  // const BlockWrapper(NativePerformance()),
  // const BlockWrapper(LearnFromDevelopers()),
  // const BlockWrapper(WhoUsesFlutter()),
  // // Disabled codelab block for performance.
  // if (kIsWeb || Platform.isAndroid || Platform.isIOS)
  //   const ResponsiveVisibility(
  //     hiddenConditions: [Condition.smallerThan(name: DESKTOP)],
  //     child: BlockWrapper(FlutterCodelab()),
  //   ),
  // const BlockWrapper(FlutterNewsRow()),
  // const BlockWrapper(InstallFlutter()),
];
