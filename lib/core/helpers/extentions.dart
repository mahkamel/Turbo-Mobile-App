import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart';

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }

  String removeWhiteSpaces() {
    return replaceAll(RegExp(r'\s+'), '');
  }
}

extension ContextExtention on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this)!;
  }
}

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments,}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate,}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

extension ResponsiveText on double {
  double sp(BuildContext context) {
    double calculatedSize =
        (this / 720) * AppConstants.screenSize(context).height;
    if (AppConstants.screenSize(context).height < 600) {
      return calculatedSize.clamp(this - 4, this);
    } else if (AppConstants.screenSize(context).height > 1080) {
      return calculatedSize.clamp(this, this + 2);
    } else {
      double calculatedSize =
          (this / 720) * AppConstants.screenSize(context).height;
      return calculatedSize.clamp(this - 2, this);
    }
  }
}
