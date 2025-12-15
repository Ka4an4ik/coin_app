import 'package:flutter/material.dart';
import 'package:coin_app/data/datasource/country_remote_datasource.dart';
import 'package:coin_app/data/repository/country_repository_impl.dart';
import 'package:coin_app/domain/repository/country_repository.dart';
import 'package:coin_app/models/dto/country_dto.dart';

void main() {
  runApp(const Lab5App());
}

class Lab5App extends StatelessWidget {
  const Lab5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная 5 - Поиск стран',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CountrySearchScreen(),
    );
  }
}

class CountrySearchScreen extends StatefulWidget {
  const CountrySearchScreen({super.key});

  @override
  State<CountrySearchScreen> createState() => _CountrySearchScreenState();
}

class _CountrySearchScreenState extends State<CountrySearchScreen> {
  late CountryRepository _repository;
  late TextEditingController _searchController;
  List<CountryDTO> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Инициализация репозитория с источником данных
    final dataSource = CountryRemoteDataSource();
    _repository = CountryRepositoryImpl(dataSource: dataSource);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Метод поиска стран через репозиторий
  Future<void> _searchCountries(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _repository.searchCountries(query);
      setState(() {
        _searchResults = results;
        if (results.isEmpty) {
          _errorMessage = 'Страны не найдены';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: ${e.toString()}';
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск стран'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchCountries,
              decoration: InputDecoration(
                hintText: 'Введите название страны...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Сообщение об ошибке
          if (_errorMessage != null && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          // Индикатор загрузки
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          // Список результатов
          Expanded(
            child: _searchResults.isEmpty && !_isLoading
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Введите название страны для поиска'
                          : 'Результатов не найдено',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final country = _searchResults[index];
                      return CountryCard(country: country);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CountryCard extends StatefulWidget {
  final CountryDTO country;

  const CountryCard({super.key, required this.country});

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CountryDetailScreen(country: widget.country),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Флаг
              if (widget.country.flagUrl.isNotEmpty)
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.country.flagUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text('No flag'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              // Информация о стране
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.country.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.country.region} • ${widget.country.code}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Столица: ${widget.country.capital}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Кнопка избранного
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? '${widget.country.name} добавлена в избранное'
                            : '${widget.country.name} удалена из избранного',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountryDetailScreen extends StatelessWidget {
  final CountryDTO country;

  const CountryDetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(country.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Флаг
            if (country.flagUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    country.flagUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Основная информация
            _buildInfoCard(
              title: 'Основная информация',
              children: [
                _buildInfoRow('Название', country.name),
                _buildInfoRow('Код', country.code),
                _buildInfoRow('Регион', country.region),
                _buildInfoRow('Столица', country.capital),
              ],
            ),
            const SizedBox(height: 16),
            // Население
            _buildInfoCard(
              title: 'Население',
              children: [
                _buildInfoRow('Всего', _formatNumber(country.population)),
              ],
            ),
            const SizedBox(height: 16),
            // Языки
            if (country.languages.isNotEmpty)
              _buildInfoCard(
                title: 'Языки',
                children: [
                  _buildInfoRow(
                    'Язык(и)',
                    country.languages.join(', '),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Валюты
            if (country.currencies.isNotEmpty)
              _buildInfoCard(
                title: 'Валюты',
                children: [
                  _buildInfoRow(
                    'Валюта(ы)',
                    country.currencies.join(', '),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (Match m) => ' ',
        );
  }
}
