import 'package:adoptme/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

void showProgressIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: AppColor.transparent,
      content: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    ),
  );
}

// Espacidao entre Column e Row
SizedBox gapW(double w) {
  return SizedBox(width: w);
}

SizedBox gapH(double h) {
  return SizedBox(height: h);
}
