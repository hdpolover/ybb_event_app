import 'package:flutter/material.dart';
import 'package:ybb_event_app/main.dart';
import 'package:ybb_event_app/models/faq_model.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/faq/components/faq_list.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/header_page.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/services/faq_service.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';

class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  ProgramInfoByUrlModel? programInfo;
  List<FaqModel>? faqs;

  @override
  void initState() {
    super.initState();

    print(mainUrl);
    LandingPageService().getProgramInfo(mainUrl).then((value) {
      setState(() {
        programInfo = value;
      });

      FaqService().getProgramFaqs(programInfo!.id!).then((value) {
        setState(() {
          faqs = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return programInfo == null || faqs == null
        ? const LoadingPage()
        : PageTemplate(
            programInfo: programInfo!,
            pageName: "FAQs",
            contents: [
              const HeaderPage(
                  title: "Frequently Asked Questions (FAQs)",
                  desc: "Find answers to your questions here!"),
              FaqList(
                faqs: faqs!,
              ),
              Footer(programInfo: programInfo!),
            ],
          );
  }
}
