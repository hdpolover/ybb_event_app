import 'package:flutter/material.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Documents"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonMethods().buildNothingToShow(
            "No Documents Available",
            "There are no documents available at the moment. Please check back later.",
          ),
        ],
      ),
    );
  }
}
