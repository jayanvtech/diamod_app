import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diamond_app/database/database_helper.dart';
import 'package:diamond_app/database/diamond_data.dart';
import 'package:diamond_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:diamond_app/utils/app_colors.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestStoragePermission();
  await Permission.manageExternalStorage.request();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "PDF_Downloader",
      channelName: "Download",
      channelDescription: "Basic notifications channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Download",
    )
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

Future<void> _requestStoragePermission() async {
  if (!(await Permission.storage.status.isGranted)) {
    await Permission.manageExternalStorage.request();
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    // You can customize the permission request message here
    if (await Permission.storage.shouldShowRequestRationale) {
      await Permission.storage.request();

      if (await Permission.storage.status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    await Permission.storage.request();
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    }
  }
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
        colorSchemeSeed: AppColors.primaryAppColor,
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
