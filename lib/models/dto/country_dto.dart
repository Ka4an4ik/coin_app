/// DTO (Data Transfer Object) для страны с API
class CountryDTO {
  final String name;
  final String code;
  final String region;
  final String capital;
  final String flagUrl;
  final int population;
  final List<String> languages;
  final List<String> currencies;

  CountryDTO({
    required this.name,
    required this.code,
    required this.region,
    required this.capital,
    required this.flagUrl,
    required this.population,
    required this.languages,
    required this.currencies,
  });

  /// Factory конструктор для создания DTO из JSON API
  factory CountryDTO.fromJson(Map<String, dynamic> json) {
    // Извлекаем флаг из объекта флагов
    String flagUrl = '';
    if (json['flags'] != null && json['flags'] is Map) {
      flagUrl = json['flags']['svg'] ?? json['flags']['png'] ?? '';
    }

    // Извлекаем языки
    List<String> languages = [];
    if (json['languages'] != null && json['languages'] is Map) {
      languages = (json['languages'] as Map).values.map((e) => e.toString()).toList();
    }

    // Извлекаем валюты
    List<String> currencies = [];
    if (json['currencies'] != null && json['currencies'] is Map) {
      currencies = (json['currencies'] as Map).keys.map((e) => e.toString()).toList();
    }

    return CountryDTO(
      name: json['name']?['common'] ?? json['name'] ?? 'Unknown',
      code: json['cca2'] ?? '',
      region: json['region'] ?? 'Unknown',
      capital: (json['capital'] is List && (json['capital'] as List).isNotEmpty)
          ? json['capital'][0]
          : 'N/A',
      flagUrl: "https://flagsapi.com/" + json['cca2'] + "/flat/64.png",
      population: json['population'] ?? 0,
      languages: languages,
      currencies: currencies,
    );
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'region': region,
        'capital': capital,
        'flagUrl': flagUrl,
        'population': population,
        'languages': languages,
        'currencies': currencies,
      };

  @override
  String toString() =>
      'CountryDTO(name: $name, code: $code, region: $region, capital: $capital)';
}
