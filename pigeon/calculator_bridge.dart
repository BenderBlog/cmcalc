// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: GPL-2.0-or-later

// A general package for Qalculate!

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/calculator_bridge/calculator_bridge.g.dart',
  dartOptions: DartOptions(),
  swiftOut: 'ios/Runner/calculator_bridge.g.swift',
  swiftOptions: SwiftOptions(),
  kotlinOut: 'android/app/src/main/kotlin/io/github/benderblog/cmcalc/CalculatorBridge.g.kt',
  kotlinOptions: KotlinOptions(),
))

enum ResultType {
  success,
  warning,
  failure,
}

class CalcResult {
  CalcResult({
    required this.resultType,
    required this.message,
    required this.parsed,
    required this.result,
  });
  ResultType resultType;
  String message;
  String parsed;
  String result;
}


@HostApi()
abstract class CalculatorWrapper {
  @async
  CalcResult calculate(String command);

  @async
  String parseCommand(String command);
}