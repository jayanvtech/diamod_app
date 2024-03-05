import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diamond_app/database/database_helper.dart';
import 'package:diamond_app/database/diamond_data.dart';
import 'package:diamond_app/database/stock_database.dart';
import 'package:diamond_app/screens/Authentication/login_screen.dart';
import 'package:diamond_app/screens/Authentication/signup_screen.dart';
import 'package:diamond_app/utils/bottom_app_navigationbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:diamond_app/utils/app_colors.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestStoragePermission();

  await DatabaseHelper().initDatabase();
  await DataManager().fetchDataAndStore();
  // await StockDatabaseHelper().initDatabase();
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: AppColors.primaryAppColor,
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: checkAuthentication(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or any loading indicator
          } else if (snapshot.hasError || snapshot.data == null) {
            return SignUpScreen();
            // Show login/signup screen if there's an error or data is null
          } else {
            if (snapshot.data!) {
              print('User is sssssauthenticated');
              return ChangeNotifierProvider(
                  create: (context) => DiamondProvider(), child: MyHomePage());
            } else {
              print('Erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
              return ChangeNotifierProvider(
                create: (context) => DiamondProvider(),
                child:
                    MyHomePage(), // Assuming SignUpScreen is your authentication screen
              );
            }
          }
        },
      ),
    );
  }

  Future<bool> checkAuthentication() async {
    final uri = Uri.parse("http://192.168.130.41:3013/v1/user/verify_user");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    if (authToken == null) {
      print('No authToken found');
      Get.to(() => LoginScreen());
      return false;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$authToken', // Add the authToken to the headers
    };
    print('Token checkauith: $authToken');
    try {
      http.Response response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        // User is authenticated
        ChangeNotifierProvider(
          create: (context) => DiamondProvider(),
          child: MyHomePage(),
        );
        return true;
      } else {
        // User is not authenticated
        return false;
      }
    } catch (error) {
      print('Error checking authentication: $error');
      return false;
    }
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
