import 'package:flutter/material.dart';


class CustomActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double sizeHeight;
  const CustomActionButton({
    super.key,
    this.onPressed,
    required this.child,
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
        child: child, // Aquí puedes pasar cualquier widget
      ),
    );
  }
}

