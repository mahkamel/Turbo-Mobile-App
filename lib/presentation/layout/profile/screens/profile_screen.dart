import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/widgets/custom_list_tile.dart';
import 'package:turbo/presentation/layout/profile/screens/saved_cards_screen.dart';

import '../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/shadow_container_with_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: AppConstants.screenHeight(context),
          width: AppConstants.screenWidth(context),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) =>
                current is LogoutLoadingState ||
                current is LogoutErrorState ||
                current is LogoutSuccessState,
            builder: (context, state) {
              var authWatch = context.watch<AuthRepository>();
              return Column(
                children: [
                  if (
                      authWatch.customer
                      .token
                      .isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 128,),
                          Text(
                            authWatch.customer.customerName, 
                            style: AppFonts.ibm24HeaderBlue600.copyWith(
                              color: AppColors.lightBlack
                            ),
                          ),
                          Text(
                            authWatch.customer.customerEmail,
                            style: AppFonts.ibm24HeaderBlue600.copyWith(
                              color: AppColors.lightBlack,
                              fontSize: 18
                            ),
                          ),
                          const SizedBox(height: 22,),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                CustomListTile(
                                  icon: const Icon(Icons.person, size: 30, color: AppColors.gold,),
                                  text: "Edit Account",
                                  isLogout: false,
                                  onTap: (){
                                            Navigator.of(context).pushNamed(
                                            Routes.editAccountScreen,
                                            arguments: context.read<ProfileCubit>());
                                      }
                                ),
                                CustomListTile(
                                  icon: const Icon(Icons.credit_card_rounded, size: 30, color: AppColors.gold,),
                                  text: "Payment Methods",
                                  isLogout: false,
                                  onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => BlocProvider<ProfileCubit>.value(
                                            value: context.read<ProfileCubit>()
                                              ..getAllSavedPaymentMethods(
                                                  isForceToRefresh: true)
                                              ..savedCardsInit(),
                                            child: const SavedCardsScreen(),
                                          ),
                                        ));
                                      }
                                ),
                                CustomListTile(
                                  icon: const Icon(Icons.lock, size: 30, color: AppColors.gold,),
                                  text: "Change Password",
                                  isLogout: false,
                                  onTap: (){
                                            Navigator.of(context).pushNamed(
                                            Routes.changePasswordScreen,
                                            arguments: context.read<ProfileCubit>());
                                      }
                                ),
                                const Divider(color: AppColors.divider,),
                                 CustomListTile(
                                  icon: const Icon(Icons.person_remove, size: 30, color: AppColors.gold,),
                                  text: "Delete Account",
                                  isLogout: false,
                                  onTap: (){
                                            Navigator.of(context).pushNamed(
                                            Routes.deleteAccountScreen,
                                            arguments: context.read<ProfileCubit>());
                                      }
                                ),
                                CustomListTile(
                                  icon: const Icon(Icons.logout, size: 30, color: AppColors.red,),
                                  text: "Logout",
                                  isLogout: true,
                                  onTap: (){context.read<ProfileCubit>().logout();}
                                ),
                              ],
                            ),
                          )
                        
                        ],
                      ),
                    // ShadowContainerWithPrefixTextButton(
                    //   onTap: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (_) => BlocProvider<ProfileCubit>.value(
                    //         value: context.read<ProfileCubit>()
                    //           ..getAllSavedPaymentMethods(
                    //               isForceToRefresh: true)
                    //           ..savedCardsInit(),
                    //         child: const SavedCardsScreen(),
                    //       ),
                    //     ));
                    //   },
                    //   title: "Saved Cards",
                    //   buttonText: "",
                    //   prefixIcon: const Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: AppColors.primaryBlue,
                    //   ),
                    // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Language",
                  //       style: AppFonts.inter16Black400.copyWith(
                  //         fontWeight: FontWeight.w300,
                  //       ),
                  //     ),
                  //     const LanguageDropdown(),
                  //   ],
                  // ),
                  // if (context
                  //     .watch<AuthRepository>()
                  //     .customer
                  //     .token
                  //     .isNotEmpty)
                  //   const SizedBox(
                  //     height: 8,
                  //   ),
                  // if (context
                  //     .watch<AuthRepository>()
                  //     .customer
                  //     .token
                  //     .isNotEmpty)
                  //   IconButton(
                  //     onPressed: () async {
                  //       context.read<ProfileCubit>().logout();
                  //     },
                  //     icon: state is LogoutLoadingState
                  //         ? const Center(
                  //             child: CircularProgressIndicator(),
                  //           )
                  //         : SizedBox(
                  //             height: 40,
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 const Icon(
                  //                   Icons.logout_rounded,
                  //                   color: AppColors.errorRed,
                  //                   size: 16,
                  //                 ),
                  //                 const SizedBox(
                  //                   width: 4,
                  //                 ),
                  //                 Text(
                  //                   "Logout",
                  //                   style: AppFonts.ibm14ErrorRed400,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //   ),
                  if (context
                      .watch<AuthRepository>()
                      .customer
                      .token
                      .isEmpty)
                    ShadowContainerWithPrefixTextButton(
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}