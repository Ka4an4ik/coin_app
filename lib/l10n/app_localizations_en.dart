// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Country Search';

  @override
  String get searchHint => 'Enter country name...';

  @override
  String get searchPlaceholder => 'Enter a country name to search';

  @override
  String get noResults => 'No countries found';

  @override
  String get loading => 'Loading...';

  @override
  String get refreshing => 'Refreshing...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get region => 'Region';

  @override
  String get capital => 'Capital';

  @override
  String get population => 'Population';

  @override
  String get languages => 'Languages';

  @override
  String get currencies => 'Currencies';

  @override
  String get countryCode => 'Country Code';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get name => 'Name';

  @override
  String addedToFavorites(String country) {
    return '$country added to favorites';
  }

  @override
  String removedFromFavorites(String country) {
    return '$country removed from favorites';
  }

  @override
  String searchQuery(String query) {
    return 'Query: \"$query\"';
  }

  @override
  String get favorites => 'Favorites';

  @override
  String get search => 'Search';

  @override
  String get noFavorites => 'No favorite countries yet';

  @override
  String get addSomeCountries =>
      'Search for countries and add them to favorites';
}
