import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turbo/blocs/orders/order_cubit.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/blocs/search/search_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/presentation/layout/profile/screens/profile_screen.dart';
import 'package:turbo/presentation/layout/search/search_screen.dart';

import '../../blocs/home/home_cubit.dart';
import '../../blocs/layout/layout_cubit.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/helpers/constants.dart';
import '../../core/theming/colors.dart';
import '../../core/theming/fonts.dart';
import 'home/home_screen.dart';
import 'orders/orders_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      BlocProvider<HomeCubit>(
        create: (context) => getIt<HomeCubit>()..onInit(),
        child: const HomeScreen(),
      ),
      BlocProvider<SearchCubit>(
        create: (context) => getIt<SearchCubit>()
          ..unSelectAllBrands()
          ..init(),
        child: const SearchScreen(),
      ),
      BlocProvider(
        create: (context) => getIt<OrderCubit>()..getAllCustomerRequests(),
        child: const OrdersScreen(),
      ),
      BlocProvider<ProfileCubit>.value(
        value: getIt<ProfileCubit>(),
        child: const ProfileScreen(),
      ),
    ];
    return Scaffold(
      body: SizedBox(
        width: AppConstants.screenWidth(context),
        height: AppConstants.screenHeight(context),
        child: SafeArea(
          child: BlocBuilder<LayoutCubit, LayoutState>(
            builder: (context, state) {
              return screens[context.watch<LayoutCubit>().navBarIndex];
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<LayoutCubit, LayoutState>(
        buildWhen: (previous, current) => current is ChangeNavBarIndexState,
        builder: (context, state) {
          return const BottomNavBar();
        },
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 87 : 72,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 2),
              color: AppColors.black.withOpacity(0.15)),
          BoxShadow(
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, 1),
              color: AppColors.black.withOpacity(0.30))
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.divider,
          selectedLabelStyle: AppFonts.ibm12Primary400.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppFonts.ibm12Primary400.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.divider,
          ),
          currentIndex: context.watch<LayoutCubit>().navBarIndex,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            context.read<LayoutCubit>().changeNavBarIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                context.watch<LayoutCubit>().navBarIndex == 0
                    ? "assets/images/icons/nav_bar_icons/selected_explore.svg"
                    : "assets/images/icons/nav_bar_icons/unSelected_explore.svg",
              ),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                context.watch<LayoutCubit>().navBarIndex == 1
                    ? "assets/images/icons/nav_bar_icons/selected_search.svg"
                    : "assets/images/icons/nav_bar_icons/unSelected_Search.svg",
              ),
              label: 'search'.getLocale(context: context),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                context.watch<LayoutCubit>().navBarIndex == 2
                    ? "assets/images/icons/nav_bar_icons/selected_orders.svg"
                    : "assets/images/icons/nav_bar_icons/unSelected_orders.svg",
              ),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                context.watch<LayoutCubit>().navBarIndex == 3
                    ? "assets/images/icons/nav_bar_icons/selected_profile.svg"
                    : "assets/images/icons/nav_bar_icons/unSelected_profile.svg",
              ),
              label: 'profile'.getLocale(context: context),
            ),
          ],
        ),
      ),
    );
  }
}
