import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/pages/not_support_mobile.dart';
import 'package:ybb_event_app/pages/website_menu_bar.dart';
import 'package:ybb_event_app/utils/utils.dart';

import '../../components/components.dart';

class PageTemplate extends StatefulWidget {
  final String? pageName;
  final List<Widget>? contents;
  final ProgramInfoByUrlModel? programInfo;
  const PageTemplate(
      {super.key, this.pageName, this.contents, required this.programInfo});

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET) ||
            ResponsiveBreakpoints.of(context).isTablet
        ? const NotSupportMobile()
        : Scaffold(
            backgroundColor: background,
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 66),
              child: WebsiteMenuBar(programInfo: widget.programInfo!),
            ),
            floatingActionButton: SingleChildScrollView(
              child: Column(
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      openUrl("mailto:${widget.programInfo!.email}");
                    },
                    label: const Text("Send Email"),
                    icon: const FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                    ),
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    onPressed: () {
                      openUrl("https://wa.me/${widget.programInfo!.contact!}");
                    },
                    label: const Text("Contact Us"),
                    icon: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: primary,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ],
              ),
            ),
            body: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.contents!.length,
              itemBuilder: (context, index) {
                return widget.contents![index];
              },
            ),
          );
  }
}
