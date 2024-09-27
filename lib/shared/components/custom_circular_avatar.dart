import 'package:flutter/material.dart';

class CustomCircularAvatar extends StatelessWidget {
  final String image;
  final double size;
  const CustomCircularAvatar({
    super.key,
    required this.image,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadiusDirectional.circular(100),
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage(image),
        ),
      ),
    );
  }
}
