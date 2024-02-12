import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diamond_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart'; // Import the open_file package

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notifications channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
    )
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(MyApp());
}

class CertificateGeneratePage extends StatefulWidget {
  @override
  _MyHoCertificateGenerateState createState() =>
      _MyHoCertificateGenerateState();
}

class _MyHoCertificateGenerateState extends State<CertificateGeneratePage> {
  TextEditingController certificateNumberController = TextEditingController();
  String verificationDate = "";
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Downloader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: certificateNumberController,
              decoration:
                  InputDecoration(labelText: 'Enter Certificate Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String certificateNumber = certificateNumberController.text;
                if (certificateNumber.isNotEmpty) {
                  await downloadAndSavePDF(certificateNumber);
                } else {
                  // Handle empty certificate number case
                }
              },
              child: Text('Download PDF'),
            ),
            SizedBox(height: 20),
            Text('Verification Date: $verificationDate'),
          ],
        ),
      ),
    );
  }

  Future<void> downloadAndSavePDF(String certificateNumber) async {
    final url = 'https://igi.org/API-IGI/viewpdf.php?r=$certificateNumber';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[800],
        duration: Duration(seconds: 5),
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        content: Container(
          height: 50,
          child: const Center(
            child: Text(
              textAlign: TextAlign.start,
              'PDF Downloading...',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
    try {
      var response = await http.get(Uri.parse(url));
      if (Platform.isAndroid) {
        await Permission.storage.request();
      } else {
        await Permission.storage.request();
      }
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if (response.statusCode == 200) {
        String fileName = 'certificate_$certificateNumber.pdf';

        const downloadsFolderPath = '/storage/emulated/0/Download/';

        Directory dir = Directory(downloadsFolderPath);
        File file = File('${dir.path}/$fileName');
        AwesomeNotifications().createNotification(
          actionButtons: [
            NotificationActionButton(
              key: 'OPEN',
              label: 'Open',
            ),
          ],
          content: NotificationContent(
            payload: {'PDF_Downloader': dir.path, 'file': fileName},
            id: 1,
            channelKey: "PDF_Downloader",
            title: "Certificate Downloaded",
            body: "PDF has been downloaded successfully in Download Folder",
          ),
        );
        ;
        OpenFile.open(file.path);

        // print(file.path +
        //     "");
        await file.writeAsBytes(response.bodyBytes);
        String date = DateTime.now().toString();
        setState(() {
          verificationDate = date;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.grey[800],
            duration: Duration(seconds: 3),
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            behavior: SnackBarBehavior.floating,
            content: Container(
              height: 40,
              child: Center(
                child: Text(
                  textAlign: TextAlign.start,
                  'PDF Downloaded in Download folder.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.grey[800],
            duration: Duration(seconds: 3),
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            behavior: SnackBarBehavior.floating,
            content: Container(
              height: 40,
              child: Center(
                child: Text(
                  textAlign: TextAlign.start,
                  'Failed to download PDF. Status code: ${response.statusCode}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        );

        print('Failed to download PDF. Status code: ${response.statusCode}');

        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[800],
          duration: Duration(seconds: 3),
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          behavior: SnackBarBehavior.floating,
          content: Container(
            height: 40,
            child: Center(
              child: Text(
                textAlign: TextAlign.start,
                'Error: $e',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      );

      print('Error: $e');
    }
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'OPEN') {
      String? basicChannel = receivedAction.payload!['PDF_Downloader'];
      String? fileName = receivedAction.payload!['file'];
      if (basicChannel != null && fileName != null) {
        String filePath = basicChannel + '/' + fileName;
        OpenFile.open(filePath);
      }
    }
  }
}
