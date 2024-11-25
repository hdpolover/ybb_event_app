import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/paper_program_detail_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/models/participant_status_model.dart';
import 'package:ybb_event_app/pages/dashboard/components/menu_card.dart';
import 'package:ybb_event_app/pages/dashboard/components/menu_card_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/other_pages/paper_other_page_template.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/submission_page.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/guideline_widget.dart';
import 'package:ybb_event_app/providers/app_provider.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/paper_program_detail_service.dart';
import 'package:ybb_event_app/services/progam_payment_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

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

  List<MenuCard> menuCards = [];

  setMenu() async {
    String programTypeId = Provider.of<ProgramProvider>(context, listen: false)
        .programInfo!
        .programTypeId!;

    List<MenuCard> baseMenu = [
      MenuCard(
        menuCard: MenuCardModel(
          orderNumber: 1,
          title: "Registration Form",
          icon: FontAwesomeIcons.userPen,
          desc: "Fill out and submit your registration form",
          isActive: true,
          route: registFormRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          orderNumber: 3,
          title: "Transactions",
          icon: FontAwesomeIcons.moneyBill,
          desc: "Manage your program payments",
          isActive: true,
          route: transactionsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          orderNumber: 5,
          title: "Documents",
          icon: FontAwesomeIcons.fileLines,
          desc: "View and download important documents",
          isActive: true,
          route: documentsRouteName,
        ),
      ),
      MenuCard(
        menuCard: MenuCardModel(
          orderNumber: 6,
          title: "Announcements",
          icon: FontAwesomeIcons.bullhorn,
          desc: "Get the latest program announcements",
          isActive: true,
          route: userAnnouncementsRouteName,
        ),
      ),
      // MenuCard(
      //   menuCard: MenuCardModel(
      //     title: "Help Desk",
      //     icon: FontAwesomeIcons.ticketSimple,
      //     desc: "Ask questions and get help from the help desk",
      //     isActive: false,
      //     route: helpDeskListRouteNmae,
      //   ),
      // ),
      // MenuCard(
      //   menuCard: MenuCardModel(
      //     title: "Certificates",
      //     icon: FontAwesomeIcons.certificate,
      //     desc: "Preview and download your certificates",
      //     isActive: false,
      //     route: "",
      //   ),
      // ),
      // MenuCard(
      //   menuCard: MenuCardModel(
      //     title: "Settings",
      //     icon: Icons.settings,
      //     desc: "View your settings",
      //     isActive: false,
      //     route: "",
      //   ),
      // ),
    ];

    menuCards.addAll(baseMenu);

    if (programTypeId == "3") {
      String programId = Provider.of<ProgramProvider>(context, listen: false)
          .currentProgram!
          .id!;

      await PaperProgramDetailService().getById(programId).then((value) {
        // get data from database
        PaperProgramDetailModel paperProgramDetail = value;

        List<MenuCard> paperMenu = [
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 2,
              title: "Submission",
              // paper plane icon
              icon: FontAwesomeIcons.paperPlane,
              desc: "Manage your abstract and paper submission",
              isActive: true,
              route: submissionPageRouteName,
            ),
          ),
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 4,
              title: "Acceptance Letter",
              icon: FontAwesomeIcons.fileLines,
              desc: "View and download your acceptance letter",
              isActive: false,
              route: "",
            ),
          ),
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 7,
              title: "Topics",
              // open book icon
              icon: FontAwesomeIcons.bookOpen,
              desc: "Details of the topics to be discussed",
              isActive: true,
              route: paperOtherPageTemplateRouteName,
              extraItem: PaperOtherPageModel(
                appBarTitle: "Topics",
                content: paperProgramDetail.topics,
                imgUrl: paperProgramDetail.topicImgUrl,
              ),
            ),
          ),
          // paper format
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 8,
              title: "Paper Format",
              icon: FontAwesomeIcons.fileZipper,
              desc: "View the format for paper writing",
              isActive: true,
              route: paperOtherPageTemplateRouteName,
              extraItem: PaperOtherPageModel(
                appBarTitle: "Paper Format",
                content: paperProgramDetail.paperFormat,
              ),
            ),
          ),
          // committee
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 9,
              title: "Committee",
              icon: FontAwesomeIcons.users,
              desc: "View the committee members",
              isActive: true,
              route: paperOtherPageTemplateRouteName,
              extraItem: PaperOtherPageModel(
                appBarTitle: "Committee",
                content: paperProgramDetail.committees,
                imgUrl: paperProgramDetail.committeeImgUrl,
              ),
            ),
          ),
          // published books
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 10,
              title: "Published Books",
              icon: FontAwesomeIcons.book,
              desc: "View the published books",
              isActive: true,
              route: paperOtherPageTemplateRouteName,
              extraItem: PaperOtherPageModel(
                appBarTitle: "Published Books",
                content: paperProgramDetail.books,
              ),
            ),
          ),
          // timeline
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 11,
              title: "Timeline",
              icon: FontAwesomeIcons.calendar,
              desc: "View the timeline of the event",
              isActive: true,
              route: paperOtherPageTemplateRouteName,
              extraItem: PaperOtherPageModel(
                appBarTitle: "Timeline",
                content: paperProgramDetail.timeline,
              ),
            ),
          ),
          // keynote speakers
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 12,
              title: "Keynote Speakers",
              icon: FontAwesomeIcons.microphone,
              desc: "View the keynote speakers",
              isActive: false,
              route: "",
            ),
          ),
          // contact us
          MenuCard(
            menuCard: MenuCardModel(
              orderNumber: 13,
              title: "Contact Us",
              icon: FontAwesomeIcons.phone,
              desc: "Contact the event organizers",
              isActive: true,
              route: paperOtherPageTemplateRouteName,
              extraItem: PaperOtherPageModel(
                appBarTitle: "Contact Us",
                content: paperProgramDetail.contactUs,
              ),
            ),
          ),
        ];

        menuCards.addAll(paperMenu);
      });
    }

    menuCards.sort(
        (a, b) => a.menuCard.orderNumber.compareTo(b.menuCard.orderNumber));

    setState(() {});
  }

  getData() async {
    // get data from database

    setState(() {
      participants =
          Provider.of<ParticipantProvider>(context, listen: false).participants;
    });

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

    setMenu();

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
          Expanded(
            child: Text(
              data,
              softWrap: true,
              style: bodyTextStyle.copyWith(
                color: Colors.grey,
              ),
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
                  height: ScreenSizeHelper.responsiveValue(context,
                      mobile: MediaQuery.of(context).size.width * 0.5,
                      desktop: MediaQuery.of(context).size.width * 0.1),
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
              height: MediaQuery.of(context).size.width * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
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
    String? formStatusText, paymentStatusText, submissionStatusText;
    Color formStatusColor = Colors.red;
    Color transactionStatusColor = Colors.red;
    Color submissionStatusColor = Colors.red;
    bool isSubmissionActive = false;

    if (participantStatus.formStatus == "0") {
      formStatusText = "Registration form not started yet";
      formStatusColor = Colors.red;
    } else if (participantStatus.formStatus == "1") {
      formStatusText = "Registration form on progress";
      formStatusColor = Colors.orange;
    } else if (participantStatus.formStatus == "2") {
      formStatusText = "Registration form submitted";
      formStatusColor = Colors.green;
    }

    // if (participantStatus.paymentStatus == "0") {
    //   paymentStatusText =
    //       "No payment made yet. Make registration payment first.";
    //   transactionStatusColor = Colors.red;
    // } else if (participantStatus.paymentStatus == "1") {
    //   paymentStatusText = "Registration payment successful. Do the next step.";
    //   transactionStatusColor = Colors.green;
    // } else {
    //   paymentStatusText = "";
    // }

    if (participantStatus.formStatus == "0" ||
        participantStatus.formStatus == "1") {
      submissionStatusText = "Fill out and submit your registration form first";
      submissionStatusColor = Colors.red;
    } else if (participantStatus.formStatus == "2") {
      submissionStatusText = "";
      isSubmissionActive = true;
    }

    for (var menuCard in menuCards) {
      if (menuCard.menuCard.title.toLowerCase() == "registration form") {
        setState(() {
          menuCard.menuCard.statusText = formStatusText;
          menuCard.menuCard.statusColor = formStatusColor;
        });
      }

      // if (menuCard.menuCard.title.toLowerCase() == "transactions") {
      //   setState(() {
      //     menuCard.menuCard.statusText = paymentStatusText;
      //     menuCard.menuCard.statusColor = transactionStatusColor;
      //   });
      // }

      if (menuCard.menuCard.title.toLowerCase() == "submission") {
        setState(() {
          menuCard.menuCard.statusText = submissionStatusText;
          menuCard.menuCard.isActive = isSubmissionActive;
          menuCard.menuCard.statusColor = submissionStatusColor;
        });
      }
    }

    // build a container with a grid view for menu cards
    return ScreenSizeHelper.responsiveValue(context,
        desktop: Container(
          padding: const EdgeInsets.only(right: 20),
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GuidelineWidget(program: programProvider.currentProgram!),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: menuCards.length,
                    itemBuilder: (context, index) {
                      return menuCards[index];
                    },
                  ),
                ),
                SizedBox(
                    height: menuCards.length < 6
                        ? MediaQuery.sizeOf(context).height * 0.5
                        : 20),
              ],
            ),
          ),
        ),
        mobile: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemCount: menuCards.length,
          itemBuilder: (context, index) {
            return menuCards[index];
          },
        ));
  }

  // buildContentSectionForMobile(ProgramProvider programProvider,
  //     ParticipantStatusModel participantStatus) {
  //   String? formStatusText, paymentStatusText;

  //   if (participantStatus.formStatus == "0") {
  //     formStatusText = "Registration form not started yet";
  //   } else if (participantStatus.formStatus == "1") {
  //     formStatusText = "Registration form on progress";
  //   } else if (participantStatus.formStatus == "2") {
  //     formStatusText = "Registration form submitted";
  //   }

  //   if (participantStatus.paymentStatus == "0") {
  //     paymentStatusText =
  //         "No payment made yet. Make registration payment first.";
  //   } else if (participantStatus.paymentStatus == "1") {
  //     paymentStatusText = "Registration payment successfull. Do the next step.";
  //   } else {
  //     paymentStatusText = "";
  //   }
  //   List<MenuCard> menuCards = [
  //     MenuCard(
  //       menuCard: MenuCardModel(
  //         title: "Registration Form",
  //         icon: FontAwesomeIcons.userPen,
  //         desc: "Fill out and submit your registration form",
  //         isActive: true,
  //         route: registFormRouteName,
  //       ),
  //     ),
  //     MenuCard(
  //       menuCard: MenuCardModel(
  //         title: "Transactions",
  //         icon: FontAwesomeIcons.moneyBill,
  //         desc: "Manage your program payments",
  //         isActive: true,
  //         route: transactionsRouteName,
  //       ),
  //     ),
  //     MenuCard(
  //       menuCard: MenuCardModel(
  //         title: "Documents",
  //         icon: FontAwesomeIcons.fileLines,
  //         desc: "View and download important documents",
  //         isActive: true,
  //         route: documentsRouteName,
  //       ),
  //     ),
  //     MenuCard(
  //       menuCard: MenuCardModel(
  //         title: "Announcements",
  //         icon: FontAwesomeIcons.bullhorn,
  //         desc: "Get the latest program announcements",
  //         isActive: true,
  //         route: userAnnouncementsRouteName,
  //       ),
  //     ),
  //     MenuCard(
  //       menuCard: MenuCardModel(
  //         title: "Help Desk",
  //         icon: FontAwesomeIcons.ticketSimple,
  //         desc: "Ask questions and get help from the help desk",
  //         isActive: false,
  //         route: helpDeskListRouteNmae,
  //       ),
  //     ),
  //     MenuCard(
  //       menuCard: MenuCardModel(
  //         title: "Certificates",
  //         icon: FontAwesomeIcons.certificate,
  //         desc: "Preview and download your certificates",
  //         isActive: false,
  //         route: "",
  //       ),
  //     ),
  //     MenuCard(
  //       menuCard: MenuCardModel(
  //         title: "Settings",
  //         icon: Icons.settings,
  //         desc: "View your settings",
  //         isActive: false,
  //         route: "",
  //       ),
  //     ),
  //   ];

  //   // build a container with a grid view for menu cards
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     padding: const EdgeInsets.only(top: 20, bottom: 20),
  //     itemCount: menuCards.length,
  //     itemBuilder: (context, index) {
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 10),
  //         child: menuCards[index],
  //       );
  //     },
  //   );
  // }

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
      body: ScreenSizeHelper.responsiveValue(context,
          desktop: buildForDesktop(
              participantProvider, programProvider, authProvider),
          mobile: buildForMobile(
              participantProvider, programProvider, authProvider)),
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
            buildContentSection(
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
