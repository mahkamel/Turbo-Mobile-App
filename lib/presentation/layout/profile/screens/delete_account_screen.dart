import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/presentation/layout/profile/widgets/delete_account_widgets/text_with_bullet.dart';

import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/snackbar.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: AppConstants.screenWidth(context),
          height: AppConstants.screenHeight(context),
          child: Column(
            children: [
              DefaultHeader(
                header: "Delete Account",
                onBackPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Deleting your account is permanent and cannot be undone. Once your account is deleted:",
                          style: AppFonts.ibm16SubTextGrey400,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const TextWithBullet(
                            text:
                                "All your data, including your profile information and bookings, will be permanently erased."),
                        const TextWithBullet(
                            text:
                                'You will lose access to all services and content associated with your account.'),
                        const TextWithBullet(
                            text:
                                'Any purchases tied to your account will be terminated.'),
                        Text(
                          "If you still wish to proceed, please confirm by clicking the button below. If not, you can cancel and keep your account active.",
                          style: AppFonts.ibm16SubTextGrey400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocConsumer<ProfileCubit, ProfileState>(
                listenWhen: (previous, current) {
                  return current is DeleteProfileErrorState ||
                      current is DeleteProfileSuccessState ||
                      current is DeleteProfileLoadingState ||
                      current is LogoutErrorState ||
                      current is LogoutLoadingState ||
                      current is LogoutSuccessState;
                },
                listener: (context, state) {
                  if(state is DeleteProfileErrorState){
                    defaultErrorSnackBar(context: context, message: state.errMsg);
                  } else if(state is LogoutErrorState){
                    defaultErrorSnackBar(context: context, message: state.errMsg);
                  } else if(state is LogoutSuccessState){
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 90,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: DefaultButton(
                              function: () {
                                context.read<ProfileCubit>().deleteProfile();
                                context.read<ProfileCubit>().logout();
                              },
                              loading: state is DeleteProfileLoadingState || state is LogoutLoadingState,
                              text: "Delete",
                              marginTop: 20,
                              marginBottom: 20,
                              marginRight: 16,
                              marginLeft: 16,
                              borderRadius: 20,
                              color: AppColors.grey500,
                              border: Border.all(color: AppColors.darkRed),
                              textColor: AppColors.darkRed,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 90,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: DefaultButton(
                              function: () {
                                Navigator.of(context).pop();
                              },
                              // loading: state is EditProfileLoadingState,
                              text: "Keep Account",
                              marginTop: 20,
                              marginBottom: 20,
                              marginRight: 16,
                              marginLeft: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
