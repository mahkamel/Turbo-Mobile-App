import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/services/networking/repositories/car_repository.dart';
import '../../../home/widgets/car_brands_list.dart';

class CarBrandsFilter extends StatelessWidget {
  const CarBrandsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return BlocBuilder<SearchCubit, SearchState>(
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
            : SizedBox(
                height: 122,
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 30, left: 20, right: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      searchCubitRead.onSelectAndDisSelectBrands(
                          context.read<CarRepository>().carBrands[index]);
                    },
                    child: BrandLogoCircle(
                      size: 65,
                      isFromFilter: true,
                      logoPath:
                          context.read<CarRepository>().carBrands[index].path,
                      brandName: context
                          .read<CarRepository>()
                          .carBrands[index]
                          .brandName,
                      isSelected: context
                          .watch<CarRepository>()
                          .carBrands[index]
                          .isSelected,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemCount:
                      searchCubitWatch.brandSearchController.text.isNotEmpty
                          ? searchCubitWatch.searchedBrands.length
                          : context.watch<CarRepository>().carBrands.length,
                ),
              );
      },
    );
  }
}
