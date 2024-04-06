import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';

class Dashboard extends StatefulWidget {
  final String? role;
  const Dashboard({super.key, this.role});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  List<ParticipantModel>? participants;

  late final TabController _controller;
  String? name;

  getData() {
    // get data from database
    if (widget.role == "ambassador") {
      setState(() {
        name = Provider.of<AuthProvider>(context, listen: false)
            .authUser!
            .fullName;
      });
    } else if (widget.role == "participant") {
      setState(() {
        name = Provider.of<AuthProvider>(context, listen: false)
            .authUser!
            .fullName;
      });
    } else {
      // get other data
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(vsync: this, length: 3);

    getData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  buildProfileSection() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Profile"),
              const SizedBox(height: 20),
              const Text("Name:"),
              const SizedBox(height: 10),
              const Text("Email:"),
              const SizedBox(height: 10),
              const Text("Phone:"),
              const SizedBox(height: 10),
              const Text("Role:"),
              const SizedBox(height: 10),
              const Text("Status:"),
              const SizedBox(height: 10),
              const Text("Action:"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);

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
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey[100],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // show image
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(programProvider.programInfo!.logoUrl!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              "Welcome, $name!",
              style: headlineTextStyle,
            ),
          ],
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Row(
      //     children: [
      //       buildProfileSection(),
      //       // Main content will be a tab view with different content based on the role
      //       Container(
      //         width: MediaQuery.of(context).size.width * 0.8,
      //         height: MediaQuery.of(context).size.height,
      //         color: Colors.white,
      //         child: TabContainer(
      //           controller: _controller,
      //           tabEdge: TabEdge.top,
      //           tabsStart: 0.1,
      //           tabsEnd: 0.9,
      //           tabMaxLength: 200,
      //           borderRadius: BorderRadius.circular(10),
      //           tabBorderRadius: BorderRadius.circular(10),
      //           childPadding: const EdgeInsets.all(20.0),
      //           selectedTextStyle: const TextStyle(
      //             color: primary,
      //             fontSize: 15.0,
      //           ),
      //           unselectedTextStyle: const TextStyle(
      //             color: Colors.black,
      //             fontSize: 13.0,
      //           ),
      //           tabs: [
      //             Text('Tab 1'),
      //             Text('Tab 2'),
      //             Text('Tab 3'),
      //           ],
      //           children: [
      //             Container(
      //               child: Text('Child 1'),
      //             ),
      //             Container(
      //               child: Text('Child 2'),
      //             ),
      //             Container(
      //               child: Text('Child 3'),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
