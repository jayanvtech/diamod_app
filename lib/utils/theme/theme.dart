import 'package:flutter/material.dart';
import 'package:diamond_app/utils/app_colors.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Colors.green,
    inversePrimary: Color.fromARGB(255, 150, 223, 198), //stock grid color
    onBackground: AppColors.black, //Border
    secondary: AppColors.white,
    background: AppColors.black,
    tertiary: AppColors.black,
    onPrimary: Colors.white,
    onSurface: Color.fromARGB(29, 89, 113, 251).withOpacity(0.5),
    onSecondary:
        AppColors.primaryAppColor.withOpacity(0.06), //backgroud container
    secondaryContainer: Colors.white, //text
    // Set background color here
  ),
);


ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    inversePrimary: Colors.blue, //stock grid color
    brightness: Brightness.light,
    primary: Colors.blue,
    onBackground: Colors.blue, //Border
    secondary: Colors.grey[800]!,
    background: Colors.white,
    onSecondary:
        AppColors.primaryAppColor.withOpacity(0.05), //backgroud container
    secondaryContainer: Colors.black, //text
    tertiary: Colors.grey[200]!,
    onPrimary: Colors.white,
  ),
);
