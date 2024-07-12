import 'package:cmcalc/page/kalk_repl/kalk_repl_help_page.dart';
import 'package:cmcalc/page/kalk_repl/kalk_repl_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const KalkReplPage(),
      routes: [
        GoRoute(
          path: 'help',
          builder: (context, state) => const KalkReplHelpPage(),
        ),
      ],
    ),
  ],
);
