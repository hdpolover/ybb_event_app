import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/testimony_model.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class TestimonySection extends StatefulWidget {
  final List<TestimonyModel>? testimonies;
  const TestimonySection({super.key, this.testimonies});

  @override
  State<TestimonySection> createState() => _TestimonySectionState();
}

class _TestimonySectionState extends State<TestimonySection> {
  buildForMobile(TestimonyModel test) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              test.imgUrl!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            test.personName!,
            softWrap: true,
            style: headlineSecondaryTextStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            test.occupation!,
            softWrap: true,
            textAlign: TextAlign.center,
            style: bodyTextStyle.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// align to the left
              const Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  FontAwesomeIcons.quoteLeft,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                test.testimony!,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: bodyTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  FontAwesomeIcons.quoteRight,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildForDesktop(TestimonyModel test) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // make the image a circle
                ClipOval(
                  child: Image.network(
                    test.imgUrl!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  test.personName!,
                  softWrap: true,
                  style: headlineSecondaryTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  test.occupation!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: bodyTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// align to the left
                const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    FontAwesomeIcons.quoteLeft,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  test.testimony!,
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: bodyTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    FontAwesomeIcons.quoteRight,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildTestimonyItem(TestimonyModel test) {
    return ScreenSizeHelper.responsiveValue(context,
        mobile: buildForMobile(test), desktop: buildForDesktop(test));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sliders = [];

    for (var i = 0; i < widget.testimonies!.length; i++) {
      sliders.add(buildTestimonyItem(widget.testimonies![i]));
    }

    return SizedBox(
      width: double.infinity,
      height: ScreenSizeHelper.responsiveValue(context,
          desktop: MediaQuery.of(context).size.height * 0.7,
          mobile: MediaQuery.of(context).size.height * 0.7),
      child: Builder(
        builder: (context) {
          return FlutterCarousel(
            options: FlutterCarouselOptions(
              // height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 10),
              showIndicator: false,
            ),
            items: sliders,
          );
        },
      ),
    );
  }
}
