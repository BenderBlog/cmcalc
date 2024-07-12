import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cmcalc/src/rust/frb_generated.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'page/router.dart';

Future<void> main() async {
  /// Google font library setting.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/Fira_Code/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Fira_Code'], license);
  });
  GoogleFonts.config.allowRuntimeFetching = false;

  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'cmcalc',
    );
  }
}
