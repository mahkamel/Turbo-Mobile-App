import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/helpers/dropdown_keys.dart';
import '../../../../../core/services/networking/repositories/car_repository.dart';
import '../../../home/widgets/car_brands_list.dart';

class CarBrandsFilter extends StatelessWidget {
  const CarBrandsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        if (priceRangeKey.currentState != null) {
          if (priceRangeKey.currentState!.isOpen) {
            priceRangeKey.currentState!.closeBottomSheet();
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 22.0,
        ),
        child: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (previous, current) =>
              current is GetSearchCarsBrandsErrorState ||
              current is GetSearchCarsBrandsLoadingState ||
              current is GetSearchCarsBrandsSuccessState ||
              current is BrandsSelectionState ||
              current is BrandsSearchState,
          builder: (context, state) {
            var searchCubitWatch = context.watch<SearchCubit>();
            print("aaaaaaaaaaaa ${context
                              .read<CarRepository>()
                              .carBrands}");
            return state is GetSearchCarsBrandsLoadingState ? const Center(child: CircularProgressIndicator(),):
            SizedBox(
              height: 82,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => InkWell(
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (priceRangeKey.currentState != null) {
                        if (priceRangeKey.currentState!.isOpen) {
                          priceRangeKey.currentState!.closeBottomSheet();
                        }
                      }
                      searchCubitRead.onSelectAndDisSelectBrands(context
                              .read<CarRepository>()
                              .carBrands[index]);
                  },
                  child: 
                   BrandLogoCircle(
                      size:65,
                      isFromFilter: true,
                      logoPath: context
                              .read<CarRepository>()
                              .carBrands[index]
                              .path,
                      brandName: context
                              .read<CarRepository>()
                              .carBrands[index]
                              .brandName,
                      isSelected: context
                                .watch<CarRepository>()
                                .carBrands[index].isSelected,
                    ),
                    
                    
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemCount: searchCubitWatch
                      .brandSearchController.text.isNotEmpty
                  ? searchCubitWatch.searchedBrands.length
                  : context.watch<CarRepository>().carBrands.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
