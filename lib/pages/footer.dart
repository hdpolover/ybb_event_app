import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';
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
        child: ScreenSizeHelper.responsiveValue(
          context,
          mobile: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                child: Image.network(
                  programInfo.logoUrl!,
                  height: 70,
                  width: 70,
                ),
              ),
              Column(
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
                ],
              ),
            ],
          ),
          desktop: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                child: Image.network(
                  programInfo.logoUrl!,
                  height: 70,
                  width: 70,
                ),
              ),
              Column(
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
                ],
              ),
            ],
          ),
        ));
  }
}
