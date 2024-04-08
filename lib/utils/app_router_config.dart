import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ybb_event_app/pages/dashboard/dashboard.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist_form.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions.dart';
import 'package:ybb_event_app/pages/landing_pages/about_us/about_us.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/announcements.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/ambassador_signin.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/auth.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/sign_up.dart';
import 'package:ybb_event_app/pages/landing_pages/faq/faqs.dart';
import 'package:ybb_event_app/pages/landing_pages/help_center/help_center.dart';
import 'package:ybb_event_app/pages/landing_pages/home/home.dart';
import 'package:ybb_event_app/pages/landing_pages/sponsorship/sponsorships.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

String homeRouteName = "home";
String homePathName = "/";
String aboutUsRouteName = "about-us";
String aboutUsPathName = "/about-us";
String faqsRouteName = "faqs";
String faqsPathName = "/faqs";
String announcementsRouteName = "announcements";
String announcementsPathName = "/announcements";
String sponsorshipsRouteName = "sponsorships";
String sponsorshipsPathName = "/sponsorships";
String helpCenterRouteName = "help-center";
String helpCenterPathName = "/help-center";
String authRouteName = "auth";
String authPathName = "/auth";
String registFormRouteName = "regist-form";
String registFormPathName = "/registration-form";
String signUpRouteName = "sign-up";
String signUpPathName = "/sign-up";
String dashboardRouteName = "dashboard";
String dashboardPathName = "/dashboard";
String ambassadorSigninRouteName = "ambassador-signin";
String ambassadorSigninPathName = "/ambassador-signin";
String transactionsRouteName = "transactions";
String transactionsPathName = "/transactions";

class AppRouterConfig {
  final GoRouter routeConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: homePathName,
    routes: [
      GoRoute(
        name: authRouteName,
        path: authPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Auth(),
        ),
      ),
      GoRoute(
        name: signUpRouteName,
        path: signUpPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignUp(),
        ),
      ),
      GoRoute(
        name: ambassadorSigninRouteName,
        path: ambassadorSigninPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AmbassadorSignin(),
        ),
      ),
      GoRoute(
        name: dashboardRouteName,
        path: dashboardPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: Dashboard(
            role: state.extra as String?,
          ),
        ),
      ),
      GoRoute(
        name: transactionsRouteName,
        path: transactionsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Transactions(),
        ),
      ),
      GoRoute(
        name: registFormRouteName,
        path: registFormPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RegistForm(),
        ),
      ),
      GoRoute(
        name: homeRouteName,
        path: homePathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Home(),
        ),
      ),
      GoRoute(
        name: aboutUsRouteName,
        path: aboutUsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AboutUs(),
        ),
      ),
      GoRoute(
        name: faqsRouteName,
        path: faqsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Faqs(),
        ),
      ),
      GoRoute(
        name: announcementsRouteName,
        path: announcementsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Announcements(),
        ),
      ),
      GoRoute(
        name: sponsorshipsRouteName,
        path: sponsorshipsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Sponsorships(),
        ),
      ),
      GoRoute(
        name: helpCenterRouteName,
        path: helpCenterPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HelpCenter(),
        ),
      ),
    ],
  );
}
