import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/localization/cubit/localization_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
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
          child: Column(
            children: [
              BlocBuilder<LocalizationCubit, LocalizationState>(
                builder: (context, state) => Row(
                  children: [
                    Text(state.locale.languageCode),
                    const SizedBox(width: 10),
                    DropdownButton<LocaleCode>(
                      value: LocaleCode.en_US,
                      items: LocaleCode.values
                          .map((code) => DropdownMenuItem(
                                value: code,
                                child: Text(
                                    code == LocaleCode.en_US ? 'English' : 'عربي'),
                              ))
                          .toList(),
                      onChanged: (code) =>
                          context.read<LocalizationCubit>().setLocale(LocaleCode.en_US.name),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
