import 'package:flutter/material.dart';
import 'package:turbo/models/car_details_model.dart';
import 'package:turbo/presentation/layout/car_details/widgets/color_container.dart';

class CarColors extends StatelessWidget {

  final List<CarColor> colors;
  const CarColors({super.key, required this.colors});
  int hexToColor(String hexColor) {
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }
    return int.parse('0xFF$hexColor');
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: [
        ...List.generate(
          colors.length, 
          (index) => ColorContainer(color: hexToColor(colors[index].color))
        )
      ],
    );
  }
}