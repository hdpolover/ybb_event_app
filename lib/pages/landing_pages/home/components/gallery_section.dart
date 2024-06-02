import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_category_model.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/services/program_category_service.dart';

class GallerySection extends StatefulWidget {
  final List<ProgramPhotoModel> programPhotos;
  final ProgramInfoByUrlModel? programInfo;

  const GallerySection(
      {super.key, required this.programPhotos, this.programInfo});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  List<ProgramCategoryModel>? programCategories = [];

  @override
  void initState() {
    super.initState();

    getCategories();
  }

  getCategories() {
    ProgramCategoryService().getProgramCategories().then((value) {
      setState(() {
        programCategories = value;
      });
    });
  }

  buildAllGallery() {
    List<Widget> gallery = [];

    for (int i = 0; i < programCategories!.length; i++) {
      if (widget.programInfo!.programCategoryId != programCategories![i].id!) {
        gallery.add(
          buildGalleryBasedOnProgramCategoryId(
            programCategories![i].name!,
            programCategories![i].id!,
          ),
        );
      }
    }

    return ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
        ? Column(children: gallery)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: gallery);
  }

  buildGalleryBasedOnProgramCategoryId(String programCategoryName, String id) {
    List<Widget> gallery = [];

    for (int i = 0; i < widget.programPhotos.length; i++) {
      if (widget.programPhotos[i].programCategoryId == id) {
        gallery.add(
          Image.network(
            widget.programPhotos[i].imgUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      }
    }

    return Center(
      child: Padding(
        padding: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
            : const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              programCategoryName,
              softWrap: true,
              style: headlineSecondaryTextStyle.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                maxWidth: ResponsiveBreakpoints.of(context).isMobile
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width * 0.3,
              ),
              child: FlutterCarousel(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.5,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: true,
                  enableInfiniteScroll: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  slideIndicator: CircularWaveSlideIndicator(),
                ),
                items: gallery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return programCategories == null
        ? LoadingAnimationWidget.hexagonDots(color: primary, size: 20)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    "YBB Program Gallery",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                buildAllGallery(),
              ],
            ),
          );
  }
}
