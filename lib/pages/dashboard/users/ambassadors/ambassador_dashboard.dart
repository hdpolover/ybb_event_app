import 'dart:html';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/ambassador_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/ambassadors/participant_tile.dart';
import 'package:ybb_event_app/providers/app_provider.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/participant_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';

class AmbassadorDashboard extends StatefulWidget {
  final AmbassadorModel ambassador;
  const AmbassadorDashboard({super.key, required this.ambassador});

  @override
  State<AmbassadorDashboard> createState() => _AmbassadorDashboardState();
}

class _AmbassadorDashboardState extends State<AmbassadorDashboard> {
  String? name;
  String link = "";
  List<ParticipantModel> participants = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    setState(() {
      name =
          Provider.of<AuthProvider>(context, listen: false).authUser!.fullName;

      link =
          "https://redirect.ybbfoundation.com/register?ref_code=${widget.ambassador.refCode!.toUpperCase()}";
    });

    await ParticipantService()
        .getReferredParticipants(widget.ambassador.refCode!)
        .then((value) {
      setState(() {
        participants = value;
      });
    }).onError((error, stackTrace) {
      setState(() {
        participants = [];
      });
    });
  }

  buildParticipants() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "List of Participants",
                      style: headlineTextStyle.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Total: ${participants.length}",
                    style: headlineTextStyle.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              participants.isEmpty
                  ? Text(
                      "You have not invited any participants yet. Start inviting participants to join the program!",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: participants.length,
                        itemBuilder: (context, index) {
                          return ParticipantTile(
                              participantModel: participants[index]);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);
    var appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(homeRouteName);
              },
              child: Image.network(programProvider.programInfo!.logoUrl!),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  appProvider.toggleFullScreen();

                  if (appProvider.isFullScreen) {
                    document.documentElement!.requestFullscreen();
                  } else {
                    document.exitFullscreen();
                  }
                },
                // icon for full screen view
                child: const Icon(Icons.fullscreen),
              ),
            ),
          ),
        ],
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey[100],
      ),
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.sizeOf(context).width * 0.4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      programProvider.programInfo!.logoUrl!,
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Welcome, $name!",
                      style: headlineTextStyle.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "You are an ambassador for the ${programProvider.programInfo!.name} program. You can now start inviting participants to join the program.",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                    Text(
                      link,
                      style: headlineSecondaryTextStyle.copyWith(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () {
                        // copy to clipboard
                        FlutterClipboard.copy(link).then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Copied the link to clipboard"),
                          ));
                        });
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text("Copy Link"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Note: we strongly suggest you shorten the link before sharing it to participants. You can use bit.ly or other link shortening services.",
                      style: bodyTextStyle.copyWith(
                          color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildParticipants(),
        ],
      ),
    );
  }
}
