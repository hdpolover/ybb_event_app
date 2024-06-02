import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/pages/footer.dart';
import 'package:ybb_event_app/pages/landing_pages/page_template.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/header_page.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';

class Sponsorships extends StatefulWidget {
  const Sponsorships({super.key});

  @override
  State<Sponsorships> createState() => _SponsorshipsState();
}

class _SponsorshipsState extends State<Sponsorships> {
  ProgramInfoByUrlModel? programInfo;

  @override
  void initState() {
    super.initState();

    LandingPageService()
        .getProgramInfo("https://worldyouthfest.com")
        .then((value) {
      setState(() {
        programInfo = value;
      });
    });
  }

  buildCanvaSection() {
    return Padding(
      padding: commonPadding(context),
      child: Center(
        child: SizedBox(
          width: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
              ? MediaQuery.of(context).size.width * 0.8
              : MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child: HtmlWidget("""
       <iframe loading="lazy" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0; border: none; padding: 0;margin: 0;"
    src="https:&#x2F;&#x2F;www.canva.com&#x2F;design&#x2F;DAGBd4V_Yx4&#x2F;B2kE1GJY9YrY8JU3HqnyMQ&#x2F;view?embed" allowfullscreen="allowfullscreen" allow="fullscreen">
  </iframe>

      """,
              onLoadingBuilder: (context, el, buf) =>
                  LoadingAnimationWidget.bouncingBall(
                      color: primary, size: 50)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return programInfo == null
        ? const LoadingPage()
        : PageTemplate(
            pageName: "Sponsorships",
            contents: [
              const HeaderPage(
                  title: "Partnerships & Sponsorhips",
                  desc: "Collaborate with us to make a difference!"),
              buildCanvaSection(),
              Footer(programInfo: programInfo!),
            ],
            programInfo: programInfo!,
          );
  }
}
