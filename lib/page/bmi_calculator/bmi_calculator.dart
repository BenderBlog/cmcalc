// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: LGPL-2.1-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calculator_bridge/calculator_bridge.g.dart';

enum BMIStatus {
  toolight(name: "Too Light"),
  underweight(name: "Under Weight"),
  normal(name: "Normal"),
  overweight(name: "Over Weight"),
  fat(name: "Fat"),
  none(name: "No Result");

  final String name;

  const BMIStatus({required this.name});

  factory BMIStatus.fromValue(double? value) {
    if (value == null) return BMIStatus.none;
    if (value < 17) return BMIStatus.toolight;
    if (value < 18.5) return BMIStatus.underweight;
    if (value < 25) return BMIStatus.normal;
    if (value < 30) return BMIStatus.overweight;
    return BMIStatus.fat;
  }
}

class BmiCalculatorState extends ChangeNotifier {
  double? _weight;
  double? _height;
  double? result;

  set weight(double? weight) {
    _weight = weight;
    bmiCalc();
  }

  set height(double? height) {
    _height = height;
    bmiCalc();
  }

  Future<void> bmiCalc() async {
    if (_weight == null || _height == null) return;
    var calc = CalculatorWrapper();
    print("$_weight/($_height*0.01)^2");
    result = double.tryParse(await calc.calculate("$_weight/$_height^2").then((value) => value.result));
    notifyListeners();
  }
}

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  static const page = "/bmi_calculator";

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  late BmiCalculatorState state;
  @override
  void initState() {
    state = BmiCalculatorState();
    state.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: TextField(
              decoration: const InputDecoration(labelText: "Height in cm"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (text) {
                state.height = double.tryParse(text);
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: TextField(
              decoration: const InputDecoration(labelText: "Weight in kg"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (text) {
                state.weight = double.tryParse(text);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Result: ${state.result?.toStringAsFixed(1) ?? "To Be Calculated."}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "Status: ${BMIStatus.fromValue(state.result).name}",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
