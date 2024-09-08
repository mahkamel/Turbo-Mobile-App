import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/main_paths.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth(context),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20.0,
            top: 5,
          ),
          child: SizedBox(
            height: 38,
            width: 160,
            child: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.forgetPasswordScreen,
                  arguments: context.read<LoginCubit>()
                );
              },
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "forgetPassword".getLocale(context: context),
                  style: AppFonts.ibm14Primary600.copyWith(color: AppColors.grey400),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
