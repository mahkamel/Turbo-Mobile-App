import 'package:flutter/material.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/core/theming/fonts.dart';

class CustomListTile extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool isLogout;
  final VoidCallback onTap;
  const CustomListTile({super.key, required this.icon, required this.text, required this.isLogout, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title:Text(
          text, 
          style: isLogout ?
           AppFonts.ibm18HeaderBlue600.copyWith(
            color: AppColors.red
           ) : 
           AppFonts.ibm18HeaderBlue600.copyWith(
            color: AppColors.lightBlack
           ),
        ),
      trailing:!isLogout ? 
        const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.gold, size: 20,) : const SizedBox(),
      onTap: onTap,
    );
  }
}