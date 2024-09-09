import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/models/program_announcement_model.dart';
import 'package:ybb_event_app/providers/announcement_provider.dart';
import 'package:ybb_event_app/providers/app_provider.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ProgramProvider>(
            create: (_) => ProgramProvider()),
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<ParticipantProvider>(
            create: (_) => ParticipantProvider()),
        ChangeNotifierProvider<PaymentProvider>(
            create: (_) => PaymentProvider()),
        ChangeNotifierProvider<AnnouncementProvider>(
            create: (_) => AnnouncementProvider()),
      ],
      child: MaterialApp.router(
        title: 'YBB Event App',
        theme: ThemeData(
          primaryColor: primary,
          fontFamily: 'Poppins',
        ),
        routerConfig: AppRouterConfig().routeConfig,
        // builder: (context, widget) => ResponsiveBreakpoints.builder(
        //   child: Builder(builder: (context) {
        //     return ResponsiveScaledBox(
        //         width: ResponsiveValue<double?>(context,
        //             defaultValue: null,
        //             conditionalValues: [
        //               const Condition.equals(name: 'MOBILE_SMALL', value: 480),
        //             ]).value,
        //         child: ClampingScrollWrapper.builder(context, widget!));
        //   }),
        //   breakpoints: [
        //     const Breakpoint(start: 0, end: 480, name: 'MOBILE_SMALL'),
        //     const Breakpoint(start: 481, end: 850, name: MOBILE),
        //     const Breakpoint(start: 850, end: 1080, name: TABLET),
        //     const Breakpoint(start: 1081, end: double.infinity, name: DESKTOP),
        //   ],
        // ),
        debugShowCheckedModeBanner: false,
      ),
      // child: ResponsiveSizer(builder: (context, orientation, screenType) {
      //   return MaterialApp.router(
      //     theme: ThemeData(
      //       primaryColor: primary,
      //       fontFamily: 'Poppins',
      //     ),
      //     routerConfig: AppRouterConfig().routeConfig,
      //     builder: (context, widget) => ResponsiveBreakpoints.builder(
      //       child: Builder(builder: (context) {
      //         return ResponsiveScaledBox(
      //             width: ResponsiveValue<double?>(context,
      //                 defaultValue: null,
      //                 conditionalValues: [
      //                   const Condition.equals(
      //                       name: 'MOBILE_SMALL', value: 480),
      //                 ]).value,
      //             child: ClampingScrollWrapper.builder(context, widget!));
      //       }),
      //       breakpoints: [
      //         const Breakpoint(start: 0, end: 480, name: 'MOBILE_SMALL'),
      //         const Breakpoint(start: 481, end: 850, name: MOBILE),
      //         const Breakpoint(start: 850, end: 1080, name: TABLET),
      //         const Breakpoint(
      //             start: 1081, end: double.infinity, name: DESKTOP),
      //       ],
      //     ),
      //     debugShowCheckedModeBanner: false,
      //   );
      // }),
    );
  }
}
