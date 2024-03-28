import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ybb_event_app/pages/landing_pages/about_us.dart';
import 'package:ybb_event_app/pages/landing_pages/home/home.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouterConfig {
  final GoRouter routeConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: "/",
    routes: [
      GoRoute(
        name: "home",
        path: "/",
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Home(),
        ),
      ),
      GoRoute(
        name: "about-us",
        path: "/about-us",
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AboutUs(),
        ),
      ),
    ],
  );
}
