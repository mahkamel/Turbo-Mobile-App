import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../blocs/home/home_cubit.dart';
import '../../blocs/layout/layout_cubit.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/helpers/constants.dart';
import '../../core/theming/colors.dart';
import '../../core/theming/fonts.dart';
import 'home/home_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      BlocProvider<HomeCubit>(
        create: (context) => getIt<HomeCubit>()..getCurrentUserLocation(),
        child: const HomeScreen(),
      ),
      const HomeScreen(),
      const HomeScreen(),
      const HomeScreen(),
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
          return SizedBox(
            height: Platform.isIOS ? 87 : 72,
            child: BottomNavigationBar(
              backgroundColor: AppColors.navBarBlack,
              selectedItemColor: AppColors.white,
              unselectedItemColor: AppColors.navBarUnSelected,
              selectedLabelStyle: AppFonts.sfPro12Black400.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              unselectedLabelStyle: AppFonts.sfPro12Black400,
              currentIndex: context.watch<LayoutCubit>().navBarIndex,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                context.read<LayoutCubit>().changeNavBarIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/icons/nav_bar_icons/home_nav_icon.svg",
                    colorFilter: ColorFilter.mode(
                      context.watch<LayoutCubit>().navBarIndex == 0
                          ? AppColors.white
                          : AppColors.subTextGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/icons/nav_bar_icons/home_nav_icon.svg",
                    colorFilter: ColorFilter.mode(
                      context.watch<LayoutCubit>().navBarIndex == 1
                          ? AppColors.white
                          : AppColors.subTextGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Bills',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/icons/nav_bar_icons/home_nav_icon.svg",
                    colorFilter: ColorFilter.mode(
                      context.watch<LayoutCubit>().navBarIndex == 2
                          ? AppColors.white
                          : AppColors.subTextGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Support',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/icons/nav_bar_icons/home_nav_icon.svg",
                    colorFilter: ColorFilter.mode(
                      context.watch<LayoutCubit>().navBarIndex == 3
                          ? AppColors.white
                          : AppColors.subTextGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'More',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
