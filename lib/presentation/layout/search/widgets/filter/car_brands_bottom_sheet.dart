import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/search/search_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/widgets/custom_text_fields.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/car_brand_circle.dart';

import '../../../../../core/helpers/constants.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';

class CarBrandsBottomSheet extends StatelessWidget {
  const CarBrandsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return Container(
      width: AppConstants.screenWidth(context),
      height: AppConstants.screenHeight(context) * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      constraints: const BoxConstraints(
        maxHeight: 900,
      ),
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        top: 16,
        bottom: 16,
        end: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Car brands",
            style: AppFonts.ibm18HeaderBlue600,
          ),
          CustomTextField(
            marginTop: 12,
            marginBottom: 12,
            marginRight: 12,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.black,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            prefixIcon: const Padding(
              padding: EdgeInsetsDirectional.only(start: 12.0),
              child: Icon(
                Icons.search_rounded,
              ),
            ),
            hint: "Type Car brand name",
            validationState: TextFieldValidation.valid,
            textEditingController: searchCubitRead.brandSearchController,
            onSubmit: (value) {
              searchCubitRead.onBrandsSearchedValueChanged();
            },
            onTapOutside: (onTapOutside) {
              searchCubitRead.onBrandsSearchedValueChanged();
            },
            onChange: (value) {
              searchCubitRead.onBrandsSearchedValueChanged();
            },
          ),
          BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (previous, current) =>
                current is GetSearchCarsBrandsErrorState ||
                current is GetSearchCarsBrandsLoadingState ||
                current is GetSearchCarsBrandsSuccessState ||
                current is BrandsSelectionState ||
                current is BrandsSearchState,
            builder: (context, state) {
              var searchCubitWatch = context.watch<SearchCubit>();

              return state is GetSearchCarsBrandsLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 42,
                            width: AppConstants.screenWidth(context),
                            child: Row(
                              children: [
                                CarBrandCircle(
                                  logoPath: searchCubitWatch
                                          .brandSearchController.text.isNotEmpty
                                      ? searchCubitRead
                                          .searchedBrands[index].path
                                      : context
                                          .read<CarRepository>()
                                          .carBrands[index]
                                          .path,

                                  isSelected: context
                              .watch<CarRepository>()
                              .carBrands[index].isSelected,
                                ),
                                horizontalGap(12),
                                Text(
                                  searchCubitWatch
                                          .brandSearchController.text.isNotEmpty
                                      ? searchCubitRead
                                          .searchedBrands[index].display
                                      : context
                                          .read<CarRepository>()
                                          .carBrands[index]
                                          .display,
                                  style: AppFonts.ibm14LightBlack400,
                                ),
                                const Spacer(),
                                Checkbox(
                                  visualDensity: VisualDensity.standard,
                                  value: searchCubitWatch
                                          .brandSearchController.text.isNotEmpty
                                      ? searchCubitRead
                                          .searchedBrands[index].isSelected
                                      : context
                                          .read<CarRepository>()
                                          .carBrands[index]
                                          .isSelected,
                                  onChanged: (value) {
                                    searchCubitRead.onSelectAndDisSelectBrands(
                                        searchCubitWatch.brandSearchController
                                                .text.isNotEmpty
                                            ? searchCubitRead
                                                .searchedBrands[index]
                                            : context
                                                .read<CarRepository>()
                                                .carBrands[index]);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: searchCubitWatch
                                .brandSearchController.text.isNotEmpty
                            ? searchCubitWatch.searchedBrands.length
                            : context.watch<CarRepository>().carBrands.length,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}