import 'package:flutter/material.dart';
import 'package:ybb_event_app/components/components.dart';

class HeaderPage extends StatelessWidget {
  final String title;
  final String desc;
  const HeaderPage({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: imageBgDecorStyle,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: headlineTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(desc,
                textAlign: TextAlign.center,
                style: headlineSecondaryTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                )),
          ],
        ),
      ),
    );
  }
}
