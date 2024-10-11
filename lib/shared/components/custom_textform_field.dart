import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_color.dart';

class CustomTextFieldForm extends StatelessWidget {
  final double? fontSize;
  final FontWeight? fontWeight;
  final String label;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData prefixIcon;
  final String hintText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool showCounter;
  const CustomTextFieldForm({
    super.key,
    required this.prefixIcon,
    required this.hintText,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.keyboardType,
    this.obscureText,
    required this.label,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength = 100,
    this.showCounter = false,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    var styleText = GoogleFonts.poppins(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabel(
          text: label,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        TextFormField(
          style: styleText,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          controller: controller,
          focusNode: FocusNode(),
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          cursorColor: Theme.of(context).colorScheme.primary,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            counterText: showCounter ? null : '',
            prefixIcon: Icon(prefixIcon),
            prefixIconColor: AppColor.secondary,
            suffixIconColor: AppColor.secondary,
            prefixText: '  ',
            prefixIconConstraints: const BoxConstraints(),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.secondary,
            ),
            enabledBorder: getEnableDecorationBoder(),
            focusedBorder: getFocusDecorationBoder(),
            errorBorder: getErrorDecorationBorder(),
            focusedErrorBorder: getErrorDecorationBorder(),
          ),
        ),
      ],
    );
  }
}

UnderlineInputBorder getEnableDecorationBoder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(color: AppColor.secondary, width: 2),
  );
}

UnderlineInputBorder getFocusDecorationBoder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(color: AppColor.primary, width: 2),
  );
}

UnderlineInputBorder getErrorDecorationBorder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  );
}
