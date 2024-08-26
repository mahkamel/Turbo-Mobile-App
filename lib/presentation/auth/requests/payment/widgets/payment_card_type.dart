import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/payment/payment_cubit.dart';

import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';

class PaymentCardTypeRow extends StatelessWidget {
  const PaymentCardTypeRow({
    super.key,
    required this.isSelected,
    required this.type,
    required this.index,
  });

  final bool isSelected;
  final String type;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PaymentCubit>().changeCardTypeToggleValue(index);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsetsDirectional.only(end: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.black),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.black : AppColors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Text(
            type,
            style: AppFonts.ibm16LightBlack600,
          ),
        ],
      ),
    );
  }
}
