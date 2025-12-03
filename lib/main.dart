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
              description: "Курс: 92.5 RUB",
              details: "Доллар США используется во всем мире как резервная валюта.",
            ),
            CurrencyCard(
              name: "Евро",
              imageUrl: "https://static4.banki.ru/ugc/a4/9c/9b/evrojmabhG.png",
              description: "Курс: 80.3 RUB",
              details: "Евро — официальная валюта еврозоны.",
            ),
            CurrencyCard(
              name: "Юань",
              imageUrl: "https://s0.rbk.ru/v6_top_pics/media/img/8/36/756389575987368.jpg",
              description: "Курс: 10.9 RUB",
              details: "Китайский юань набирает популярность в международной торговле.",
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String details;

  const CurrencyCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.details,
  });

  @override
  State<CurrencyCard> createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CurrencyDetailScreen(
              name: widget.name,
              imageUrl: widget.imageUrl,
              description: widget.description,
              details: widget.details,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(widget.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isLiked ? "Вы лайкнули ${widget.name}" : "Вы убрали лайк с ${widget.name}",
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String details;

  const CurrencyDetailScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Image.network(imageUrl),
          const SizedBox(height: 16),
          Text(description, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(details, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
