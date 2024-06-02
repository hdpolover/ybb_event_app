import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/pages/dashboard/dashboard.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/announcements/user_announcements.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/documents/documents.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/help_desk/help_desk_list.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist_form.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/components/payment_history_detail.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/payment_detail_page.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/payment_webview.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/proceed_payment.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/transactions.dart';
import 'package:ybb_event_app/pages/landing_pages/about_us/about_us.dart';
import 'package:ybb_event_app/pages/landing_pages/about_us/test_page.dart';
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
String documentsRouteName = "documents";
String documentsPathName = "/documents";
String userAnnouncementsRouteName = "user-announcements";
String userAnnouncementsPathName = "/user-announcements";
String paymentDetailRouteName = "payment-detail";
String paymentDetailPathName = "/payment-detail";
String proceedPaymentRouteName = "proceed-payment";
String proceedPaymentPathName = "/proceed-payment";
String paymentHistoryDetailRouteName = "payment-history-detail";
String paymentHistoryDetailPathName = "/payment-history-detail";
String paymentWebviewRouteName = "payment-webview";
String paymentWebviewPathName = "/payment-webview";
String helpDeskListRouteNmae = "help-desk-list";
String helpDeskListPathName = "/help-desk-list";

class AppRouterConfig {
  final GoRouter routeConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: homePathName,
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: "test-page",
        path: "/test-page",
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TestPage(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: authRouteName,
        path: authPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Auth(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: signUpRouteName,
        path: signUpPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignUp(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: ambassadorSigninRouteName,
        path: ambassadorSigninPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AmbassadorSignin(),
        ),
      ),
      GoRoute(
        name: helpDeskListRouteNmae,
        path: helpDeskListPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HelpDeskList(),
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
        name: paymentHistoryDetailRouteName,
        path: paymentHistoryDetailPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: PaymentHistoryDetail(
            payment: state.extra as PaymentModel,
          ),
        ),
      ),
      GoRoute(
        name: paymentDetailRouteName,
        path: paymentDetailPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: PaymentDetailPage(
            payment: state.extra as ProgramPaymentModel?,
          ),
        ),
      ),
      GoRoute(
        name: proceedPaymentRouteName,
        path: proceedPaymentPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: ProceedPayment(
            payment: state.extra as ProgramPaymentModel,
          ),
        ),
      ),
      GoRoute(
        name: paymentWebviewRouteName,
        path: paymentWebviewPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: PaymentWebview(
            url: state.extra as String,
          ),
        ),
      ),
      GoRoute(
        name: userAnnouncementsRouteName,
        path: userAnnouncementsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: UserAnnouncements(),
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
        name: documentsRouteName,
        path: documentsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Documents(),
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
        parentNavigatorKey: _rootNavigatorKey,
        name: homeRouteName,
        path: homePathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Home(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: aboutUsRouteName,
        path: aboutUsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AboutUs(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: faqsRouteName,
        path: faqsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Faqs(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: announcementsRouteName,
        path: announcementsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Announcements(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: sponsorshipsRouteName,
        path: sponsorshipsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Sponsorships(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: helpCenterRouteName,
        path: helpCenterPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HelpCenter(),
        ),
      ),
    ],
  );
}
