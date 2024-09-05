import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
 const ProfileImage({
    super.key,
    required this.imageUrl,
    this.isFromStorageImage = false,
  });
  final String imageUrl;
  final bool isFromStorageImage;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: isFromStorageImage ?  Image.file(
              File(imageUrl), 
              height: 92,
              width: 92,
              fit: BoxFit.contain, 
            ) : 
      CachedNetworkImage(
        placeholder: (context, url) => AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            'assets/images/profileImage.png',
            fit: BoxFit.contain,
            height: 92,
            width: 92,
          ),
        ),
        errorWidget: (context, url, error) => AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            'assets/images/profileImage.png',
            fit: BoxFit.contain,
            height: 92,
            width: 92,
          ),
        ),
        fit: BoxFit.contain,
        imageUrl: imageUrl,
        height: 92,
        width: 92,

      ),
    );
  }
}
