import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/utils/utils.dart';

import '../components/components.dart';

class Footer extends StatelessWidget {
  final ProgramInfoByUrlModel programInfo;
  const Footer({super.key, required this.programInfo});

  buildSocMed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialMediaItem(FontAwesomeIcons.instagram, programInfo.instagram!),
        socialMediaItem(FontAwesomeIcons.youtube, programInfo.youtube!),
        socialMediaItem(FontAwesomeIcons.tiktok, programInfo.tiktok!),
        socialMediaItem(FontAwesomeIcons.telegram, programInfo.telegram!),
      ],
    );
  }

  socialMediaItem(IconData icon, String url) {
    FaIcon thisIcon = FaIcon(icon, color: Colors.white, size: 20);

    return IconButton(
      icon: thisIcon,
      onPressed: () {
        openUrl(url);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: imageBgDecorStyle,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: ResponsiveRowColumn(
        layout: ResponsiveBreakpoints.of(context).isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        columnMainAxisSize: MainAxisSize.min,
        columnMainAxisAlignment: MainAxisAlignment.center,
        rowMainAxisSize: MainAxisSize.min,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        rowMainAxisAlignment: MainAxisAlignment.center,
        children: [
          ResponsiveRowColumnItem(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
              child: Image.network(
                programInfo.logoUrl!,
                height: 70,
                width: 70,
              ),
            ),
          ),
          ResponsiveRowColumnItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("SOCIAL MEDIA",
                    style: headlineSecondaryTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    )),
                buildSocMed(),
                const SizedBox(height: 10),
                Text(
                  "Copyright © 2024 Youth Break the Boundaries Foundation. All rights reserved.",
                  softWrap: true,
                  style: bodyTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                // RichText(
                //   textAlign: TextAlign.left,
                //   text: TextSpan(
                //     style: bodyTextStyle.copyWith(
                //         fontSize: 14, color: Colors.white, height: 2),
                //     children: [
                //       TextSpan(
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               openUrl(
                //                   "https://groups.google.com/forum/#!forum/flutter-dev");
                //             },
                //           text: "flutter-dev@"),
                //       const TextSpan(text: "  •  "),
                //       TextSpan(
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               openUrl("https://flutter.dev/tos");
                //             },
                //           text: "terms"),
                //       const TextSpan(text: "  •  "),
                //       TextSpan(
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               openUrl("https://flutter.dev/security");
                //             },
                //           text: "security"),
                //       const TextSpan(text: "  •  "),
                //       TextSpan(
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               openUrl(
                //                   "https://www.google.com/intl/en/policies/privacy");
                //             },
                //           text: "privacy"),
                //       const TextSpan(text: "  •  "),
                //       TextSpan(
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               openUrl("https://flutter-es.io/");
                //             },
                //           text: "español"),
                //       const TextSpan(text: "  •  "),
                //       TextSpan(
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               openUrl("https://flutter.cn/");
                //             },
                //           text: "社区中文资源"),
                //     ],
                //   ),
                // ),
                // RichText(
                //   textAlign: TextAlign.left,
                //   text: TextSpan(
                //       style: bodyTextStyle.copyWith(
                //           fontSize: 14, color: Colors.white, height: 1),
                //       children: [
                //         const TextSpan(text: '\n'),
                //         TextSpan(
                //             text:
                //                 "Except as otherwise noted, this work is licensed under a Creative Commons Attribution 4.0 International License, and code samples are licensed under the BSD License.",
                //             style: bodyTextStyle.copyWith(
                //                 fontSize: 10, color: Colors.white)),
                //         const TextSpan(text: '\n'),
                //         const TextSpan(text: '\n'),
                //         const TextSpan(text: '\n'),
                //       ]),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
