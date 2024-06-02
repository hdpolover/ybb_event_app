import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/models/participant_status_model.dart';
import 'package:ybb_event_app/pages/dashboard/components/menu_card.dart';
import 'package:ybb_event_app/pages/dashboard/components/menu_card_model.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/guideline_widget.dart';
import 'package:ybb_event_app/providers/app_provider.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/participant_service.dart';
import 'package:ybb_event_app/services/participant_status_service.dart';
import 'package:ybb_event_app/services/progam_payment_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

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

  getData() async {
    // get data from database
    if (widget.role == "ambassador") {
      setState(() {
        name = Provider.of<AuthProvider>(context, listen: false)
            .authUser!
            .fullName;
      });
    } else if (widget.role == "participant") {
      setState(() {
        participants = Provider.of<ParticipantProvider>(context, listen: false)
            .participants;
      });
    }

    getPaymentData();
  }

  getPaymentData() {
    String id = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;

    // get payments
    ProgramPaymentService().getAll(id).then((value) {
      Provider.of<PaymentProvider>(context, listen: false)
          .setProgramPayments(value);
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(vsync: this, length: 3);

    getData();
    //checkFullScreen();
  }

  checkFullScreen() {
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    if (!appProvider.isFullScreen) {
      // add delay duration of 5 second
      Future.delayed(const Duration(seconds: 5), () {
        DialogManager.showFullScreenDialog(context, () {
          appProvider.toggleFullScreen();

          if (appProvider.isFullScreen) {
            document.documentElement!.requestFullscreen();
          } else {
            document.exitFullscreen();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  buildDetailItem(String data, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: primary,
          ),
          SizedBox(width: MediaQuery.of(context).size.height * 0.05),
          Text(
            data,
            style: bodyTextStyle.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  buildProfileSection(ParticipantModel participantModel, String email) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      "#${participantModel.accountId}",
                      style: bodyTextStyle.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.copy,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // make the image a circle
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FancyShimmerImage(
                      imageUrl: participantModel.pictureUrl ??
                          Provider.of<ProgramProvider>(context, listen: false)
                              .programInfo!
                              .logoUrl!,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  participantModel.fullName!.toUpperCase(),
                  style: bodyTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // email but hide the first 5 characters
                Text(
                  email.replaceRange(0, 3, "*****"),
                  style: bodyTextStyle.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                participantModel.nationality == null
                    ? const SizedBox.shrink()
                    : buildDetailItem(
                        participantModel.nationality!, Icons.flag),
                participantModel.institution == null
                    ? const SizedBox.shrink()
                    : buildDetailItem(
                        participantModel.institution!, Icons.school),
                participantModel.organizations == null
                    ? const SizedBox.shrink()
                    : buildDetailItem(
                        participantModel.organizations!, Icons.work),
                const SizedBox(height: 40),
                // CommonMethods().buildCustomButton(
                //     width: 300,
                //     color: Colors.red,
                //     text: "Sign out",
                //     onPressed: () {
                //       context.goNamed(homeRouteName);
                //     }),
                const Spacer(),
                // logout button
                Text(
                  "YBB Program App v1.0.0",
                  style: bodyTextStyle.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildProfileSectionForMobile(
      ParticipantModel participantModel, String email) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Text(
                  "#${participantModel.accountId}",
                  style: bodyTextStyle.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.copy,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // make the image a circle
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FancyShimmerImage(
                  imageUrl: participantModel.pictureUrl ??
                      Provider.of<ProgramProvider>(context, listen: false)
                          .programInfo!
                          .logoUrl!,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              participantModel.fullName!.toUpperCase(),
              style: bodyTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // email but hide the first 5 characters
            Text(
              email.replaceRange(0, 3, "*****"),
              style: bodyTextStyle.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            participantModel.nationality == null
                ? const SizedBox.shrink()
                : buildDetailItem(participantModel.nationality!, Icons.flag),
            participantModel.institution == null
                ? const SizedBox.shrink()
                : buildDetailItem(participantModel.institution!, Icons.school),
            participantModel.organizations == null
                ? const SizedBox.shrink()
                : buildDetailItem(participantModel.organizations!, Icons.work),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  buildContentSection(ProgramProvider programProvider,
      ParticipantStatusModel participantStatus) {
    String? formStatusText, paymentStatusText;

    if (participantStatus.formStatus == "0") {
      formStatusText = "Registration form not started yet";
    } else if (participantStatus.formStatus == "1") {
      formStatusText = "Registration form on progress";
    } else if (participantStatus.formStatus == "2") {
      formStatusText = "Registration form submitted";
    }

    if (participantStatus.paymentStatus == "0") {
      paymentStatusText =
          "No payment made yet. Make registration payment first.";
    } else if (participantStatus.paymentStatus == "1") {
      paymentStatusText =
          "Registratioon payment successfull. Do the next step.";
    } else {
      paymentStatusText = "";
    }
    List<MenuCard> menuCards = [
      MenuCard(
        menuCard: MenuCardModel(
          title: "Registration Form",
          icon: FontAwesomeIcons.userPen,
          desc: "Fill out and submit your registration form",
          isActive: true,
          route: registFormRouteName,
          statusText: formStatusText,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Transactions",
          icon: FontAwesomeIcons.moneyBill,
          desc: "Manage your program payments",
          isActive: true,
          route: transactionsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Documents",
          icon: FontAwesomeIcons.fileLines,
          desc: "View and download important documents",
          isActive: true,
          route: documentsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Announcements",
          icon: FontAwesomeIcons.bullhorn,
          desc: "Get the latest program announcements",
          isActive: true,
          route: userAnnouncementsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Help Desk",
          icon: FontAwesomeIcons.ticketSimple,
          desc: "Ask questions and get help from the help desk",
          isActive: false,
          route: helpDeskListRouteNmae,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Certificates",
          icon: FontAwesomeIcons.certificate,
          desc: "Preview and download your certificates",
          isActive: false,
          route: "",
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Settings",
          icon: Icons.settings,
          desc: "View your settings",
          isActive: false,
          route: "",
        ),
      ),
    ];

    // build a container with a grid view for menu cards
    return Container(
      padding: const EdgeInsets.only(right: 20),
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: ResponsiveRowColumn(
          layout: ResponsiveRowColumnType.COLUMN,
          children: [
            ResponsiveRowColumnItem(
                child:
                    GuidelineWidget(program: programProvider.currentProgram!)),
            ResponsiveRowColumnItem(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: menuCards.length,
                  itemBuilder: (context, index) {
                    return menuCards[index];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildContentSectionForMobile(ProgramProvider programProvider,
      ParticipantStatusModel participantStatus) {
    String? formStatusText, paymentStatusText;

    if (participantStatus.formStatus == "0") {
      formStatusText = "Registration form not started yet";
    } else if (participantStatus.formStatus == "1") {
      formStatusText = "Registration form on progress";
    } else if (participantStatus.formStatus == "2") {
      formStatusText = "Registration form submitted";
    }

    if (participantStatus.paymentStatus == "0") {
      paymentStatusText =
          "No payment made yet. Make registration payment first.";
    } else if (participantStatus.paymentStatus == "1") {
      paymentStatusText =
          "Registratioon payment successfull. Do the next step.";
    } else {
      paymentStatusText = "";
    }
    List<MenuCard> menuCards = [
      MenuCard(
        menuCard: MenuCardModel(
          title: "Registration Form",
          icon: FontAwesomeIcons.userPen,
          desc: "Fill out and submit your registration form",
          isActive: true,
          route: registFormRouteName,
          statusText: formStatusText,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Transactions",
          icon: FontAwesomeIcons.moneyBill,
          desc: "Manage your program payments",
          isActive: true,
          route: transactionsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Documents",
          icon: FontAwesomeIcons.fileLines,
          desc: "View and download important documents",
          isActive: true,
          route: documentsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Announcements",
          icon: FontAwesomeIcons.bullhorn,
          desc: "Get the latest program announcements",
          isActive: true,
          route: userAnnouncementsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Help Desk",
          icon: FontAwesomeIcons.ticketSimple,
          desc: "Ask questions and get help from the help desk",
          isActive: false,
          route: helpDeskListRouteNmae,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Certificates",
          icon: FontAwesomeIcons.certificate,
          desc: "Preview and download your certificates",
          isActive: false,
          route: "",
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          title: "Settings",
          icon: Icons.settings,
          desc: "View your settings",
          isActive: false,
          route: "",
        ),
      ),
    ];

    // build a container with a grid view for menu cards
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuCards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: menuCards[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);
    var appProvider = Provider.of<AppProvider>(context);
    var participantProvider = Provider.of<ParticipantProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // make the app bar standout with elevation
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
                  // context.pushNamed(profileRouteName);
                  // if (kIsWeb) {
                  //   document.documentElement!.requestFullscreen();
                  // } else {
                  //   //mobile or desktop functionalities
                  // }
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
      body: widget.role == "ambassador"
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    programProvider.programInfo!.logoUrl!,
                    width: MediaQuery.of(context).size.width * 0.3,
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
                    "You are now an ambassador for the ${programProvider.programInfo!.name} program. You can now start inviting participants to join the program. \n More features will be available soon!",
                    style: bodyTextStyle.copyWith(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
              ? buildForMobile(
                  participantProvider, programProvider, authProvider)
              : buildForDesktop(
                  participantProvider, programProvider, authProvider),
    );
  }

  buildForDesktop(ParticipantProvider participantProvider,
      ProgramProvider programProvider, AuthProvider authProvider) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildProfileSection(
              participantProvider.participant!, authProvider.authUser!.email!),
          const Spacer(),
          buildContentSection(
              programProvider, participantProvider.participantStatus!),
        ],
      ),
    );
  }

  buildForMobile(ParticipantProvider participantProvider,
      ProgramProvider programProvider, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildProfileSectionForMobile(participantProvider.participant!,
                authProvider.authUser!.email!),
            GuidelineWidget(program: programProvider.currentProgram!),
            buildContentSectionForMobile(
                programProvider, participantProvider.participantStatus!),
            const SizedBox(height: 20),
            // logout button
            Text(
              "YBB Program App v1.0.0",
              style: bodyTextStyle.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
