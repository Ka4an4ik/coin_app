import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coin_app/models/dto/country_dto.dart';

/// Сервис для работы с локальной базой данных SQLite
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  /// Получить экземпляр базы данных
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Инициализация базы данных
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'countries.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Создание таблиц при первом запуске
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        code TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        region TEXT NOT NULL,
        capital TEXT NOT NULL,
        flagUrl TEXT NOT NULL,
        population INTEGER NOT NULL,
        languages TEXT NOT NULL,
        currencies TEXT NOT NULL,
        addedAt INTEGER NOT NULL
      )
    ''');
  }

  /// Добавить страну в избранное
  Future<void> addToFavorites(CountryDTO country) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'code': country.code,
        'name': country.name,
        'region': country.region,
        'capital': country.capital,
        'flagUrl': country.flagUrl,
        'population': country.population,
        'languages': country.languages.join(','),
        'currencies': country.currencies.join(','),
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Удалить страну из избранного
  Future<void> removeFromFavorites(String countryCode) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'code = ?',
      whereArgs: [countryCode],
    );
  }

  /// Проверить, находится ли страна в избранном
  Future<bool> isFavorite(String countryCode) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'code = ?',
      whereArgs: [countryCode],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Получить все избранные страны
  Future<List<CountryDTO>> getFavorites() async {
    final db = await database;
    final result = await db.query(
      'favorites',
      orderBy: 'addedAt DESC',
    );

    return result.map((map) {
      return CountryDTO(
        code: map['code'] as String,
        name: map['name'] as String,
        region: map['region'] as String,
        capital: map['capital'] as String,
        flagUrl: map['flagUrl'] as String,
        population: map['population'] as int,
        languages: (map['languages'] as String).split(','),
        currencies: (map['currencies'] as String).split(','),
      );
    }).toList();
  }

  /// Получить количество избранных стран
  Future<int> getFavoritesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM favorites');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Очистить все избранное
  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete('favorites');
  }

  /// Закрыть базу данных
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
