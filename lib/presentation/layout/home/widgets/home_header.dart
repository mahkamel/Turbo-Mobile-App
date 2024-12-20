import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';
import 'package:turbo/core/widgets/custom_shimmer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:turbo/main_paths.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../notifications_screens/notifications_screen.dart';

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
          current is GetCitiesSuccessState ||
          current is GetNotificationsLoadingState ||
          current is GetNotificationsErrorState ||
          current is GetNotificationsSuccessState,
      builder: (context, state) {
        var blocWatch = context.watch<HomeCubit>();
        return state is GetCitiesLoadingState ||
                state is GetNotificationsLoadingState
            ? const HeaderShimmerEffect()
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.asset("assets/images/logoWhite.png"),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        context.read<HomeCubit>().toggleBranchSelector(-1);
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "yourLocation".getLocale(context: context),
                            style: AppFonts.ibm14LightBlack400,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          BlocBuilder<HomeCubit, HomeState>(
                            buildWhen: (previous, current) =>
                                current is ChangeSelectedCityIndexState ||
                                current is GetCitiesSuccessState ||
                                current is ChangeSelectedBranchIndexState,
                            builder: (context, state) {
                              if (context
                                  .watch<CitiesDistrictsRepository>()
                                  .cities
                                  .isNotEmpty) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on_sharp,
                                      color: AppColors.grey400,
                                      size: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        context.read<CitiesDistrictsRepository>().cities[context.watch<AuthRepository>().selectedCityIndex].branches[context.watch<AuthRepository>().selectedBranchIndex].branchName,
                                        style: AppFonts.ibm14SubTextGold600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 10,),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        current is GetNotificationsSuccessState,
                    builder: (context, state) {
                      var numOfNotifications = blocWatch.notifications
                          .where(
                            (element) => element.isNotificationSeen == false,
                          )
                          .toList()
                          .length;
                      return context
                              .watch<AuthRepository>()
                              .customer
                              .token
                              .isNotEmpty
                          ? InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (navigateContext) =>
                                      BlocProvider<HomeCubit>.value(
                                    value: context.read<HomeCubit>()
                                      ..getNotifications(
                                          isFromNotificationScreen: true),
                                    child: const NotificationsScreen(),
                                  ),
                                ));
                              },
                              child: Container(
                                height: 47,
                                width: 47,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 2),
                                          color:
                                              AppColors.black.withOpacity(0.15))
                                    ]),
                                child: badges.Badge(
                                  showBadge: numOfNotifications != 0,
                                  badgeStyle: const badges.BadgeStyle(
                                    badgeColor: AppColors.primaryBlue,
                                  ),
                                  position:
                                      badges.BadgePosition.topEnd(end: -8),
                                  badgeContent: Text(
                                    "$numOfNotifications",
                                    style: const TextStyle(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  child: const Center(
                                      child: Icon(
                                    Icons.notifications,
                                    color: AppColors.secondary,
                                    size: 24,
                                  )),
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
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
          Row(
            children: [
              const Icon(Icons.location_city_rounded, color: AppColors.secondary),
              const SizedBox(
                width: 4,
              ),
              Text(
                "Choose City",
                style: AppFonts.ibm18HeaderBlue600,
              ),
            ],
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
                  current is ChangeSelectedCityIndexState ||
                  current is ToggleBranchState,
              builder: (context, state) {
                var blocRead = context.read<HomeCubit>();
                var blocWatch = context.watch<HomeCubit>();

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () => blocRead.toggleBranchSelector(index),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: AppConstants.screenWidth(context) - 32,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      context
                                          .read<CitiesDistrictsRepository>()
                                          .cities[index]
                                          .cityName,
                                      style: (blocWatch.tempSelectedCityIndex ==
                                                  -1
                                              ? context
                                                      .watch<AuthRepository>()
                                                      .selectedCityIndex ==
                                                  index
                                              : blocWatch
                                                      .tempSelectedCityIndex ==
                                                  index)
                                          ? AppFonts.ibm16Gold600
                                          : AppFonts.ibm16LightBlack600),
                                  AnimatedRotation(
                                    turns:
                                        blocWatch.tempSelectedCityIndex == index
                                            ? 0.25
                                            : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: AppColors.primaryBlue,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: blocWatch.tempSelectedCityIndex == index
                            ? context
                                    .read<CitiesDistrictsRepository>()
                                    .cities[index]
                                    .branches
                                    .length *
                                35
                            : 0,
                        child: blocWatch.tempSelectedCityIndex == index
                            ? ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                itemBuilder: (context, branchIndex) => Center(
                                  child: InkWell(
                                    onTap: () {
                                      blocRead.changeSelectedCityIndex(index);
                                      blocRead.changeSelectedBranchIndex(
                                          branchIndex);
                                      blocRead.getCarsBasedOnBrand();
                                      blocRead.getCarsBrandsByBranchId();
                                    },
                                    child: SizedBox(
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              context
                                                  .read<
                                                      CitiesDistrictsRepository>()
                                                  .cities[index]
                                                  .branches[branchIndex]
                                                  .branchName,
                                              style: context
                                                              .watch<
                                                                  AuthRepository>()
                                                              .selectedCityIndex ==
                                                          index &&
                                                      context
                                                              .watch<
                                                                  AuthRepository>()
                                                              .selectedBranchIndex ==
                                                          branchIndex
                                                  ? AppFonts
                                                      .ibm16PrimaryBlue400
                                                  : AppFonts.ibm16Grey400),
                                          if (context
                                                      .watch<AuthRepository>()
                                                      .selectedCityIndex ==
                                                  index &&
                                              context
                                                      .watch<AuthRepository>()
                                                      .selectedBranchIndex ==
                                                  branchIndex)
                                            const Icon(
                                              Icons.check,
                                              color: AppColors.primaryBlue,
                                              size: 18,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                itemCount: context
                                    .read<CitiesDistrictsRepository>()
                                    .cities[index]
                                    .branches
                                    .length,
                              )
                            : null,
                      ),
                    ],
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
        if (context.watch<AuthRepository>().customer.token.isNotEmpty)
          const CustomShimmer(
            child: Icon(Icons.notifications_none_rounded),
          ),
      ],
    );
  }
}
