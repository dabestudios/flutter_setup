import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColorLight,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.accentColor,
    background: AppColors.backgroundColorLight,
  ),
  // Definir otros colores y estilos para el tema claro.
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryColorDark,
  scaffoldBackgroundColor: AppColors.backgroundColorDark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryColorDark,
    secondary: AppColors.accentColor,
    background: AppColors.backgroundColorDark,
  ),
  // Definir otros colores y estilos para el tema oscuro.
);
