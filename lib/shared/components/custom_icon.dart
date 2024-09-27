import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color? colorIcon;
  final double? sizeIcon;

  const CustomIcon({
    super.key,
    required this.icon,
    this.colorIcon,
    this.sizeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: colorIcon ?? Theme.of(context).colorScheme.primary,
      size: sizeIcon,
    );
  }
}
