import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/services/local/token_service.dart';
import 'package:turbo/presentation/layout/home/widgets/car_brands_list.dart';
import 'package:turbo/presentation/layout/home/widgets/cars_by_brands_list.dart';
import 'package:turbo/presentation/layout/home/widgets/home_header.dart';

import '../../../core/theming/fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: () async {
        var blocRead = context.read<HomeCubit>();
        await UserTokenService.getUserToken();
        if (UserTokenService.currentUserToken.isNotEmpty) {
          blocRead.getNotifications();
          blocRead.refreshCustomerData();
        }
        blocRead.getCities();
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(
            top: 20.0,
            start: 16,
            end: 16,
          ),
          child: HomeHeader(),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 40.0,
            bottom: 8.0,
            start: 16,
          ),
          child: Text(
            "brands".getLocale(context: context),
            style: AppFonts.ibm18HeaderBlue600,
          ),
        ),
        const BrandsList(),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 26,
            bottom: 14,
            start: 16,
          ),
          child: Text(
            "recommendedCars".getLocale(context: context),
            style: AppFonts.ibm18HeaderBlue600,
          ),
        ),
        const CarsByBrandsList(),
      ],
    );
  }
}
