import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/presentation/layout/profile/widgets/edit_account_widgets/address.dart';
import 'package:turbo/presentation/layout/profile/widgets/edit_account_widgets/email.dart';
import 'package:turbo/presentation/layout/profile/widgets/edit_account_widgets/name.dart';
import 'package:turbo/presentation/layout/profile/widgets/edit_account_widgets/national_id.dart';
import 'package:turbo/presentation/layout/profile/widgets/edit_account_widgets/phone_number.dart';

import '../../../../core/widgets/default_buttons.dart';

class EditAccountScreen extends StatelessWidget {
  const EditAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<ProfileCubit>();
    var authRead = context.read<AuthRepository>();
    blocRead.profileName.text = authRead.customer.customerName;
    blocRead.profileEmail.text = authRead.customer.customerEmail;
    blocRead.profileAddress.text = authRead.customer.customerAddress;
    // blocRead.profilePhoneNumber.text = authRead.customer.cus;
    // blocRead.profileNationalIdNumber = authRead.customer.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: AppConstants.screenHeight(context),
          width: AppConstants.screenWidth(context),
          child: Column(
            children: [
              DefaultHeader(header: "Edit Profile",onBackPressed: () => Navigator.of(context).pop(),),
              const SizedBox(height: 100,),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileName(),
                      ProfileEmail(),
                      ProfileAddress(),
                      ProfilePhoneNumber(),
                      ProfileNationalId(),
                    ],
                  ),
                ),
              ),
              
              DefaultButton(
                function: () {
                  // context.read<LoginCubit>().changePassword();
                },
                text: "Save",
                marginRight: 16,
                marginLeft: 16,
                marginBottom: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}