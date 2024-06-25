import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/search/search_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/presentation/layout/search/widgets/filter.dart';

import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';
import '../home/widgets/cars_by_types_listview.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    var searchCubitWatch = context.watch<SearchCubit>();
    return Scaffold(
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 28,
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                child: Center(
                  child: Text(
                    "Filter",
                    style: AppFonts.inter20HeaderBlack700,
                  ),
                ),
              ),
              Expanded(
                child: searchCubitWatch.isFilteredRes
                    ? CarsByTypesListview(
                        carsByBrand: searchCubitWatch.filteredCars,
                        isFromFilter: true,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: FilterCars(searchCubitRead: searchCubitRead),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: searchCubitWatch.isFilteredRes
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryRed,
              child: const Icon(
                Icons.clear_rounded,
                color: AppColors.white,
              ),
              onPressed: () {
                searchCubitRead.clearFilterResults();
              },
            )
          : null,
    );
  }
}
