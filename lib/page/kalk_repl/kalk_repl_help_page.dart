import 'package:flutter/material.dart';

class KalkReplHelpPage extends StatelessWidget {
  static const page = "kalk_repl_help_page";

  const KalkReplHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> helpText =
        DefaultAssetBundle.of(context).loadString("assets/help.txt");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patchouli REPL Help Page'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: FutureBuilder(
        future: helpText,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Cannot load help page."),
            );
          } else if (snapshot.hasData) {
            return SafeArea(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Text(snapshot.data!),
            ));
          } else {
            return const Center(
              child: Text("Loading help page..."),
            );
          }
        },
      ),
    );
  }
}
