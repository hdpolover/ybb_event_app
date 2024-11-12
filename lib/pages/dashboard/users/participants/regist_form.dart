import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist/achievement_section.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist/basic_information_section.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist/essay_section.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist/preview_section.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist/miscellaneous.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class RegistForm extends StatefulWidget {
  const RegistForm({super.key});

  @override
  State<RegistForm> createState() => _RegistFormState();
}

class _RegistFormState extends State<RegistForm> {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);

    ProgramInfoByUrlModel programInfo = programProvider.programInfo!;

    String tabText = "";

    if (programInfo.programTypeId == "3") {
      tabText = "Program";
    } else {
      tabText = "Essays";
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }

        DialogManager.showConfirmationDialog(
            context, "Your unsaved data will be lost. Are you sure to exit?",
            () {
          Navigator.of(context).pop();
        });
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Registration Form"),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            elevation: 5,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: primary,
              controller: _tabController,
              labelColor: primary,
              labelStyle: bodyTextStyle.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                const Tab(
                  text: "Basics",
                ),
                const Tab(
                  text: "Achievements",
                ),
                Tab(
                  text: tabText,
                ),
                const Tab(
                  text: "Miscs",
                ),
                const Tab(
                  text: "Preview",
                ),
              ],
            ),
          ),
          // tab view and content
          body: const TabBarView(
            children: [
              BasicInformationSection(),
              AchievementSection(),
              EssaySection(),
              MiscellaneousSection(),
              PreviewSection(),
            ],
          ),
        ),
      ),
    );
  }
}
