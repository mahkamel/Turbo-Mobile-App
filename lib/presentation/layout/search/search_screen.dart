import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
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
              if (searchCubitWatch.isGettingFilterResults)
                Center(
                  child: Lottie.asset(
                    "assets/lottie/car_loading.json",
                    height: AppConstants.screenWidth(context) * .8,
                    width: (AppConstants.screenWidth(context) * .8) + 50,
                  ),
                ),
              if (!searchCubitWatch.isGettingFilterResults)
                Expanded(
                  child: searchCubitWatch.isFilteredRes
                      ? searchCubitWatch.filteredCars.isEmpty
                          ? SizedBox(
                              width: AppConstants.screenWidth(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/icons/no_results_founded.svg",
                                    height: AppConstants.screenHeight(context) *
                                        0.4,
                                  ),
                                  Text(
                                    "We couldn't find anything matching your search.",
                                    style:
                                        AppFonts.inter14HeaderBlack400.copyWith(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                          : CarsByTypesListview(
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
