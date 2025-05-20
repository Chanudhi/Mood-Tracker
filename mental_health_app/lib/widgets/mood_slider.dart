import 'package:flutter/material.dart';

class MoodSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const MoodSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: 0,
      max: 10,
      divisions: 10,
      label: value.round().toString(),
      onChanged: onChanged,
    );
  }
}