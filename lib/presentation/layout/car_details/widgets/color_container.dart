import 'package:flutter/material.dart';

class ColorContainer extends StatelessWidget {
  final int color;
  const ColorContainer({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      width: 23,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(color),
      ),
    );
  }
}