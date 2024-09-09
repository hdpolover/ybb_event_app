import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/pages/website_menu_bar.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
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
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 66),
        child: WebsiteMenuBar(programInfo: widget.programInfo!),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: primary,
              ),
              child: Center(
                // get logo from url
                child: Image.network(
                  widget.programInfo!.logoUrl!,
                  width: 100,
                ),
              ),
            ),
            ListTile(
              // add icon
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);

                context.pushNamed(homeRouteName);
              },
            ),
            ListTile(
              // add icon
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () {
                Navigator.pop(context);

                context.pushNamed(aboutUsRouteName);
              },
            ),
            ListTile(
              // add icon
              leading: const Icon(Icons.event),
              title: const Text("Partnerships & Sponsorships"),
              onTap: () {
                Navigator.pop(context);

                context.pushNamed(sponsorshipsRouteName);
              },
            ),
            ListTile(
              // add icon
              leading: const Icon(Icons.event),
              title: const Text("Announcements"),
              onTap: () {
                Navigator.pop(context);

                context.pushNamed(announcementsRouteName);
              },
            ),
            ListTile(
              // add icon
              leading: const FaIcon(FontAwesomeIcons.envelope),
              title: const Text("FAQs"),
              onTap: () {
                Navigator.pop(context);

                context.pushNamed(faqsRouteName);
              },
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.05,
            // ),
          ],
        ),
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
