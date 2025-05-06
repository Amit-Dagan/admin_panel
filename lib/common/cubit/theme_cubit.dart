import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit to manage the app's theme mode (light or dark).
class ThemeCubit extends Cubit<ThemeMode> {
  /// Starts in light mode by default.
  ThemeCubit() : super(ThemeMode.light);

  /// Switches to light theme.
  void setLight() => emit(ThemeMode.light);

  /// Switches to dark theme.
  void setDark() => emit(ThemeMode.dark);

  /// Toggles between light and dark themes.
  void toggle() => emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
}