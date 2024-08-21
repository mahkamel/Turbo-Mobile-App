import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/helpers/dropdown_keys.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/default_buttons.dart';
import '../delete_icon.dart';

class SelectedCarYearsFilter extends StatelessWidget {
  const SelectedCarYearsFilter({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) =>
      current is YearSelectionState ||
          current is FilterResetState,
      builder: (context, state) {
        var searchCubitWatch = context.watch<SearchCubit>();
        return Padding(
          padding: EdgeInsets.only(
            top: searchCubitWatch.selectedCarYears.isNotEmpty
                ? 4.0
                : 0.0,
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              searchCubitWatch.selectedCarYears.length,
                  (index) => InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  if (priceRangeKey.currentState != null) {
                    if (priceRangeKey.currentState!.isOpen) {
                      priceRangeKey.currentState!.closeBottomSheet();
                    }
                  }
                  searchCubitRead.unSelectCarYear(
                    searchCubitWatch.selectedCarYears
                        .elementAt(index),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 60,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 55,
                          height: 40,
                          // padding:const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.greyBorder)),
                          child: Center(
                            child: Text(searchCubitWatch
                                .selectedCarYears
                                .elementAt(index)),
                          ),
                        ),
                      ),
                      const DeleteIcon(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CarYearFilterHeader extends StatelessWidget {
  const CarYearFilterHeader({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Car Year",
          style: AppFonts.inter18HeaderBlack700,
        ),
        DefaultButton(
          height: 30,
          width: 72,
          text: "Choose",
          fontSize: 12,
          fontWeight: FontWeight.w700,
          function: () {
            if (priceRangeKey.currentState != null) {
              if (priceRangeKey.currentState!.isOpen) {
                priceRangeKey.currentState!.closeBottomSheet();
              }
            }
            showDialog(
              context: context,
              builder: (BuildContext context) {
                DateTime selectedDate = DateTime.now();
                return AlertDialog(
                  title: const Text("Manufacturing year"),
                  content: SizedBox(
                    width: 300,
                    height: 300,
                    child: YearPicker(
                      firstDate:
                      DateTime(DateTime.now().year - 100, 1),
                      lastDate: DateTime.now(),
                      selectedDate: selectedDate,
                      onChanged: (DateTime dateTime) {
                        searchCubitRead.carYearsSelection(
                          dateTime.year.toString(),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            );
          },
          textColor: AppColors.primaryBlue,
          border: Border.all(color: AppColors.primaryBlue),
          color: AppColors.white,
        ),
      ],
    );
  }
}
