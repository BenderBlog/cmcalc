// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: LGPL-2.1-or-later

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'page/router.dart';

Future<void> main() async {
  /// Google font library setting.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/Fira_Code/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Fira_Code'], license);
  });
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
      ],
      title: 'cmcalc',
    );
  }
}
