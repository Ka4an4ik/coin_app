import 'package:equatable/equatable.dart';

/// Базовый класс для событий поиска стран
abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для поиска стран по запросу
class SearchCountries extends CountryEvent {
  final String query;

  const SearchCountries(this.query);

  @override
  List<Object?> get props => [query];
}

/// Событие для обновления списка стран (refresh)
class RefreshCountries extends CountryEvent {
  const RefreshCountries();
}

/// Событие для очистки результатов поиска
class ClearSearch extends CountryEvent {
  const ClearSearch();
}

/// Событие для загрузки всех стран
class LoadAllCountries extends CountryEvent {
  const LoadAllCountries();
}
