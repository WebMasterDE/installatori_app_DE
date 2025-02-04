import 'package:flutter/material.dart';
import 'package:horizontal_stepper_flutter/horizontal_stepper_flutter.dart';

class CustomHorizontalStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final double radius;

  const CustomHorizontalStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.radius = 45,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterHorizontalStepper(
      steps: steps,
      radius: radius,
      currentStep: currentStep,
      currentStepColor: Colors.orange,
      child: steps.map((step) => Text(step)).toList(),
    );
  }
}
