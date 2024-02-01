import 'package:diamond_app/database/database_helper.dart';
import 'package:diamond_app/database/diamond_data.dart';
import 'package:diamond_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // themeMode: uselightMode ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      //brightness: Brightness.dark),
      home: ChangeNotifierProvider(
        create: (context) => DiamondProvider(),
        child: HomeScreen(),
      ),
    );
  }
}

class DiamondProvider with ChangeNotifier {
  List<Diamond> _diamonds = [];
  bool _isLoading = true;

  List<Diamond> get diamonds => _diamonds;
  bool get isLoading => _isLoading;

  void loadDiamonds() async {
    final Database db = await DBHelper.initDB();
    _diamonds = await DBHelper.getDiamonds(db);
    _isLoading = false;
    notifyListeners();
  }
}
