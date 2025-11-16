import 'package:flutter/material.dart';

class GesturelyBackground extends StatelessWidget {
  final Widget child;

  const GesturelyBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8D0D8), // Soft pink/mauve top-left
            Color(0xFFFFE5B4), // Warm peachy-cream top-right
            Color(0xFFA8D4B8), // Slight hint of teal bottom-left
            Color(0xFFFFF0B8), // Soft yellow-cream bottom-right
          ],
        ),
      ),
      child: child,
    );
  }
}