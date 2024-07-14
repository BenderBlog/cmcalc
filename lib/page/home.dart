import 'package:cmcalc/page/bmi_calculator/bmi_calculator.dart';
import 'package:cmcalc/page/kalk_repl/kalk_repl_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final String title;
  final Widget child;

  const HomePage({
    super.key,
    required this.title,
    required this.child,
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
              title: const Text('Yuyuko BMI Calculator'),
              onTap: () => context.go(BmiCalculator.page),
            ),
            ListTile(
              title: const Text('Patchouli REPL'),
              onTap: () => context.go(KalkReplPage.page),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
