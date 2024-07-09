import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/models/web_setting_about_model.dart';
import 'package:ybb_event_app/services/progam_photo_service.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class DetailSection extends StatefulWidget {
  final WebSettingAboutModel? aboutSetting;
  final ProgramInfoByUrlModel? programInfo;
  const DetailSection({super.key, this.aboutSetting, this.programInfo});

  @override
  State<DetailSection> createState() => _DetailSectionState();
}

class _DetailSectionState extends State<DetailSection> {
  List<ProgramPhotoModel>? programPhotos;

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  getPhotos() {
    ProgramPhotoService().getProgramPhotos("").then((value) {
      value
          .where((element) =>
              element.programCategoryId ==
              widget.programInfo!.programCategoryId!)
          .toList();

      setState(() {
        programPhotos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    double height = MediaQuery.of(context).size.height * 0.7;

    return Column(
      children: [
        programPhotos == null
            ? LoadingAnimationWidget.fourRotatingDots(color: primary, size: 20)
            : Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.network(programPhotos![0].imgUrl!),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.network(programPhotos![1].imgUrl!),
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 20),
        Padding(
          padding: blockPadding(context),
          child: ScreenSizeHelper.responsiveValue(
            context,
            mobile: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "About Youth Break the Boundaries (YBB) Foundation",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: headlineSecondaryTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  HtmlWidget(
                    widget.aboutSetting!.aboutYbb!,
                    textStyle: bodyTextStyle,
                  ),
                ],
              ),
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    "About Youth Break the Boundaries (YBB) Foundation",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: headlineSecondaryTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontSize: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: HtmlWidget(
                    widget.aboutSetting!.aboutYbb!,
                    textStyle: bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ScreenSizeHelper.responsiveValue(
          context,
          mobile: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // give the container an image background that blends with the color
                decoration: BoxDecoration(
                  color: primary,
                  image: DecorationImage(
                    image: const AssetImage("assets/images/pattern_1.png"),
                    fit: BoxFit.cover,
                    // blend image with color
                    colorFilter: ColorFilter.mode(
                      primary.withOpacity(0.5),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Padding(
                  padding: blockPadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "About ${widget.programInfo!.name}",
                        style: headlineSecondaryTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      Padding(
                        padding: blockPadding(context),
                        child: HtmlWidget(
                          widget.aboutSetting!.aboutProgram!,
                          textStyle:
                              bodyTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              programPhotos == null
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: primary, size: 20)
                  : Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: Image.network(
                              programPhotos![2].imgUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: Image.network(
                              programPhotos![3].imgUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
          desktop: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.6,
                // give the container an image background that blends with the color
                decoration: BoxDecoration(
                  color: primary,
                  image: DecorationImage(
                    image: const AssetImage("assets/images/pattern_1.png"),
                    fit: BoxFit.cover,
                    // blend image with color
                    colorFilter: ColorFilter.mode(
                      primary.withOpacity(0.5),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Padding(
                  padding: blockPadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "About ${widget.programInfo!.name}",
                        style: headlineSecondaryTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      Padding(
                        padding: blockPadding(context),
                        child: HtmlWidget(
                          widget.aboutSetting!.aboutProgram!,
                          textStyle:
                              bodyTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              programPhotos == null
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: primary, size: 20)
                  : Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.4,
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: Image.network(
                              programPhotos![2].imgUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: Image.network(
                              programPhotos![3].imgUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
        Padding(
          padding: blockPadding(context),
          child: HtmlWidget("""
               <iframe width="$width" height="$height" src="${widget.aboutSetting!.ybbVideoUrl!}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                """),
        ),
      ],
    );
  }
}
