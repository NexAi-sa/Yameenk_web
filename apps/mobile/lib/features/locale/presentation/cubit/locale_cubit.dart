library;

import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const _kLocaleKey = 'app_locale';

  LocaleCubit() : super(const LocaleState(Locale('ar'))) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code != null) emit(LocaleState(Locale(code)));
  }

  Future<void> toggleLocale() async {
    final next = state.locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    emit(LocaleState(next));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, next.languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    emit(LocaleState(locale));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }
}
