import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/models/web_setting_home_model.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/banner_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/event_about_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/event_detail_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/gallery_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/timeline_section.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';
import 'package:ybb_event_app/services/progam_photo_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProgramInfoByUrlModel? programInfo;
  WebSettingHomeModel? homeSetting;
  List<ProgramPhotoModel>? programPhotos = [];

  @override
  void initState() {
    super.initState();

    LandingPageService()
        .getProgramInfo("https://worldyouthfest.com")
        .then((value) {
      //set program info to provider
      Provider.of<ProgramProvider>(context, listen: false)
          .setProgramInfo(value);

      setState(() {
        programInfo = value;
      });

      LandingPageService().getHomeSetting(programInfo!.id!).then((value) {
        setState(() {
          homeSetting = value;
        });
      });

      ProgramPhotoService().getProgramPhotos("").then((value) {
        setState(() {
          programPhotos = value;
        });
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    List<ProgramPhotoModel> currentProgramPhotos = [];

    if (programPhotos!.isNotEmpty) {
      currentProgramPhotos = programPhotos!
          .where((element) =>
              element.programCategoryId == programInfo!.programCategoryId!)
          .toList();
    }

    return programInfo == null || homeSetting == null || programPhotos == null
        ? const LoadingPage()
        : PageTemplate(
            programInfo: programInfo!,
            pageName: "Home",
            contents: [
              BannerSection(webSettingHome: homeSetting!),
              EventDetailSection(programInfo: programInfo!),
              EventAboutSection(
                programInfo: programInfo!,
                webSettingHome: homeSetting!,
                // get a random photo from programPhotos list
                programPhoto: currentProgramPhotos
                    .elementAt(Random().nextInt(currentProgramPhotos.length)),
              ),
              TimelineSection(
                programPhoto: currentProgramPhotos
                    .elementAt(Random().nextInt(currentProgramPhotos.length)),
              ),
              GallerySection(
                programPhotos: programPhotos!,
                programInfo: programInfo,
              ),
              const SizedBox(height: 50),
              Footer(
                programInfo: programInfo!,
              ),
            ],
          );
  }
}
