import 'package:cmcalc/page/bmi_calculator/bmi_calculator.dart';
import 'package:cmcalc/page/home.dart';
import 'package:cmcalc/page/kalk_repl/kalk_repl_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

// GoRouter configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: BmiCalculator.page,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        final String? routeName = GoRouterState.of(context).topRoute?.name;
        return HomePage(title: routeName ?? "Unknown", child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: BmiCalculator.page,
          name: "Yuyuko BMI Calculator",
          builder: (context, state) => const BmiCalculator(),
        ),
        GoRoute(
          path: KalkReplPage.page,
          name: "Patchouli REPL",
          builder: (context, state) => const KalkReplPage(),
        ),
      ],
    ),
  ],
);
