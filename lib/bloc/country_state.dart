import 'package:equatable/equatable.dart';
import 'package:coin_app/models/dto/country_dto.dart';

/// Базовый класс для состояний поиска стран
abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class CountryInitial extends CountryState {
  const CountryInitial();
}

/// Состояние загрузки
class CountryLoading extends CountryState {
  const CountryLoading();
}

/// Состояние успешной загрузки данных
class CountryLoaded extends CountryState {
  final List<CountryDTO> countries;
  final String query;

  const CountryLoaded({
    required this.countries,
    this.query = '',
  });

  @override
  List<Object?> get props => [countries, query];
}

/// Состояние ошибки
class CountryError extends CountryState {
  final String message;

  const CountryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Состояние пустых результатов
class CountryEmpty extends CountryState {
  final String query;

  const CountryEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

/// Состояние обновления (refresh) данных
class CountryRefreshing extends CountryState {
  final List<CountryDTO> currentCountries;

  const CountryRefreshing(this.currentCountries);

  @override
  List<Object?> get props => [currentCountries];
}
