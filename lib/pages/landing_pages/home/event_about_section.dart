import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/spacing.dart';
import 'package:ybb_event_app/components/typography.dart';

class EventAboutSection extends StatefulWidget {
  const EventAboutSection({super.key});

  @override
  State<EventAboutSection> createState() => _EventAboutSectionState();
}

class _EventAboutSectionState extends State<EventAboutSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: blockPadding(context),
      child: Column(
        children: [
          Text(
            "Event ",
            style: headlineSecondaryTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          buildAboutCard("What is",
              "The Japan Youth Summit is an initiative program by the Youth Break the Boundaries Foundation, aspires to bring together outstanding young minds to collectively address future challenges and propose innovative solutions. Beyond individual brilliance, collaboration takes center stage, encouraging the commitment of young generations to collaborate for shared and improved goals.")
        ],
      ),
    );
  }

  buildAboutCard(String title, String desc) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          Text(title),
          Text(desc),
        ],
      ),
    );
  }
}
