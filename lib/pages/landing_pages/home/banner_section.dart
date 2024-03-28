import 'package:flutter/material.dart';
import 'package:ybb_event_app/components/components.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Text(
        "Banner",
        style: headlineTextStyle,
      ),
      color: Colors.blue,
    );
  }
}
