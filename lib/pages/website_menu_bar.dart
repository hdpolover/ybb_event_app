import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

import '../components/components.dart';

class WebsiteMenuBar extends StatelessWidget {
  const WebsiteMenuBar({super.key});

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
                padding: const EdgeInsets.fromLTRB(0, 5, 16, 5),
                child: Icon(
                  Icons.home,
                ),
              ),
            ),
          ),
          const Spacer(),
          ResponsiveVisibility(
            visible: false,
            visibleConditions: const [
              Condition.smallerThan(name: MOBILE),
              Condition.equals(name: MOBILE)
            ],
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.menu, color: textPrimary, size: 28),
            ),
          ),
          ResponsiveVisibility(
            visible: false,
            visibleConditions: const [Condition.largerThan(name: MOBILE)],
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.goNamed("home");
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
                  context.goNamed("about-us");
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
                onTap: () => openUrl("https://flutter.dev/showcase"),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Showcase",
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
                onTap: () => openUrl("https://flutter.dev/community"),
                child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Community",
                        style: TextStyle(
                            fontSize: 16,
                            color: navLinkColor,
                            fontFamily: fontFamily))),
              ),
            ),
          ),
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
                onPressed: () =>
                    openUrl("https://flutter.dev/docs/get-started/install"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primary),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return buttonPrimaryDark;
                        }
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed)) {
                          return buttonPrimaryDarkPressed;
                        }
                        return primary;
                      },
                    ),
                    // Shape sets the border radius from default 3 to 0.
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed)) {
                          return const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)));
                        }
                        return const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)));
                      },
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 22, horizontal: 28)),
                    // Side adds pressed highlight outline.
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)) {
                        return const BorderSide(
                            width: 3, color: buttonPrimaryPressedOutline);
                      }
                      // Transparent border placeholder as Flutter does not allow
                      // negative margins.
                      return const BorderSide(width: 3, color: Colors.white);
                    })),
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
