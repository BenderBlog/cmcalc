import 'dart:io';

import 'package:flutter/material.dart';

class KalkReplHelpPage extends StatelessWidget {
  static const page = "kalk_repl_help_page";

  const KalkReplHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patchouli REPL Help Page'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: SingleChildScrollView(
        child: Text(
          File("assets/help.txt").readAsStringSync(),
        ),
      ),
    );
  }
}
