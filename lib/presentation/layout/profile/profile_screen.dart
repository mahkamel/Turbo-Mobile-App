import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/presentation/layout/profile/saved_cards_screen.dart';
import 'package:turbo/presentation/layout/profile/widgets/language_dropdown.dart';

import '../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';
import '../../../core/widgets/shadow_container_with_button.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),

                BlocBuilder<ProfileCubit, ProfileState>(
                  buildWhen: (previous, current) =>
                      current is LogoutLoadingState ||
                      current is LogoutErrorState ||
                      current is LogoutSuccessState,
                  builder: (context, state) {
                    return Column(
                      children: [

                        if (context
                            .watch<AuthRepository>()
                            .customer
                            .token
                            .isNotEmpty)
                          ShadowContainerWithPrefixTextButton(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    BlocProvider<ProfileCubit>.value(
                                  value: context.read<ProfileCubit>()
                                    ..getAllSavedPaymentMethods(
                                        isForceToRefresh: true)
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
                        if (context
                            .watch<AuthRepository>()
                            .customer
                            .token
                            .isNotEmpty)
                          const SizedBox(
                            height: 8,
                          ),
                        if (context
                            .watch<AuthRepository>()
                            .customer
                            .token
                            .isNotEmpty)
                          IconButton(
                            onPressed: () async {
                              context.read<ProfileCubit>().logout();
                            },
                            icon: state is LogoutLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.logout_rounded,
                                          color: AppColors.errorRed,
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "Logout",
                                          style: AppFonts.inter14ErrorRed400,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        if (context
                            .watch<AuthRepository>()
                            .customer
                            .token
                            .isEmpty)
                          ShadowContainerWithPrefixTextButton(
                            margin: const EdgeInsets.only(top: 8),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.loginScreen);
                            },
                            title: "Login to your account",
                            buttonText: "",
                            prefixIcon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: AppColors.primaryRed,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Language",
                      style:  AppFonts.inter16Black400.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const LanguageDropdown(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
