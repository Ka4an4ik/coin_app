# Резюме Лабораторной Работы 5

## Выполненные требования

✅ **Открытое API с параметром поиска**: REST Countries v3.1 (endpoint: `/name/{query}`)

✅ **Получение и отображение данных**: Полный UI с поиском и детальной информацией о странах

✅ **Использование интерфейсов**:

- `CountryDataSource` - интерфейс источника данных
- `CountryRepository` - интерфейс репозитория

✅ **Использование репозиториев**:

- `CountryRemoteDataSource` - реализация работы с API
- `CountryRepositoryImpl` - реализация репозитория

✅ **Использование DTO**:

- `CountryDTO` - объект передачи данных с парсингом JSON

## Структура решения

### Файлы проекта

```bash
lib/
├── main.dart                                    (700+ строк)
│   ├── Lab5App
│   ├── CountrySearchScreen
│   ├── CountryCard
│   └── CountryDetailScreen
│
├── models/dto/
│   └── country_dto.dart                        (70 строк)
│       ├── fromJson()
│       ├── toJson()
│       └── поля: name, code, region, capital, flagUrl, population, languages, currencies
│
├── domain/repository/
│   └── country_repository.dart                 (8 строк)
│       └── интерфейс с методами searchCountries, getAllCountries, getCountryByCode
│
└── data/
    ├── datasource/
    │   ├── country_datasource.dart             (8 строк)
    │   │   └── абстрактный интерфейс
    │   └── country_remote_datasource.dart      (60 строк)
    │       ├── работа с REST Countries API
    │       ├── обработка HTTP запросов
    │       ├── парсинг JSON
    │       └── обработка ошибок и таймаутов
    │
    └── repository/
        └── country_repository_impl.dart        (30 строк)
            └── реализация интерфейса репозитория

lib/examples/
└── api_usage_example.dart                      (200+ строк)
    ├── 7 примеров использования API
    ├── примеры парсинга DTO
    └── обработка ошибок
```

## Ключевые компоненты

### 1. DTO (CountryDTO)

Отвечает за:

- Парсинг JSON от REST API
- Хранение данных о стране
- Сериализацию обратно в JSON

### 2. DataSource (CountryRemoteDataSource)

Отвечает за:

- HTTP запросы к REST Countries API
- Преобразование ответов в DTO
- Обработку ошибок и таймаутов

### 3. Repository (CountryRepositoryImpl)

Отвечает за:

- Предоставление единого интерфейса
- Абстрагирование источника данных
- Возможность расширения (кэширование, etc.)

### 4. UI (main.dart)

Отвечает за:

- Отображение экранов
- Взаимодействие с репозиторием
- Управление состоянием приложения

## Использованные паттерны

- **Repository Pattern** - абстрагирование источника данных
- **Factory Pattern** - создание DTO из JSON
- **Dependency Injection** - передача DataSource в Repository
- **Clean Architecture** - разделение на слои

## API Особенности

- Базовый URL: `https://restcountries.com/v3.1`
- Параметр поиска: `GET /name/{query}`
- Ответ: JSON массив стран
- Без аутентификации, без rate-limiting
- Информация: название, флаги, население, языки, валюты и др.

## Запуск приложения

```bash
cd /Users/macbook/Desktop/Flutter_Orders/coin_app
flutter pub get
flutter run
```

## Функциональность

1. Поиск стран по названию в реальном времени
2. Отображение результатов поиска с флагами
3. Просмотр детальной информации о стране
4. Добавление в избранное
5. Обработка ошибок и пустых результатов
6. Красивый Material Design 3 интерфейс

## Документация

- `ARCHITECTURE.md` - подробное описание архитектуры
- `LAB5_README.md` - краткое описание проекта
- `LAB5_IMPLEMENTATION.md` - полное описание реализации
- `lib/examples/api_usage_example.dart` - примеры кода

## Итог

Реализовано полнофункциональное приложение Flutter, которое демонстрирует:

- Работу с REST API
- Чистую архитектуру с интерфейсами и репозиториями
- Правильное использование DTO
- SOLID принципы
- Обработку ошибок и исключений
- Асинхронное программирование (Future)
- Работу с JSON парсингом
- Хороший UI/UX с Material Design 3
