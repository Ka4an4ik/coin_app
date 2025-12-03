// Enum для типа валюты
enum CurrencyType { usd, eur, rub, cny }

// Класс
class Currency {
  final String name;
  final CurrencyType type;
  double rateToRub;

  Currency(this.name, this.type, this.rateToRub);

  void updateRate(double newRate) {
    rateToRub = newRate;
  }

  void printInfo() {
    print("$name (${type.name.toUpperCase()}): $rateToRub RUB");
  }
}

// Extension
extension CurrencyExtension on Currency {
  bool get isStrong => rateToRub > 80;
}

// Future имитация загрузки
Future<List<Currency>> fetchCurrencies() async {
  print("Загрузка курса валют");
  await Future.delayed(const Duration(seconds: 2));
  return [
    Currency("Доллар", CurrencyType.usd, 80.5),
    Currency("Евро", CurrencyType.eur, 92.3),
    Currency("Юань", CurrencyType.cny, 10.9),
  ];
}

Future<void> main() async {
  // Generics + List
  List<Currency> currencies = await fetchCurrencies();

  // Loops
  for (var c in currencies) {
    c.printInfo();
  }

  // Anonymous function
  var strong = currencies.where((c) => c.isStrong).toList();
  print("Сильные валюты: ${strong.map((c) => c.name).join(", ")}");
}
