import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coin_app/data/datasource/country_datasource.dart';
import 'package:coin_app/models/dto/country_dto.dart';

/// Реализация источника данных, которая работает с REST API
class CountryRemoteDataSource implements CountryDataSource {
  static const String _baseUrl = 'https://restcountries.com/v3.1';
  final http.Client _httpClient;

  CountryRemoteDataSource({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<CountryDTO>> searchCountries(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/name/$query'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => CountryDTO.fromJson(json))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching countries: $e');
    }
  }

  @override
  Future<List<CountryDTO>> getAllCountries() async {
    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/all?fields=name'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => CountryDTO.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading all countries: $e');
    }
  }

  @override
  Future<CountryDTO?> getCountryByCode(String code) async {
    if (code.isEmpty) {
      return null;
    }

    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/alpha/$code'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CountryDTO.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load country: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading country by code: $e');
    }
  }
}
