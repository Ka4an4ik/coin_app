import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_app/bloc/country_event.dart';
import 'package:coin_app/bloc/country_state.dart';
import 'package:coin_app/domain/repository/country_repository.dart';
import 'package:coin_app/models/dto/country_dto.dart';

/// BLoC для управления состоянием поиска стран
class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final CountryRepository repository;
  Timer? _debounceTimer;
  String _lastQuery = '';

  CountryBloc({required this.repository}) : super(const CountryInitial()) {
    // Обработка события поиска стран с debounce
    on<SearchCountries>(
      _onSearchCountries,
      transformer: _debounceTransformer(const Duration(milliseconds: 500)),
    );

    // Обработка события обновления
    on<RefreshCountries>(_onRefreshCountries);

    // Обработка очистки поиска
    on<ClearSearch>(_onClearSearch);

    // Обработка загрузки всех стран
    on<LoadAllCountries>(_onLoadAllCountries);
  }

  /// Трансформер для debounce
  EventTransformer<SearchCountries> _debounceTransformer(Duration duration) {
    return (events, mapper) {
      return events
          .debounceTime(duration)
          .asyncExpand(mapper);
    };
  }

  /// Обработчик события поиска стран
  Future<void> _onSearchCountries(
    SearchCountries event,
    Emitter<CountryState> emit,
  ) async {
    final query = event.query.trim();
    _lastQuery = query;

    // Если запрос пустой, возвращаем начальное состояние
    if (query.isEmpty) {
      emit(const CountryInitial());
      return;
    }

    // Показываем индикатор загрузки
    emit(const CountryLoading());

    try {
      // Выполняем поиск через репозиторий
      final countries = await repository.searchCountries(query);

      // Проверяем, не изменился ли запрос за время загрузки
      if (_lastQuery != query) {
        return;
      }

      if (countries.isEmpty) {
        emit(CountryEmpty(query));
      } else {
        emit(CountryLoaded(countries: countries, query: query));
      }
    } catch (e) {
      // Проверяем, не изменился ли запрос за время загрузки
      if (_lastQuery != query) {
        return;
      }

      emit(CountryError('Ошибка поиска: ${e.toString()}'));
    }
  }

  /// Обработчик события обновления
  Future<void> _onRefreshCountries(
    RefreshCountries event,
    Emitter<CountryState> emit,
  ) async {
    // Сохраняем текущие данные для отображения при обновлении
    final currentState = state;
    List<CountryDTO> currentCountries = [];
    String currentQuery = _lastQuery;

    if (currentState is CountryLoaded) {
      currentCountries = currentState.countries;
      currentQuery = currentState.query;
    }

    // Показываем состояние обновления
    if (currentCountries.isNotEmpty) {
      emit(CountryRefreshing(currentCountries));
    } else {
      emit(const CountryLoading());
    }

    try {
      List<CountryDTO> countries;

      // Если есть запрос поиска, повторяем поиск
      if (currentQuery.isNotEmpty) {
        countries = await repository.searchCountries(currentQuery);
      } else {
        // Иначе загружаем все страны (первые 20)
        final allCountries = await repository.getAllCountries();
        countries = allCountries.take(20).toList();
      }

      if (countries.isEmpty) {
        emit(CountryEmpty(currentQuery));
      } else {
        emit(CountryLoaded(countries: countries, query: currentQuery));
      }
    } catch (e) {
      emit(CountryError('Ошибка обновления: ${e.toString()}'));
    }
  }

  /// Обработчик очистки поиска
  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<CountryState> emit,
  ) async {
    _lastQuery = '';
    emit(const CountryInitial());
  }

  /// Обработчик загрузки всех стран
  Future<void> _onLoadAllCountries(
    LoadAllCountries event,
    Emitter<CountryState> emit,
  ) async {
    emit(const CountryLoading());

    try {
      final allCountries = await repository.getAllCountries();
      final countries = allCountries.take(20).toList();

      if (countries.isEmpty) {
        emit(const CountryEmpty(''));
      } else {
        emit(CountryLoaded(countries: countries, query: ''));
      }
    } catch (e) {
      emit(CountryError('Ошибка загрузки: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

/// Extension для добавления debounce к Stream
extension _DebounceExtension<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    StreamController<T>? controller;
    Timer? timer;
    StreamSubscription<T>? subscription;

    void onData(T data) {
      timer?.cancel();
      timer = Timer(duration, () {
        controller?.add(data);
      });
    }

    void onError(Object error, StackTrace stackTrace) {
      timer?.cancel();
      controller?.addError(error, stackTrace);
    }

    void onDone() {
      timer?.cancel();
      controller?.close();
    }

    controller = StreamController<T>(
      onListen: () {
        subscription = listen(
          onData,
          onError: onError,
          onDone: onDone,
        );
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () {
        timer?.cancel();
        return subscription?.cancel();
      },
    );

    return controller.stream;
  }
}
