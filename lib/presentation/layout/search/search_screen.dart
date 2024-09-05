import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:turbo/blocs/search/search_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/presentation/layout/search/widgets/filter.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/filter_header.dart';
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
              const FilterHeader(),
              if (searchCubitWatch.isGettingFilterResults)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Lottie.asset(
                      "assets/lottie/luxury_car_loading.json",
                      height: AppConstants.screenWidth(context) * .6,
                      width: (AppConstants.screenWidth(context) * .6),
                    ),
                  ),
                ),
              if (!searchCubitWatch.isGettingFilterResults)
                Expanded(
                  child: SingleChildScrollView(
                    child: searchCubitWatch.isFilteredRes
                        ? searchCubitWatch.filteredCars.isEmpty
                            ? SizedBox(
                                width: AppConstants.screenWidth(context),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        SizedBox(height: AppConstants.screenWidth(context) * .15,),
                                     Lottie.asset(
                                        "assets/lottie/no_result.json",
                                         height: AppConstants.screenWidth(context) * .6,
                                        width: (AppConstants.screenWidth(context) * .8),
                                      ),
                                      const SizedBox(height: 20,),
                                      Text(
                                        "No results found! Try another search properties.",
                                        style:
                                            AppFonts.ibm24HeaderBlue600.copyWith(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : CarsByTypesListview(
                                carsByBrand: searchCubitWatch.filteredCars,
                                isFromFilter: true,
                              )
                        : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: FilterCars(),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: searchCubitWatch.isFilteredRes
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryBlue,
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
