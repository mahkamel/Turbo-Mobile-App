import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../blocs/localization/cubit/localization_cubit.dart';
import '../../core/helpers/constants.dart';
import '../../core/theming/colors.dart';
import '../../core/widgets/default_buttons.dart';
import 'onboarding_screen.dart';

class FirstSelectLangScreen extends StatelessWidget {
  const FirstSelectLangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          height: AppConstants.screenSize(context).height,
          width: AppConstants.screenSize(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "selectYourLang".getLocale(context: context),
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LangContainer(
                    isSelected: context
                        .watch<LocalizationCubit>()
                        .state
                        .locale
                        .toString()
                        .contains('en'),
                    imgPath: "assets/images/us_circle_flag.png",
                    lang: "English".getLocale(context: context),
                    onTap: () {
                      context.read<LocalizationCubit>().toEnglish();
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  LangContainer(
                    isSelected: context
                        .watch<LocalizationCubit>()
                        .state
                        .locale
                        .toString()
                        .contains('ar'),
                    imgPath: "assets/images/sa-circle-flag.png",
                    lang: "Arabic".getLocale(context: context),
                    onTap: () {
                      context.read<LocalizationCubit>().toArabic();
                    },
                  ),
                ],
              ),
              DefaultButton(
                marginTop: 24,
                marginLeft: 20,
                marginRight: 20,
                width: 140,
                function: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                  );
                },
                text: "done".getLocale(context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LangContainer extends StatelessWidget {
  const LangContainer({
    super.key,
    required this.isSelected,
    required this.imgPath,
    required this.lang,
    required this.onTap,
  });

  final bool isSelected;
  final String imgPath;
  final String lang;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: (AppConstants.screenSize(context).width - 60) / 2,
        width: (AppConstants.screenSize(context).width - 60) / 2,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppColors.primaryRed,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgPath,
              height: (AppConstants.screenSize(context).width - 60) / 4,
              width: (AppConstants.screenSize(context).width - 60) / 4,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              lang,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
