part of 'localization_cubit.dart';

abstract class LocalizationState {
  final Locale locale;
  LocalizationState(this.locale);
}

class SelectedLocalization extends LocalizationState {
  SelectedLocalization(Locale locale) : super(locale);
}
