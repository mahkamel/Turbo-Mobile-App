import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';
import 'package:turbo/core/widgets/custom_shimmer.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is GetCitiesLoadingState ||
          current is GetCitiesErrorState ||
          current is GetCitiesSuccessState,
      builder: (context, state) {
        return state is GetCitiesLoadingState
            ? const HeaderShimmerEffect()
            : Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.black),
                    ),
                    child: const Icon(Icons.location_on_outlined),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "yourLocation".getLocale(),
                        style: AppFonts.inter12Grey400,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (previous, current) =>
                            current is ChangeSelectedCityIndexState,
                        builder: (context, state) {
                          return Text(
                            "${context.read<CitiesDistrictsRepository>().cities[context.watch<AuthRepository>().selectedCityIndex].branches[context.watch<AuthRepository>().selectedBranchIndex].branchName}, ${context.read<CitiesDistrictsRepository>().cities[context.watch<AuthRepository>().selectedCityIndex].cityName} ",
                            style: AppFonts.inter16LocationBlue600,
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (bottomSheetContext) =>
                            BlocProvider<HomeCubit>.value(
                          value: context.read<HomeCubit>(),
                          child: const SelectCityBottomSheet(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  )
                ],
              );
      },
    );
  }
}

class SelectCityBottomSheet extends StatelessWidget {
  const SelectCityBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.screenWidth(context),
      height: AppConstants.screenHeight(context) * 0.7,
      constraints: const BoxConstraints(
        maxHeight: 900,
      ),
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 4,
          ),
          Text(
            "Choose City",
            style: AppFonts.inter18HeaderBlack700,
          ),
          const SizedBox(
            height: 4,
          ),
          const Divider(
            height: 12,
            color: AppColors.divider,
          ),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is ChangeSelectedCityIndexState,
              builder: (context, state) {
                var blocRead = context.read<HomeCubit>();
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      showAdaptiveDialog(
                        context: context,
                        builder: (dialogContext) => Dialog(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: AppConstants.screenWidth(context),
                              constraints: BoxConstraints(
                                maxHeight:
                                    AppConstants.screenHeight(context) * 0.7,
                              ),
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Choose Branch",
                                    style: AppFonts.inter18HeaderBlack700,
                                  ),
                                  const Divider(
                                    height: 24,
                                    color: AppColors.divider,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, branchIndex) =>
                                        Center(
                                      child: InkWell(
                                        onTap: () {
                                          blocRead
                                              .changeSelectedCityIndex(index);
                                          blocRead.changeSelectedBranchIndex(
                                              branchIndex);
                                          Navigator.of(dialogContext).pop();
                                          blocRead.getCarsBasedOnBrand();
                                          blocRead.getCarsBrandsByBranchId();
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          child: Text(
                                            context
                                                .read<
                                                    CitiesDistrictsRepository>()
                                                .cities[index]
                                                .branches[branchIndex]
                                                .branchName,
                                            style: AppFonts.inter16Black400
                                                .copyWith(
                                              color: context
                                                              .watch<
                                                                  AuthRepository>()
                                                              .selectedCityIndex ==
                                                          index &&
                                                      context
                                                              .watch<
                                                                  AuthRepository>()
                                                              .selectedBranchIndex ==
                                                          branchIndex
                                                  ? AppColors.primaryRed
                                                  : AppColors.black,
                                              fontWeight: context
                                                              .watch<
                                                                  AuthRepository>()
                                                              .selectedCityIndex ==
                                                          index &&
                                                      context
                                                              .watch<
                                                                  AuthRepository>()
                                                              .selectedBranchIndex ==
                                                          branchIndex
                                                  ? FontWeight.w500
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemCount: context
                                        .read<CitiesDistrictsRepository>()
                                        .cities[index]
                                        .branches
                                        .length,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: AppConstants.screenWidth(context) - 32,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context
                                    .read<CitiesDistrictsRepository>()
                                    .cities[index]
                                    .cityName,
                                style: AppFonts.inter16Black400.copyWith(
                                  fontWeight: context
                                              .watch<AuthRepository>()
                                              .selectedCityIndex ==
                                          index
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                              ),
                              if (context
                                      .watch<AuthRepository>()
                                      .selectedCityIndex ==
                                  index)
                                const Icon(
                                  Icons.check,
                                  color: AppColors.primaryRed,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemCount:
                      context.read<CitiesDistrictsRepository>().cities.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderShimmerEffect extends StatelessWidget {
  const HeaderShimmerEffect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomShimmer(
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.black),
            ),
            child: const Icon(Icons.location_on_outlined),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        CustomShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 12,
                width: 100,
                color: AppColors.grey,
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 12,
                width: 100,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
        const Spacer(),
        const CustomShimmer(
          child: Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ],
    );
  }
}
