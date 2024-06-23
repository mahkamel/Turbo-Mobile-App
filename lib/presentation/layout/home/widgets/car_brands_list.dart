import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/flavors.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class BrandsList extends StatelessWidget {
  const BrandsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            current is GetCarsBrandsLoadingState ||
            current is GetCarsBrandsErrorState ||
            current is GetCarsBrandsSuccessState,
        builder: (context, state) {
          var blocWatch = context.watch<HomeCubit>();
          var blocRead = context.read<HomeCubit>();
          return state is GetCarsBrandsLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : blocWatch.carBrands.isEmpty
                  ? const SizedBox()
                  : Expanded(
                      child: AllBrandsListView(
                        blocWatch: blocWatch,
                        blocRead: blocRead,
                      ),
                    );
        },
      ),
    );
  }
}

class AllBrandsListView extends StatelessWidget {
  const AllBrandsListView({
    super.key,
    required this.blocWatch,
    required this.blocRead,
  });

  final HomeCubit blocWatch;
  final HomeCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
      ),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => InkWell(
        highlightColor: Colors.transparent,
        onTap: () {
          if (blocWatch.selectedBrandIndex != (index)) {
            blocRead.changeSelectedBrandIndex(index);
            blocRead.getCarsBasedOnBrand(
              brandId: blocRead.carBrands[index].id,
            );
          } else {
            blocRead.changeSelectedBrandIndex(-1);
            blocRead.getCarsBasedOnBrand();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: blocWatch.selectedBrandIndex == index
                      ? AppColors.headerBlack
                      : AppColors.headerBlack.withOpacity(0.1),
                ),
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl:
                      "${FlavorConfig.instance.filesBaseUrl}${blocRead.carBrands[index].path}",
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const SizedBox(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                blocRead.carBrands[index].brandName,
                style: AppFonts.sfPro14Black400.copyWith(
                  fontWeight: blocWatch.selectedBrandIndex == index
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        width: 16,
      ),
      itemCount: blocWatch.carBrands.length,
    );
  }
}
