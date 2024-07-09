import 'package:flutter/material.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/program_model.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';
import 'package:ybb_event_app/utils/utils.dart';

class GuidelineWidget extends StatelessWidget {
  final ProgramModel program;
  const GuidelineWidget({super.key, required this.program});

  buildForMobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // icon for document
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.description,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name
              Text("${program.name} Guideline",
                  style: headlineTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )),
              const SizedBox(height: 10),
              // email but hide the first 5 characters
              Text("Learn more about the guideline for ${program.name}",
                  style: bodyTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // a button to download the guideline, when pressed will open a link
        TextButton.icon(
          onPressed: () {
            openUrl(program.guideline!);
          },
          icon: const Icon(
            Icons.download,
            color: Colors.white,
          ),
          label: const Text(
            "View And Download",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  buildForDesktop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // icon for document
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.description,
            color: Colors.white,
            size: 50,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name
                Text("${program.name} Guideline",
                    style: headlineTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
                const SizedBox(height: 10),
                // email but hide the first 5 characters
                Text("Learn more about the guideline for ${program.name}",
                    style: bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
        ),
        // a button to download the guideline, when pressed will open a link
        TextButton.icon(
          onPressed: () {
            openUrl(program.guideline!);
          },
          icon: const Icon(
            Icons.download,
            color: Colors.white,
          ),
          label: const Text(
            "View And Download",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        // give this container radius and elevation
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ScreenSizeHelper.responsiveValue(context,
            desktop: buildForDesktop(), mobile: buildForMobile()),
      ),
    );
  }
}
