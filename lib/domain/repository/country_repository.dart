import 'package:coin_app/models/dto/country_dto.dart';

/// Интерфейс репозитория для работы со странами
abstract class CountryRepository {
  /// Поиск стран по названию
  Future<List<CountryDTO>> searchCountries(String query);

  /// Получить все страны
  Future<List<CountryDTO>> getAllCountries();

  /// Получить страну по коду
  Future<CountryDTO?> getCountryByCode(String code);
}
