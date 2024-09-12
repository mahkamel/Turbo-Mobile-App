import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/default_buttons.dart';
import '../../../../../core/widgets/snackbar.dart';

class ResetBtn extends StatelessWidget {
  const ResetBtn({super.key});

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return DefaultButton(
      marginBottom: 59,
      width: 102,
      height: 42,
      function: () {
        searchCubitRead.resetSearch();
      },
      borderRadius: 20,
      color: AppColors.white,
      textColor: AppColors.gold,
      fontWeight: FontWeight.w600,
      border: Border.all(color: AppColors.gold),
      text: "Reset All",
    );
  }
}

class FilterResultsBtn extends StatelessWidget {
  const FilterResultsBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return BlocListener<SearchCubit, SearchState>(
      listenWhen: (previous, current) => current is GetFilteredCarsErrorState,
      listener: (context, state) {
        if (state is GetFilteredCarsErrorState) {
          defaultErrorSnackBar(
            context: context,
            message: state.errMsg,
          );
        }
      },
      child: DefaultButton(
        marginTop: 0,
        height: 48,
        function: () {
          searchCubitRead.applyFilter();
        },
        borderRadius: 20,
        color: AppColors.primaryBlue,
        textColor: AppColors.white,
        border: Border.all(color: AppColors.primaryBlue),
        text: "View Results",
      ),
    );
  }
}

