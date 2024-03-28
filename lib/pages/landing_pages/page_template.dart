import 'package:flutter/material.dart';
import 'package:ybb_event_app/pages/website_menu_bar.dart';

import '../../components/components.dart';

class PageTemplate extends StatefulWidget {
  final String? pageName;
  final List<Widget>? contents;
  const PageTemplate({super.key, this.pageName, this.contents});

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 66),
        child: WebsiteMenuBar(),
      ),
      body: ListView.builder(
        itemCount: widget.contents!.length,
        itemBuilder: (context, index) {
          return widget.contents![index];
        },
      ),
    );
  }
}
