import 'package:flutter/material.dart';

class CustomPadding extends StatelessWidget {
  final Widget child;
  final double padding;
  const CustomPadding({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
