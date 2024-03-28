import 'package:flutter/material.dart';
import 'package:ybb_event_app/pages/block_wrapper.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/home/banner_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/event_about_section.dart';
import 'package:ybb_event_app/pages/landing_pages/home/event_detail_section.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageName: "Home",
      contents: blocks,
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
  const BannerSection(),
  const EventDetailSection(),
  const EventAboutSection(),
  const Spacer(),
  const Footer(),
];
