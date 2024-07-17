import 'package:cmcalc/page/bmi_calculator/bmi_calculator.dart';
import 'package:cmcalc/page/home.dart';
import 'package:cmcalc/page/kalk_repl/kalk_repl_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');
// GoRouter configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: KalkReplPage.page,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        final String? routeName = GoRouterState.of(context).topRoute?.name;
        return HomePage(
          title: routeName ?? "Unknown",
          navigationShell: navigationShell,
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          //navigatorKey: _sectionANavigatorKey,
          routes: [
            GoRoute(
              path: KalkReplPage.page,
              name: "Marisa REPL",
              builder: (context, state) => const KalkReplPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          //navigatorKey: _sectionANavigatorKey,
          routes: [
            GoRoute(
              path: BmiCalculator.page,
              name: "Yuyuko BMI Calculator",
              builder: (context, state) => const BmiCalculator(),
            ),
          ],
        ),
      ],
    ),
  ],
);
