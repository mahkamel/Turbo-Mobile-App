import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/constants.dart';

import '../../../core/theming/colors.dart';

class CardDetailsScreen extends StatelessWidget {
  const CardDetailsScreen({
    super.key,
    required this.carId,
    required this.carImage,
  });

  final String carId;
  final String carImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300.0,
                    floating: true,
                    elevation: 0,
                    forceMaterialTransparency: true,

                    automaticallyImplyLeading: false,
                    // pinned: true,
                    // leading: CloseButton(),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Hero(
                          tag: carId,
                          child: Container(
                            width: AppConstants.screenWidth(context),
                            decoration: BoxDecoration(
                              color: AppColors.black800,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                      childCount: 50,
                    ),
                  ),
                ],
              ),
              Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsetsDirectional.only(
                    top: 20,
                    start: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const BackButton(
                    color: AppColors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
