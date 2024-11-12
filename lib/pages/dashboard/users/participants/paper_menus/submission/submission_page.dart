import 'package:flutter/material.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/abstract_tab.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/paper_tab.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage>
    with SingleTickerProviderStateMixin {
  // tab controller
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // initialize the tab controller
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // create a tab controller
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Submission"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: "Abstract",
              ),
              Tab(
                text: "Paper",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AbstractTab(),
            PaperTab(),
          ],
        ),
      ),
    );
  }
}
