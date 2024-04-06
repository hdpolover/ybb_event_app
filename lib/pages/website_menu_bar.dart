import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:go_router/go_router.dart';

import '../components/components.dart';

class WebsiteMenuBar extends StatelessWidget {
  final ProgramInfoByUrlModel programInfo;
  const WebsiteMenuBar({super.key, required this.programInfo});

  @override
  Widget build(BuildContext context) {
    const Color navLinkColor = Color(0xFF6E7274);

    return Container(
      height: 66,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4)
      ]),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.network(programInfo.logoUrl!),
              ),
            ),
          ),
          const Spacer(),
          const ResponsiveVisibility(
            visible: false,
            visibleConditions: [
              Condition.smallerThan(name: MOBILE),
              Condition.equals(name: MOBILE)
            ],
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.menu),
            ),
          ),
          ResponsiveVisibility(
            visible: false,
            visibleConditions: const [Condition.largerThan(name: MOBILE)],
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(homeRouteName);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Home",
                      style: TextStyle(
                          fontSize: 16,
                          color: navLinkColor,
                          fontFamily: fontFamily)),
                ),
              ),
            ),
          ),
          ResponsiveVisibility(
            visible: false,
            visibleConditions: const [Condition.largerThan(name: MOBILE)],
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(aboutUsRouteName);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("About Us",
                      style: TextStyle(
                          fontSize: 16,
                          color: navLinkColor,
                          fontFamily: fontFamily)),
                ),
              ),
            ),
          ),
          ResponsiveVisibility(
            visible: false,
            visibleConditions: const [Condition.largerThan(name: MOBILE)],
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(sponsorshipsRouteName);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Partnerships & Sponsorships",
                      style: TextStyle(
                          fontSize: 16,
                          color: navLinkColor,
                          fontFamily: fontFamily)),
                ),
              ),
            ),
          ),
          // ResponsiveVisibility(
          //   visible: false,
          //   visibleConditions: const [Condition.largerThan(name: MOBILE)],
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.click,
          //     child: GestureDetector(
          //       onTap: () {
          //         context.goNamed(announcementsRouteName);
          //       },
          //       child: const Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 16),
          //         child: Text("Announcements",
          //             style: TextStyle(
          //                 fontSize: 16,
          //                 color: navLinkColor,
          //                 fontFamily: fontFamily)),
          //       ),
          //     ),
          //   ),
          // ),
          ResponsiveVisibility(
            visible: false,
            visibleConditions: const [Condition.largerThan(name: MOBILE)],
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(faqsRouteName);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("FAQs",
                      style: TextStyle(
                          fontSize: 16,
                          color: navLinkColor,
                          fontFamily: fontFamily)),
                ),
              ),
            ),
          ),
          // ResponsiveVisibility(
          //   visible: false,
          //   visibleConditions: const [Condition.largerThan(name: MOBILE)],
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.click,
          //     child: GestureDetector(
          //       onTap: () {
          //         context.goNamed(helpCenterRouteName);
          //       },
          //       child: const Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 16),
          //         child: Text("Help Center",
          //             style: TextStyle(
          //                 fontSize: 16,
          //                 color: navLinkColor,
          //                 fontFamily: fontFamily)),
          //       ),
          //     ),
          //   ),
          // ),

          // ResponsiveVisibility(
          //   visible: false,
          //   visibleConditions: const [Condition.largerThan(name: MOBILE)],
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.click,
          //     child: GestureDetector(
          //       onTap: () => openUrl("https://flutter.dev/community"),
          //       child: const Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 16),
          //           child: Text("Community",
          //               style: TextStyle(
          //                   fontSize: 16,
          //                   color: navLinkColor,
          //                   fontFamily: fontFamily))),
          //     ),
          //   ),
          // ),
          // const ResponsiveVisibility(
          //   visible: false,
          //   visibleConditions: [Condition.largerThan(name: MOBILE)],
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.click,
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 18),
          //       child: ImageIcon(
          //           AssetImage("assets/images/icon_search_64x.png"),
          //           color: navLinkColor,
          //           size: 24),
          //     ),
          //   ),
          // ),
          // MouseRegion(
          //   cursor: SystemMouseCursors.click,
          //   child: GestureDetector(
          //     onTap: () => openUrl('https://twitter.com/flutterdev'),
          //     child: const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 8),
          //       child: ImageIcon(
          //           AssetImage("assets/images/icon_twitter_64x.png"),
          //           color: navLinkColor,
          //           size: 24),
          //     ),
          //   ),
          // ),
          // MouseRegion(
          //   cursor: SystemMouseCursors.click,
          //   child: GestureDetector(
          //     onTap: () => openUrl('https://www.youtube.com/flutterdev'),
          //     child: const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 8),
          //       child: ImageIcon(
          //           AssetImage("assets/images/icon_youtube_64x.png"),
          //           color: navLinkColor,
          //           size: 24),
          //     ),
          //   ),
          // ),
          // MouseRegion(
          //   cursor: SystemMouseCursors.click,
          //   child: GestureDetector(
          //     onTap: () => openUrl('https://github.com/flutter'),
          //     child: const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 8),
          //       child: ImageIcon(
          //           AssetImage("assets/images/icon_github_64x.png"),
          //           color: navLinkColor,
          //           size: 24),
          //     ),
          //   ),
          // ),
          ResponsiveVisibility(
            visible: false,
            visibleConditions: const [Condition.largerThan(name: MOBILE)],
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 0),
              child: TextButton(
                onPressed: () {
                  context.pushNamed(authRouteName);
                },
                style: primaryButtonStyle,
                child: Text(
                  "Get started",
                  style: buttonTextStyle.copyWith(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
