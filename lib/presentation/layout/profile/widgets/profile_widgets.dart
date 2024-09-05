import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/shadow_container_with_button.dart';
import '../../../../main_paths.dart';

Widget loginContainer(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ShadowContainerWithPrefixTextButton(
      margin: const EdgeInsets.only(top: 8),
      onTap: () {
        Navigator.of(context).pushNamed(Routes.loginScreen);
      },
      title: "Login to your account",
      buttonText: "",
      prefixIcon: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppColors.primaryBlue,
      ),
    ),
  );
}

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
              fit: BoxFit.cover, 
            ) : 
      CachedNetworkImage(
        placeholder: (context, url) => AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            'assets/images/profileImage.png',
            fit: BoxFit.cover,
            height: 92,
            width: 92,
          ),
        ),
        errorWidget: (context, url, error) => AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            'assets/images/profileImage.png',
            fit: BoxFit.cover,
            height: 92,
            width: 92,
          ),
        ),
        fit: BoxFit.cover,
        imageUrl: imageUrl,
        height: 92,
        width: 92,

      ),
    );
  }
}
