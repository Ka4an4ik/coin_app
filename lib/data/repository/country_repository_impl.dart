import 'package:coin_app/data/datasource/country_datasource.dart';
import 'package:coin_app/domain/repository/country_repository.dart';
import 'package:coin_app/models/dto/country_dto.dart';

/// Реализация репозитория для работы со странами
class CountryRepositoryImpl implements CountryRepository {
  final CountryDataSource _dataSource;

  CountryRepositoryImpl({required CountryDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<CountryDTO>> searchCountries(String query) async {
    return await _dataSource.searchCountries(query);
  }

  @override
  Future<List<CountryDTO>> getAllCountries() async {
    return await _dataSource.getAllCountries();
  }

  @override
  Future<CountryDTO?> getCountryByCode(String code) async {
    return await _dataSource.getCountryByCode(code);
  }
}
