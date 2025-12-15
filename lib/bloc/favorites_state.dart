import 'package:equatable/equatable.dart';
import 'package:coin_app/models/dto/country_dto.dart';

/// Состояния избранного
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Загрузка
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// Загружено
class FavoritesLoaded extends FavoritesState {
  final List<CountryDTO> favorites;
  final Set<String> favoriteCodes;

  const FavoritesLoaded({
    required this.favorites,
    required this.favoriteCodes,
  });

  @override
  List<Object?> get props => [favorites, favoriteCodes];

  bool isFavorite(String countryCode) {
    return favoriteCodes.contains(countryCode);
  }
}

/// Ошибка
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
