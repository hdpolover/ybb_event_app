import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
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
      ],
      child: MaterialApp.router(
        routerConfig: AppRouterConfig().routeConfig,
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: Builder(builder: (context) {
            return ResponsiveScaledBox(
                width: ResponsiveValue<double?>(context,
                    defaultValue: null,
                    conditionalValues: [
                      const Condition.equals(name: 'MOBILE_SMALL', value: 480),
                    ]).value,
                child: ClampingScrollWrapper.builder(context, widget!));
          }),
          breakpoints: [
            const Breakpoint(start: 0, end: 480, name: 'MOBILE_SMALL'),
            const Breakpoint(start: 481, end: 850, name: MOBILE),
            const Breakpoint(start: 850, end: 1080, name: TABLET),
            const Breakpoint(start: 1081, end: double.infinity, name: DESKTOP),
          ],
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
