import 'package:equatable/equatable.dart';
import 'package:coin_app/models/dto/country_dto.dart';

/// События для избранного
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузить избранные страны
class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

/// Добавить страну в избранное
class AddToFavorites extends FavoritesEvent {
  final CountryDTO country;

  const AddToFavorites(this.country);

  @override
  List<Object?> get props => [country];
}

/// Удалить страну из избранного
class RemoveFromFavorites extends FavoritesEvent {
  final String countryCode;

  const RemoveFromFavorites(this.countryCode);

  @override
  List<Object?> get props => [countryCode];
}

/// Переключить статус избранного
class ToggleFavorite extends FavoritesEvent {
  final CountryDTO country;

  const ToggleFavorite(this.country);

  @override
  List<Object?> get props => [country];
}
