// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: LGPL-2.1-or-later

import 'package:cmcalc/page/bmi_calculator/bmi_calculator.dart';
import 'package:cmcalc/page/calendar_coverter/calendar_converter.dart';
import 'package:cmcalc/page/home.dart';
import 'package:cmcalc/page/repl/repl_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
// GoRouter configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: ReplPage.page,
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
              path: ReplPage.page,
              name: "Qalculate REPL",
              builder: (context, state) => const ReplPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          //navigatorKey: _sectionANavigatorKey,
          routes: [
            GoRoute(
              path: BmiCalculator.page,
              name: "BMI Calculator",
              builder: (context, state) => const BmiCalculator(),
            ),
          ],
        ),
        StatefulShellBranch(
          //navigatorKey: _sectionANavigatorKey,
          routes: [
            GoRoute(
              path: CalendarConverter.page,
              name: "Calendar Converter",
              builder: (context, state) => const CalendarConverter(),
            ),
          ],
        ),
      ],
    ),
  ],
);
