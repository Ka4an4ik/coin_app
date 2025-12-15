import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_app/data/datasource/country_remote_datasource.dart';
import 'package:coin_app/data/repository/country_repository_impl.dart';
import 'package:coin_app/domain/repository/country_repository.dart';
import 'package:coin_app/models/dto/country_dto.dart';
import 'package:coin_app/bloc/country_bloc.dart';
import 'package:coin_app/bloc/country_event.dart';
import 'package:coin_app/bloc/country_state.dart';

void main() {
  runApp(const Lab6App());
}

class Lab6App extends StatelessWidget {
  const Lab6App({super.key});

  @override
  Widget build(BuildContext context) {
    // Создаем репозиторий
    final CountryRepository repository = CountryRepositoryImpl(
      dataSource: CountryRemoteDataSource(),
    );

    return MaterialApp(
      title: 'Лабораторная 6 - BLoC + Debounce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CountryBloc(repository: repository),
        child: const CountrySearchScreen(),
      ),
    );
  }
}

class CountrySearchScreen extends StatefulWidget {
  const CountrySearchScreen({super.key});

  @override
  State<CountrySearchScreen> createState() => _CountrySearchScreenState();
}

class _CountrySearchScreenState extends State<CountrySearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск стран (BLoC)'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                // Отправляем событие поиска в BLoC
                context.read<CountryBloc>().add(SearchCountries(query));
              },
              decoration: InputDecoration(
                hintText: 'Введите название страны...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<CountryBloc>().add(const ClearSearch());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Основной контент с BlocBuilder
          Expanded(
            child: BlocBuilder<CountryBloc, CountryState>(
              builder: (context, state) {
                if (state is CountryInitial) {
                  return const Center(
                    child: Text(
                      'Введите название страны для поиска',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else if (state is CountryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CountryRefreshing) {
                  // Показываем данные с индикатором обновления
                  return Stack(
                    children: [
                      _buildCountryList(state.currentCountries),
                      const Positioned(
                        top: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Обновление...'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is CountryLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<CountryBloc>().add(const RefreshCountries());
                      // Ждем, пока не изменится состояние
                      await context
                          .read<CountryBloc>()
                          .stream
                          .firstWhere((s) => s is! CountryRefreshing);
                    },
                    child: _buildCountryList(state.countries),
                  );
                } else if (state is CountryEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<CountryBloc>().add(const RefreshCountries());
                      await context
                          .read<CountryBloc>()
                          .stream
                          .firstWhere((s) => s is! CountryRefreshing);
                    },
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Страны не найдены',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Запрос: "${state.query}"',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is CountryError) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<CountryBloc>().add(const RefreshCountries());
                      await context
                          .read<CountryBloc>()
                          .stream
                          .firstWhere((s) => s is! CountryRefreshing);
                    },
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: Text(
                                    state.message,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<CountryBloc>()
                                        .add(const RefreshCountries());
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Повторить'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryList(List<CountryDTO> countries) {
    return ListView.builder(
      itemCount: countries.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final country = countries[index];
        return CountryCard(country: country);
      },
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
