import 'package:flutter/material.dart';

/// Провайдер для управления локалью приложения
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'ru') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('ru'));
    }
  }
}
