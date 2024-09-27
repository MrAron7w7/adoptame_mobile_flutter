import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final int value;
  const CustomRadioButton({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: 1,
      groupValue: value,
      onChanged: (value) {},
    );
  }
}
