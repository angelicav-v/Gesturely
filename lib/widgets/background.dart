import 'package:flutter/material.dart';

class GesturelyBackground extends StatelessWidget {
  final Widget child;

  const GesturelyBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
          colors: [
            Color(0xFFE8C8D8), // Soft pink/mauve top-left
            Color(0xFFFFD9B8), // Peachy tone
            Color(0xFFFFF5C4), // Soft yellow middle
            Color(0xFFD4E8E8), // Light teal
            Color(0xFF9FD9D9), // Teal bottom-right
          ],
        ),
      ),
      child: child,
    );
  }
}
