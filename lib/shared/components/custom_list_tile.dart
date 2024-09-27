import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String text;
  final Widget? trailing;
  final IconData? icon;
  final void Function()? onTap;
  const CustomListTile({
    super.key,
    required this.text,
    this.trailing,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: CustomLabel(
        text: text,
      ),
      trailing: trailing,
      leading: CustomIcon(icon: icon!),
    );
  }
}
