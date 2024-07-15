import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Locale;

import '../../../core/services/local/cache_helper.dart';
part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(SelectedLocalization(const Locale('en', 'US')));

  void toArabic() async {
    setLocale('ar_SA');
    emit(SelectedLocalization(const Locale('ar', 'SA')));
  }

  void toEnglish() async {
    setLocale('en_US');
    emit(SelectedLocalization(const Locale('en', 'US')));
  }

  void onInit() async {
    String localeVal = await getLocale();
    emit(SelectedLocalization(Locale(localeVal)));
  }

  Future<String> getLocale() async {
    return await CacheHelper.getData(key: 'locale') ?? 'en_US';
  }

  Future<void> setLocale(String locale) async {
    CacheHelper.setData(key: 'locale', value: locale);
  }
}
