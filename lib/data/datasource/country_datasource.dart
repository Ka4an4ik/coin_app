import 'package:coin_app/models/dto/country_dto.dart';

/// Интерфейс для источника данных о странах
abstract class CountryDataSource {
  /// Получить страны по поисковому запросу
  Future<List<CountryDTO>> searchCountries(String query);

  /// Получить все страны
  Future<List<CountryDTO>> getAllCountries();

  /// Получить страну по коду
  Future<CountryDTO?> getCountryByCode(String code);
}
