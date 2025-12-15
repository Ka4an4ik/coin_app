import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_app/bloc/favorites_event.dart';
import 'package:coin_app/bloc/favorites_state.dart';
import 'package:coin_app/services/database_service.dart';

/// BLoC для управления избранными странами
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final DatabaseService _databaseService;

  FavoritesBloc({required DatabaseService databaseService})
      : _databaseService = databaseService,
        super(const FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  /// Загрузить избранное
  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    try {
      final favorites = await _databaseService.getFavorites();
      final favoriteCodes = favorites.map((c) => c.code).toSet();

      emit(FavoritesLoaded(
        favorites: favorites,
        favoriteCodes: favoriteCodes,
      ));
    } catch (e) {
      emit(FavoritesError('Ошибка загрузки избранного: ${e.toString()}'));
    }
  }

  /// Добавить в избранное
  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _databaseService.addToFavorites(event.country);

      // Перезагружаем список
      final favorites = await _databaseService.getFavorites();
      final favoriteCodes = favorites.map((c) => c.code).toSet();

      emit(FavoritesLoaded(
        favorites: favorites,
        favoriteCodes: favoriteCodes,
      ));
    } catch (e) {
      emit(FavoritesError('Ошибка добавления в избранное: ${e.toString()}'));
    }
  }

  /// Удалить из избранного
  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _databaseService.removeFromFavorites(event.countryCode);

      // Перезагружаем список
      final favorites = await _databaseService.getFavorites();
      final favoriteCodes = favorites.map((c) => c.code).toSet();

      emit(FavoritesLoaded(
        favorites: favorites,
        favoriteCodes: favoriteCodes,
      ));
    } catch (e) {
      emit(FavoritesError('Ошибка удаления из избранного: ${e.toString()}'));
    }
  }

  /// Переключить статус избранного
  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isFavorite = await _databaseService.isFavorite(event.country.code);

      if (isFavorite) {
        await _databaseService.removeFromFavorites(event.country.code);
      } else {
        await _databaseService.addToFavorites(event.country);
      }

      // Перезагружаем список
      final favorites = await _databaseService.getFavorites();
      final favoriteCodes = favorites.map((c) => c.code).toSet();

      emit(FavoritesLoaded(
        favorites: favorites,
        favoriteCodes: favoriteCodes,
      ));
    } catch (e) {
      emit(FavoritesError('Ошибка изменения избранного: ${e.toString()}'));
    }
  }
}
