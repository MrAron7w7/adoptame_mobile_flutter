import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double sizeHeight;
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.sizeHeight = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: Size(double.infinity, sizeHeight),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: CustomLabel(
          text: text,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
