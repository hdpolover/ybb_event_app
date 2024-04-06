import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/faq_model.dart';

class FaqCategoryList extends StatefulWidget {
  final String? category;
  final List<FaqModel> faqs;
  const FaqCategoryList({super.key, this.category, required this.faqs});

  @override
  State<FaqCategoryList> createState() => _FaqCategoryListState();
}

class _FaqCategoryListState extends State<FaqCategoryList> {
  // Controller
  late ExpandedTileController _controller;

  @override
  void initState() {
    // initialize controller
    _controller = ExpandedTileController(isExpanded: true);
    super.initState();
  }

  buildItem(int index, ExpandedTileController controller, FaqModel faq) {
    return ExpandedTile(
      theme: const ExpandedTileThemeData(
        headerColor: Colors.white,
        headerPadding: EdgeInsets.all(24.0),
        contentBackgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(24.0),
        contentRadius: 12.0,
      ),
      controller:
          index == 2 ? controller.copyWith(isExpanded: true) : controller,
      title: Text(
        faq.question!,
        style: headlineSecondaryTextStyle.copyWith(
            color: primary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Text(faq.answer!, style: bodyTextStyle),
      ),
    );
  }

  getCategory(String cat) {
    switch (cat) {
      case "event_details":
        return "Event Details";
      case "payments":
        return "Payments";
      case "registration":
        return "Registration";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            getCategory(widget.category!),
            textAlign: TextAlign.center,
            style: headlineTextStyle.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ExpandedTileList.builder(
            itemCount: widget.faqs.length,
            maxOpened: 1,
            reverse: false,
            itemBuilder: (context, index, controller) {
              return buildItem(
                index,
                controller,
                widget.faqs[index],
              );
            }),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
