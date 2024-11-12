import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class PaperOtherPageModel {
  final String? imgUrl;
  final String? content;
  final String appBarTitle;

  PaperOtherPageModel({
    this.imgUrl,
    this.content,
    required this.appBarTitle,
  });
}

class PaperOtherPageTemplate extends StatelessWidget {
  final PaperOtherPageModel item;

  const PaperOtherPageTemplate({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, item.appBarTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (item.imgUrl != null)
                CachedNetworkImage(
                  imageUrl: item.imgUrl!,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16.0),
              if (item.content != null)
                HtmlWidget(
                  item.content!,
                )
              else
                const Text(
                  "The content is currently unavailable. Please check back later.",
                  style: TextStyle(fontSize: 16.0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
