import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/web_setting_home_model.dart';

class BannerSection extends StatefulWidget {
  final WebSettingHomeModel webSettingHome;

  const BannerSection({super.key, required this.webSettingHome});

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
    return Container(
      width: double.infinity,
      // add background image to the container
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 70,
        ),
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
            TimerCountdown(
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
                print("Timer finished");
              },
            ),
          ],
        ),
      ),
    );
  }

  buildBannerMobile(String imgUrl) {
    return Image.network(
      widget.webSettingHome.banner1ImgUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sliders =
        ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
            ? [
                buildBannerMobile(widget.webSettingHome.banner1MobileImgUrl!),
                buildBannerMobile(widget.webSettingHome.banner2MobileImgUrl!),
              ]
            : [
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
              ];

    return Center(
      child: Builder(
        builder: (context) {
          final height = MediaQuery.of(context).size.height * 0.7;

          return FlutterCarousel(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
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
