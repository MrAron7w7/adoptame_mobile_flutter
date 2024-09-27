import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobileView;
  final Widget webView;
  const Responsive({
    super.key,
    required this.mobileView,
    required this.webView,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Modo web
          return webView;
        } else {
          // Modo mobile
          return mobileView;
        }
      },
    );
  }
}
