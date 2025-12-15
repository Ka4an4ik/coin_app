# Иконка приложения

Для добавления иконки приложения:

1. Поместите изображение 1024x1024 px в `assets/icon/app_icon.png`
2. (Опционально) Для Android adaptive icon: `assets/icon/app_icon_foreground.png`
3. Запустите команду:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

Иконка будет автоматически создана для:

- Android (все разрешения + adaptive icon)
- iOS (все разрешения)

## Временная иконка

Пока используется стандартная иконка Flutter.
Для добавления кастомной иконки просто поместите изображение и запустите команду выше.

## Настройки

Настройки иконки находятся в `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#2196F3"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```
