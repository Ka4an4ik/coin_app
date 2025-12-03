import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  const CurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Игумнов Денис Валерьевич ПИбд-32")),
        body: ListView(
          children: const [
            CurrencyCard(
              name: "Доллар",
              imageUrl: "https://cdn.finam.ru/images/publications/1927759/1280_4_6b5e908c23.jpg",
              description: "Курс: 80.5 RUB",
            ),
            CurrencyCard(
              name: "Евро",
              imageUrl: "https://static4.banki.ru/ugc/a4/9c/9b/evrojmabhG.png",
              description: "Курс: 92.3 RUB",
            ),
            CurrencyCard(
              name: "Юань",
              imageUrl: "https://s0.rbk.ru/v6_top_pics/media/img/8/36/756389575987368.jpg",
              description: "Курс: 10.9 RUB",
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;

  const CurrencyCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
