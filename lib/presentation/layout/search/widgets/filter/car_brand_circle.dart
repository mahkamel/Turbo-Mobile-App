import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../flavors.dart';
class CarBrandCircle extends StatelessWidget {
  final String logoPath;
  final bool isSelected;
  const CarBrandCircle({super.key, this.isSelected = false, required this.logoPath});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          width: 35,
          height: 35,
          imageUrl: "${FlavorConfig.instance.filesBaseUrl}$logoPath",
          errorWidget: (context, url, error) => Image.asset('assets/images/image.png', width: 35, height: 35,),
          placeholder: (context, url) => const SizedBox(),
        ),
      ],
    );
  }
}