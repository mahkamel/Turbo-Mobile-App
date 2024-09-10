import 'package:badges/badges.dart' as badges;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/main_paths.dart';
import '../../../../../core/theming/colors.dart';
import '../profile_widgets.dart';

class ProfileImageWithBadge extends StatelessWidget {
  final String imagePath;
  const ProfileImageWithBadge({super.key, required this.imagePath});

  Future _pickImageFromGallery(ProfileCubit blocRead) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      } else {
        blocRead.updateProfileImage(File(image.path));
      }
    } on PlatformException {}
  }

  Future<void> requestGalleryPermission(BuildContext context) async {
    const permission = Permission.photos;
    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        _pickImageFromGallery(context.read<ProfileCubit>());
      }
    } else {
      _pickImageFromGallery(context.read<ProfileCubit>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileImagePickedState,
      builder: (context, state) {
        String? imagePath = this.imagePath;
        bool isFromStorageImage = false;
        if (state is ProfileImagePickedState) {
          imagePath = state.imagePath;
          isFromStorageImage = true;
        }
        return Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 6),
          child: InkWell(
            onTap: () async {
              await requestGalleryPermission(context);
            },
            child: badges.Badge(
                position: badges.BadgePosition.bottomEnd(end: -10),
                badgeContent: SvgPicture.asset(
                  'assets/images/icons/uploadImage.svg',
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: AppColors.gold,
                  borderSide: BorderSide.none,
                ),
                child: ProfileImage(
                    imageUrl: imagePath,
                    isFromStorageImage: isFromStorageImage)),
          ),
        );
      },
    );
  }
}
