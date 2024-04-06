import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/components.dart';

class NotSupportMobile extends StatefulWidget {
  const NotSupportMobile({super.key});

  @override
  State<NotSupportMobile> createState() => _NotSupportMobileState();
}

class _NotSupportMobileState extends State<NotSupportMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: primary,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingAnimationWidget.fourRotatingDots(
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 30),
              Text(
                "This website app is currently not supported on mobile devices. Please use a desktop or laptop to access. Thank you!",
                textAlign: TextAlign.center,
                softWrap: true,
                style: headlineSecondaryTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
