import 'package:flutter/material.dart';
import 'package:turbo/core/theming/fonts.dart';

class TextWithBullet extends StatelessWidget {
  final String text;
  const TextWithBullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: AppFonts.ibm16SubTextGrey400,),
          const SizedBox(width: 10,),
          Expanded(child: Text(text, style: AppFonts.ibm16SubTextGrey400,)),
        ],
      ),
    );
  }
}