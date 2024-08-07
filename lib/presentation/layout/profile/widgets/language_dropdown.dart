import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/localization/cubit/localization_cubit.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  String _selectedLocale = 'en_US';

  @override
  void initState() {
    super.initState();
    context.read<LocalizationCubit>().onInit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        if (state is SelectedLocalization) {
          _selectedLocale = state.locale.toString();
        }
        return DropdownButton<String>(
          value: _selectedLocale,
          items: [
            DropdownMenuItem(
              value: 'en_US',
              child: Text('English'.getLocale(context: context)),
            ),
            DropdownMenuItem(
              value: 'ar_SA',
              child: Text('Arabic'.getLocale(context: context)),
            ),
          ],
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                _selectedLocale = value;
              });
              if (value == 'en_US') {
                context.read<LocalizationCubit>().toEnglish();
              } else if (value == 'ar_SA') {
                context.read<LocalizationCubit>().toArabic();
              }
            }
          },
        );
      },
    );
  }
}
