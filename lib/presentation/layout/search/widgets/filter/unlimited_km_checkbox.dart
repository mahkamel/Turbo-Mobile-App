import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/theming/fonts.dart';

class UnlimitedKMCheckbox extends StatelessWidget {
  const UnlimitedKMCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Unlimited KM",
          style: AppFonts.inter14Black400,
        ),
        const Spacer(),
        BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (previous, current) =>
          current is ChangeIsWithUnlimitedKMValueState ||
              current is FilterResetState,
          builder: (context, state) {
            return Checkbox(
              visualDensity: VisualDensity.standard,
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
              value: context.watch<SearchCubit>().isWithUnlimitedKM,
              onChanged: (value) {
                if (value != null) {
                  context
                      .read<SearchCubit>()
                      .changeIsWithUnlimitedKMValue(value);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
