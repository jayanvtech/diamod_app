import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ThemeChanger with ChangeNotifier {
  var _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

   void setTheme(ThemeData? theme) {
    _themeMode = themeMode;
    notifyListeners();
  }
  
}
  