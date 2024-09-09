import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/spacing.dart';
import 'package:ybb_event_app/main.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/models/testimony_model.dart';
import 'package:ybb_event_app/models/web_setting_home_model.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/banner_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/event_about_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/event_detail_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/gallery_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/testimony_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/components/timeline_section.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/guideline_widget.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';
import 'package:ybb_event_app/services/progam_photo_service.dart';
import 'package:ybb_event_app/services/program_service.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProgramInfoByUrlModel? programInfo;
  WebSettingHomeModel? homeSetting;
  List<ProgramPhotoModel>? programPhotos = [];
  List<TestimonyModel>? testimonies = [];
  ProgramModel? currentProgram;

  @override
  void initState() {
    super.initState();

    LandingPageService().getProgramInfo(mainUrl).then((value) {
      //set program info to provider
      Provider.of<ProgramProvider>(context, listen: false)
          .setProgramInfo(value);

      setState(() {
        programInfo = value;
      });

      ProgramService().getProgramById(programInfo!.id!).then((value) {
        //set current program to provider
        Provider.of<ProgramProvider>(context, listen: false)
            .setCurrentProgram(value);

        setState(() {
          currentProgram = value;
        });

        LandingPageService().getHomeSetting(programInfo!.id!).then((value) {
          setState(() {
            homeSetting = value;
          });

          ProgramPhotoService()
              .getProgramPhotos(programInfo!.programCategoryId)
              .then((value) {
            setState(() {
              programPhotos = value;
            });

            LandingPageService().getTestimonies(programInfo!.id!).then((value) {
              setState(() {
                testimonies = value;
              });
            });
          });
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
    double width = MediaQuery.of(context).size.width * 0.7;
    double height = MediaQuery.of(context).size.height * 0.7;

    List<ProgramPhotoModel> currentProgramPhotos = [];

    if (programPhotos!.isNotEmpty) {
      currentProgramPhotos = programPhotos!
          .where((element) =>
              element.programCategoryId == programInfo!.programCategoryId!)
          .toList();
    }

    return programInfo == null ||
            homeSetting == null ||
            programPhotos == null ||
            testimonies == null ||
            currentProgram == null
        ? const LoadingPage()
        : PageTemplate(
            programInfo: programInfo!,
            pageName: "Home",
            contents: [
              BannerSection(
                webSettingHome: homeSetting!,
              ),
              EventDetailSection(programInfo: programInfo!),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.03),
                child: GuidelineWidget(program: currentProgram!),
              ),
              Center(
                child: Padding(
                  padding: blockPadding(context),
                  child: HtmlWidget("""
               <iframe width="$width" height="$height" src="${programInfo!.registrationVideoUrl}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                  """),
                ),
              ),
              EventAboutSection(
                programInfo: programInfo!,
                webSettingHome: homeSetting!,
                // get a random photo from programPhotos list
                programPhoto: currentProgramPhotos.isNotEmpty
                    ? currentProgramPhotos.elementAt(
                        Random().nextInt(currentProgramPhotos.length))
                    : ProgramPhotoModel(imgUrl: ""),
              ),
              TimelineSection(
                programId: programInfo!.id!,
                programPhoto: currentProgramPhotos.isNotEmpty
                    ? currentProgramPhotos.elementAt(
                        Random().nextInt(currentProgramPhotos.length))
                    : ProgramPhotoModel(imgUrl: ""),
              ),
              GallerySection(
                programPhotos: programPhotos!,
                programInfo: programInfo,
              ),
              const SizedBox(height: 50),
              TestimonySection(
                testimonies: testimonies,
              ),
              const SizedBox(height: 50),
              Footer(
                programInfo: programInfo!,
              ),
            ],
          );
  }
}
