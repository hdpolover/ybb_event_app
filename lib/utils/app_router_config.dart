import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ybb_event_app/models/agreement_letter_model.dart';
import 'package:ybb_event_app/models/ambassador_model.dart';
import 'package:ybb_event_app/models/paper_abstract_model.dart';
import 'package:ybb_event_app/models/paper_author_model.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/pages/dashboard/dashboard.dart';
import 'package:ybb_event_app/pages/dashboard/users/ambassadors/ambassador_dashboard.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/announcements/user_announcements.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/documents/agreement_letter_upload.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/documents/agreement_letter_view.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/documents/document_pdf_viewer.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/documents/documents.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/help_desk/help_desk_list.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/other_pages/paper_other_page_template.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/abstract/add_edit_abstract.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/author/add_edit_author.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/submission_page.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/regist_form.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/components/payment_history_detail.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/payment_detail_page.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/payment_webview.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/proceed_payment.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/transactions.dart';
import 'package:ybb_event_app/pages/landing_pages/about_us/about_us.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/announcements.dart';
import 'package:ybb_event_app/pages/landing_pages/announcements/news.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/ambassador_signin.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/auth.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/forgot_password.dart';
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
String documentPdfViewerRouteName = "document-pdf-viewer";
String documentPdfViewerPathName = "/document-pdf-viewer";
String agreementLetterUploadRouteName = "agreement-letter-upload";
String agreementLetterUploadPathName = "/agreement-letter-upload";
String agreementLetterViewRouteName = "agreement-letter-view";
String agreementLetterViewPathName = "/agreement-letter-view";
String forgotPasswordRouteName = "forgot-password";
String forgotPasswordPathName = "/forgot-password";
String ambassadorDashboardRouteName = "ambassador-dashboard";
String ambassadorDashboardPathName = "/ambassador-dashboard";
String outsideNewsRouteName = "news";
String outsideNewsPathName = "/news";
String paperOtherPageTemplatePathName = "/paper-other-page-template";
String paperOtherPageTemplateRouteName = "paper-other-page-template";
String submissionPagePathName = "/submission";
String submissionPageRouteName = "submission";

class AppRouterConfig {
  final GoRouter routeConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: homePathName,
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: outsideNewsRouteName,
        path: outsideNewsPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: News(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: forgotPasswordRouteName,
        path: forgotPasswordPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ForgotPassword(),
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
        parentNavigatorKey: _rootNavigatorKey,
        name: ambassadorDashboardRouteName,
        path: ambassadorDashboardPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AmbassadorDashboard(
            ambassador: state.extra as AmbassadorModel,
          ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: documentPdfViewerRouteName,
        path: documentPdfViewerPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: DocumentPdfViewer(
            pdfData: state.extra as Uint8List,
          ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: agreementLetterUploadRouteName,
        path: agreementLetterUploadPathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AgreementLetterUpload(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: agreementLetterViewRouteName,
        path: agreementLetterViewPathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AgreementLetterView(
            agreementLetter: state.extra as AgreementLetterModel,
          ),
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
            model: state.extra as PaymentWebViewModel,
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
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: paperOtherPageTemplateRouteName,
        path: paperOtherPageTemplatePathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: PaperOtherPageTemplate(
            item: state.extra as PaperOtherPageModel,
          ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: submissionPageRouteName,
        path: submissionPagePathName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SubmissionPage(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: AddEditAuthor.routeName,
        path: AddEditAuthor.pathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: state.extra == null
              ? const AddEditAuthor()
              : AddEditAuthor(
                  author: state.extra as PaperAuthorModel,
                ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: AddEditAbstract.routeName,
        path: AddEditAbstract.pathName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: state.extra == null
              ? const AddEditAbstract()
              : AddEditAbstract(
                  paperAbstract: state.extra as PaperAbstractModel),
        ),
      ),
    ],
  );
}
