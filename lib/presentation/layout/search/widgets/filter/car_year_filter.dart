import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/search/search_cubit.dart';
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
          current is YearSelectionState || current is FilterResetState,
      builder: (context, state) {
        var searchCubitWatch = context.watch<SearchCubit>();
        return Padding(
          padding: EdgeInsets.only(
            top: searchCubitWatch.selectedCarYears.isNotEmpty ? 10.0 : 0.0,
          ),
          child: Container(
            padding: searchCubitWatch.selectedCarYears.isNotEmpty
                ? const EdgeInsets.all(12)
                : null,
            decoration: BoxDecoration(
                border: searchCubitWatch.selectedCarYears.isNotEmpty
                    ? Border.all(color: AppColors.subTextGrey)
                    : null,
                borderRadius: BorderRadius.circular(20)),
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              children: List.generate(
                searchCubitWatch.selectedCarYears.length,
                (index) => InkWell(
                  highlightColor: Colors.transparent,
                  onTap: () {
                    searchCubitRead.unSelectCarYear(
                      searchCubitWatch.selectedCarYears.elementAt(index),
                    );
                  },
                  child: SizedBox(
                    height: 42,
                    width: 74,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 79,
                            height: 37,
                            padding: const EdgeInsets.only(
                                left: 10, top: 5, right: 10, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.darkGreen)),
                            child: Center(
                              child: Text(
                                searchCubitWatch.selectedCarYears
                                    .elementAt(index)
                                    .toString(),
                                style: AppFonts.ibm18White600
                                    .copyWith(color: AppColors.darkGreen),
                              ),
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
          style:
              AppFonts.ibm18HeaderBlue600.copyWith(color: AppColors.lightBlack),
        ),
        DefaultButton(
          height: 30,
          width: 72,
          text: "Choose",
          fontSize: 12,
          fontWeight: FontWeight.w700,
          function: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                DateTime selectedDate = DateTime.now();
                return AlertDialog(
                  title: Text(
                    "Manufacturing year",
                    style: AppFonts.ibm24HeaderBlue600
                        .copyWith(color: AppColors.lightBlack),
                  ),
                  content: SizedBox(
                    width: 350,
                    height: 300,
                    child: DatePickerTheme(
                      data: DatePickerThemeData(
                        yearBackgroundColor:
                            WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.green;
                          }
                          return Colors.transparent;
                        }),
                        todayBorder: const BorderSide(color: AppColors.green),
                        todayForegroundColor:
                            WidgetStateColor.resolveWith((states) {
                          return AppColors.green;
                        }),
                        todayBackgroundColor:
                            WidgetStateColor.resolveWith((states) {
                          return Colors.transparent;
                        }),
                        yearForegroundColor:
                            WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.white;
                          }
                          return Colors.black;
                        }),
                      ),
                      child: YearPicker(
                        firstDate: DateTime(DateTime.now().year - 100, 1),
                        lastDate: DateTime.now(),
                        selectedDate: selectedDate,
                        onChanged: (DateTime dateTime) {
                          searchCubitRead.carYearsSelection(
                            dateTime.year,
                          );
                          Navigator.pop(dialogContext);
                        },
                      ),
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
