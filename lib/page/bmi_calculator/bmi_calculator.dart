/*
import 'package:flutter/material.dart';
import 'package:cmcalc/src/rust/api/numbat_wrapper.dart' as numbat;

enum HeightUnit {
  meter,
  centimeter,
}

enum BMIStatus {
  toolight(name: "Too Light"),
  underweight(name: "Under Weight"),
  normal(name: "Normal"),
  overweight(name: "Over Weight"),
  fat(name: "Fat");

  final String name;

  const BMIStatus({required this.name});

  factory BMIStatus.fromValue(double value) {
    if (value < 17) return BMIStatus.toolight;
    if (value < 18.5) return BMIStatus.underweight;
    if (value < 25) return BMIStatus.normal;
    if (value < 30) return BMIStatus.overweight;
    return BMIStatus.fat;
  }
}

class BmiCalculatorState extends ChangeNotifier {
  double? result;
  void bmiCalc(double weight, double height, HeightUnit heightUnit) {
    if (heightUnit == HeightUnit.centimeter) {
      height /= 100;
    }
    result = numbat.bmiCalc(weight: weight, height: height);
    notifyListeners();
  }
}

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  static const page = "bmi_calculator";

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Yuyuko Calculator"),
      ),
      body: Column(
        children: [
          TextField(),
          TextField(),
          TextButton(onPressed: () => state.bmiCalc, child: child)
          Text(
            "Result: ${state.result?.toStringAsFixed(1) ?? "to be calculated."}",
          ),
          Text(
            "Status: ${BMIStatus.fromValue(state.result).name}",
          ),
        ],
      ),
    );
  }
}
*/