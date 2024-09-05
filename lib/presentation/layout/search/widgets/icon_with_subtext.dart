import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:badges/badges.dart' as badges;
import 'package:turbo/core/theming/fonts.dart';

class IconWithSubtext extends StatelessWidget {
  final bool isSelected;
  final String iconPath;
  final String subtext;
  const IconWithSubtext({super.key, this.isSelected = false, required this.iconPath, required this.subtext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        badges.Badge(
          position: badges.BadgePosition.topEnd(end: -6, top: -2),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: AppColors.green,
          ),
          badgeContent: const Icon(Icons.check, size: 10, color: AppColors.white,),
          showBadge: isSelected,
          child: Container(
            width: 65,
            height: 60,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? Border.all(color: AppColors.green) : null,
              color: AppColors.white,
              boxShadow: [
                 BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                  color: AppColors.black.withOpacity(0.15)
                ),
                 BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                  color: AppColors.black.withOpacity(0.3)
                )
              ]
            ),
            child: SvgPicture.asset(iconPath,),
          ),
        ),
        const SizedBox(height: 10,),
        Text(
          subtext,
          style: isSelected ? AppFonts.ibm12SubTextGrey600.copyWith(color: AppColors.green) :
          AppFonts.ibm12SubTextGrey600.copyWith(color: AppColors.lightBlack)
        )
        
      ],
    );
  }
}