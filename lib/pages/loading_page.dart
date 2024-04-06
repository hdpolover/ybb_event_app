import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ybb_event_app/components/colors.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 100,
              ),
            ],
          ),
        ));
  }
}
