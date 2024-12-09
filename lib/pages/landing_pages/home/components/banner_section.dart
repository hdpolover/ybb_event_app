import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/web_setting_home_model.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class BannerSection extends StatefulWidget {
  final WebSettingHomeModel webSettingHome;

  const BannerSection({
    super.key,
    required this.webSettingHome,
  });

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  // convert string to date time and then to duration
  Duration getDuration(String date) {
    DateTime dateTime = DateTime.parse(date);
    return dateTime.difference(DateTime.now());
  }

  buildBannerItem(String imgUrl, String title, String desc, String date) {
    var programProvider = Provider.of<ProgramProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // image
          Image.network(
            imgUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.8,
          ),
          // add a black overlay to the container
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
          ),
          Padding(
            padding: blockPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: headlineTextStyle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Text(
                  desc,
                  style: smallHeadlineTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 30),
                (programProvider.programInfo!.isActive == "0")
                    ? Text(
                        "Event has ended",
                        style: bodyTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : TimerCountdown(
                        timeTextStyle: headlineTextStyle.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        descriptionTextStyle: smallHeadlineTextStyle.copyWith(
                          color: Colors.white,
                        ),
                        colonsTextStyle: smallHeadlineTextStyle.copyWith(
                          color: Colors.white,
                        ),
                        format: CountDownTimerFormat.daysHoursMinutesSeconds,
                        endTime: DateTime.now().add(getDuration(date)),
                        onEnd: () {
                          debugPrint("Timer finished");
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildBannerMobile(String imgUrl) {
    return Image.network(
      imgUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sliders = ScreenSizeHelper.responsiveValue(
      context,
      desktop: [
        buildBannerItem(
            widget.webSettingHome.banner1ImgUrl!,
            widget.webSettingHome.banner1Title!,
            widget.webSettingHome.banner1Description!,
            widget.webSettingHome.banner1Date!),
        buildBannerItem(
            widget.webSettingHome.banner2ImgUrl!,
            widget.webSettingHome.banner2Title!,
            widget.webSettingHome.banner2Description!,
            widget.webSettingHome.banner2Date!),
      ],
      mobile: [
        buildBannerMobile(widget.webSettingHome.banner1MobileImgUrl!),
        buildBannerMobile(widget.webSettingHome.banner2MobileImgUrl!),
      ],
    );

    return SizedBox(
      width: double.infinity,
      height: ScreenSizeHelper.responsiveValue(context,
          desktop: MediaQuery.sizeOf(context).height * 0.8,
          mobile: MediaQuery.sizeOf(context).height * 0.7),
      child: Builder(
        builder: (context) {
          return FlutterCarousel(
            options: FlutterCarouselOptions(
              // height: ScreenSizeHelper.responsiveValue(context,
              //     desktop: MediaQuery.sizeOf(context).height * 0.7,
              //     mobile: MediaQuery.sizeOf(context).height * 0.7),
              enlargeCenterPage: false,
              // fullScreen: true,
              viewportFraction: 1.0,
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 10),
              slideIndicator: CircularWaveSlideIndicator(),
            ),
            items: sliders,
          );
        },
      ),
    );
  }
}
