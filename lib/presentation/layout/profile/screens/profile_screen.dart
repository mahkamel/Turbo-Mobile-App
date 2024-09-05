import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/widgets/custom_list_tile.dart';
import 'package:turbo/main_paths.dart';
import 'package:turbo/presentation/auth/forget_password/screens/create_new_password_screen.dart';
import 'package:turbo/presentation/layout/profile/screens/saved_cards_screen.dart';
import '../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_dialog.dart';
import '../../../../core/widgets/snackbar.dart';
import '../widgets/profile_widgets.dart';

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
                current is LogoutSuccessState ||
                current is EditProfileSuccessState,
            builder: (context, state) {
              var authWatch = context.watch<AuthRepository>();
              String? imagePath = context.read<AuthRepository>().customer.customerImageProfilePath;
              return Column(
                children: [
                  if (authWatch.customer.token.isNotEmpty)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 44, bottom: 25),
                          child: ProfileImage(imageUrl: imagePath != null ? getCompleteFileUrl(imagePath) : "",),
                        ),
                        Text(
                          authWatch.customer.customerName,
                          style: AppFonts.ibm24HeaderBlue600
                              .copyWith(color: AppColors.lightBlack),
                        ),
                        Text(
                          authWatch.customer.customerTelephone,
                          style: AppFonts.ibm24HeaderBlue600.copyWith(
                              color: AppColors.lightBlack, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomListTile(
                                  icon: const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: AppColors.gold,
                                  ),
                                  text: "Edit Account",
                                  isLogout: false,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.editAccountScreen,
                                        arguments:
                                            context.read<ProfileCubit>());
                                  }),
                              CustomListTile(
                                  icon: const Icon(
                                    Icons.credit_card_rounded,
                                    size: 30,
                                    color: AppColors.gold,
                                  ),
                                  text: "Payment Methods",
                                  isLogout: false,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) =>
                                          BlocProvider<ProfileCubit>.value(
                                        value: context.read<ProfileCubit>()
                                          ..getAllSavedPaymentMethods(
                                              isForceToRefresh: true)
                                          ..savedCardsInit(),
                                        child: const SavedCardsScreen(),
                                      ),
                                    ));
                                  }),
                              CustomListTile(
                                  icon: const Icon(
                                    Icons.lock,
                                    size: 30,
                                    color: AppColors.gold,
                                  ),
                                  text: "Change Password",
                                  isLogout: false,
                                  onTap: () {
                                   Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider<LoginCubit>(
                                          create: (_) => getIt<LoginCubit>(),
                                          child: const CreateNewPassword(isFromProfile: true,),
                                        ),
                                      ),
                                    );
                                  }),
                              const Divider(
                                color: AppColors.divider,
                              ),
                              CustomListTile(
                                  icon: const Icon(
                                    Icons.person_remove,
                                    size: 30,
                                    color: AppColors.gold,
                                  ),
                                  text: "Delete Account",
                                  isLogout: false,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.deleteAccountScreen,
                                        arguments:
                                            context.read<ProfileCubit>());
                                  }),
                              CustomListTile(
                                  icon: const Icon(
                                    Icons.logout,
                                    size: 30,
                                    color: AppColors.red,
                                  ),
                                  text: "Logout",
                                  isLogout: true,
                                  onTap: () async {
                                    showAdaptiveDialog(
                                        context: context,
                                        builder: (dialogContext) => BlocProvider.value(
                                          value: context.read<ProfileCubit>(),
                                          child: BlocConsumer<ProfileCubit, ProfileState>(
                                            listenWhen: (previous, current) {
                                                return current is LogoutErrorState ||
                                                current is LogoutSuccessState;
                                              },
                                              listener: (context, state) {
                                                if(state is LogoutErrorState){
                                                  defaultErrorSnackBar(context: context, message: state.errMsg);
                                                } else if(state is LogoutSuccessState){
                                                  if (Navigator.of(dialogContext).canPop()) {
                                                    Navigator.of(dialogContext).pop();
                                                  }
                                                }
                                              },
                                            builder: (context, state) {
                                              return DefaultDialog(
                                                secondButtonColor: AppColors.darkRed,
                                                onSecondButtonTapped: () {
                                                  context.read<ProfileCubit>().logout();
                                                },
                                                loading: state is LogoutLoadingState,
                                                secondButtonText: "Yes, Logout",
                                                title:
                                                    "Already Leaving?",
                                                subTitle:
                                                    "Are you sure you want to logout?",
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  if (context.watch<AuthRepository>().customer.token.isEmpty)
                    loginContainer(context)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
