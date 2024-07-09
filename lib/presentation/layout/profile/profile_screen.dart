import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/localization/cubit/localization_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/presentation/layout/profile/saved_cards_screen.dart';

import '../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/shadow_container_with_button.dart';

enum LocaleCode { en_US, ar_SA }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: AppConstants.screenHeight(context),
          width: AppConstants.screenWidth(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                ShadowContainerWithPrefixTextButton(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider<ProfileCubit>.value(
                        value: context.read<ProfileCubit>()
                          ..getAllSavedPaymentMethods(isForceToRefresh: true)
                          ..savedCardsInit(),
                        child: const SavedCardsScreen(),
                      ),
                    ));
                  },
                  title: "Saved Cards",
                  buttonText: "",
                  prefixIcon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.primaryRed,
                  ),
                ),
                BlocBuilder<LocalizationCubit, LocalizationState>(
                  builder: (context, state) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Language"),
                      DropdownButton<LocaleCode>(
                        value: LocaleCode.en_US,
                        items: LocaleCode.values
                            .map((code) => DropdownMenuItem(
                                  value: code,
                                  child: Text(code == LocaleCode.en_US
                                      ? 'English'
                                      : 'عربي'),
                                ))
                            .toList(),
                        onChanged: (code) {
                          if (code == LocaleCode.ar_SA) {
                            context.read<LocalizationCubit>().toArabic();
                          } else {
                            context.read<LocalizationCubit>().toEnglish();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
