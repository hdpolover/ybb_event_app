import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_announcement_model.dart';
import 'package:ybb_event_app/providers/announcement_provider.dart';

class AnnouncementDetail extends StatefulWidget {
  final ProgramAnnouncementModel announcement;
  const AnnouncementDetail({super.key, required this.announcement});

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: blockPadding(context),
        child: Column(
          children: [
            Image.network(
              widget.announcement.imgUrl,
              width: MediaQuery.sizeOf(context).width * 0.5,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.announcement.title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Published on ${DateFormat('dd MMMM yyyy').format(widget.announcement.createdAt!)}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  HtmlWidget(
                    widget.announcement.description!,
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              minWidth: 200,
              height: 60,
              color: primary,
              // give radius to the button
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                Provider.of<AnnouncementProvider>(context, listen: false)
                    .removeCurrentAnnouncement();
              },
              child: const AutoSizeText('Back', style: buttonTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
