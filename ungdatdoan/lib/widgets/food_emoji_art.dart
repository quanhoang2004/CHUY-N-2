import 'package:flutter/material.dart';

class FoodEmojiArt extends StatelessWidget {
  final String emoji;
  final double size;

  const FoodEmojiArt({
    super.key,
    required this.emoji,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.6),
        ),
      ),
    );
  }
}