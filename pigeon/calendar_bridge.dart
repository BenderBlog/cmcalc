// Copyright 2025 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: GPL-2.0-or-later

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/calculator_bridge/calendar_bridge.g.dart',
  dartOptions: DartOptions(),
  objcHeaderOut: 'ios/Runner/CalendarBridge.g.h',
  objcSourceOut: 'ios/Runner/CalendarBridge.g.mm',
  objcOptions: ObjcOptions(),
  kotlinOut:
      'android/app/src/main/kotlin/io/github/benderblog/cmcalc/CalendarBridge.g.kt',
  kotlinOptions: KotlinOptions(),
))
enum CalendarSystemFromDart {
  gregorian,
  milankovic,
  julian,
  islamic,
  hebrew,
  egyptian,
  persian,
  coptic,
  ethiopian,
  indian,
  chinese,
}

class CalendarExecuteState {
  bool isSuccess;
  String? message;
  Map<CalendarSystemFromDart, List> data;

  CalendarExecuteState({
    required this.isSuccess,
    required this.message,
    required this.data,
  });
}

@HostApi()
abstract class CalendarWrapper {
  @async
  CalendarExecuteState setCalendar(
    // IN CHINESE: 金木水火土
    int? yearStem,
    // IN CHINESE：十二生肖
    int year,
    int month,
    int day,
    CalendarSystemFromDart calendarSystem,
  );
}
