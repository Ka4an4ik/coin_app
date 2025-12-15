// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Поиск стран';

  @override
  String get searchHint => 'Введите название страны...';

  @override
  String get searchPlaceholder => 'Введите название страны для поиска';

  @override
  String get noResults => 'Страны не найдены';

  @override
  String get loading => 'Загрузка...';

  @override
  String get refreshing => 'Обновление...';

  @override
  String get error => 'Ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get region => 'Регион';

  @override
  String get capital => 'Столица';

  @override
  String get population => 'Население';

  @override
  String get languages => 'Языки';

  @override
  String get currencies => 'Валюты';

  @override
  String get countryCode => 'Код страны';

  @override
  String get basicInfo => 'Основная информация';

  @override
  String get name => 'Название';

  @override
  String addedToFavorites(String country) {
    return '$country добавлена в избранное';
  }

  @override
  String removedFromFavorites(String country) {
    return '$country удалена из избранного';
  }

  @override
  String searchQuery(String query) {
    return 'Запрос: \"$query\"';
  }

  @override
  String get favorites => 'Избранное';

  @override
  String get search => 'Поиск';

  @override
  String get noFavorites => 'Нет избранных стран';

  @override
  String get addSomeCountries => 'Найдите страны и добавьте их в избранное';
}
