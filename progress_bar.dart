import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({required this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      minHeight: 10,
      backgroundColor: Colors.grey.shade300,
      color: Colors.blue,
    );
  }
}
