// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: LGPL-2.1-or-later

import 'package:cmcalc/page/bmi_calculator/bmi_calculator.dart';
import 'package:cmcalc/page/calendar_coverter/calendar_converter.dart';
import 'package:cmcalc/page/repl/repl_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final String title;
  final StatefulNavigationShell navigationShell;

  const HomePage({
    super.key,
    required this.title,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Cirno Math Classroom/Calculator'),
            ),
            ListTile(
              title: const Text('Qalculate REPL'),
              onTap: () => context.go(ReplPage.page),
            ),
            ListTile(
              title: const Text('BMI Calculator'),
              onTap: () => context.go(BmiCalculator.page),
            ),
            ListTile(
              title: const Text('Calendar Converter'),
              onTap: () => context.go(CalendarConverter.page),
            ),
          ],
        ),
      ),
      body: navigationShell,
    );
  }
}
