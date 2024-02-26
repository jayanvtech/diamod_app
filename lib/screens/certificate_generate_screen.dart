// ignore_for_file: unused_field, override_on_non_overriding_member, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certificate Downloader',
      theme: ThemeData(
          //  primarySwatch: Colors.blue,
          ),
      home: CertificateGeneratePage(),
    );
  }
}

class CertificateGeneratePage extends StatefulWidget {
  @override
  _MyHoCertificateGenerateState createState() =>
      _MyHoCertificateGenerateState();
}

class _MyHoCertificateGenerateState extends State<CertificateGeneratePage> {
  TextEditingController certificateNumberController = TextEditingController();
  String verificationDate = "";
  late Database _database;
  int certificateNumber = 0;
  @override
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
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'certificate_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE certificates(id INTEGER PRIMARY KEY, certificateNumber TEXT, filePath TEXT, downloadTime TEXT)",
        );
      },
      version: 1,
    );
    _database = await database;
  }

  Future<void> _showHistory(BuildContext context) async {
    List<Map<String, dynamic>> certificates =
        await _database.query('certificates');
    await showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Download History'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final certificate = certificates[index];
                return ListTile(
                  title: Text(
                    '${certificate['certificateNumber']} - ${certificate['downloadTime']}',
                  ),
                  onTap: () {
                    try {
                      OpenFile.open(certificate['filePath']);
                      if (certificate['filePath'] != null) {
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
                                  'certicate Does Not Exist in Device',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    } catch (e) {}
                    // Open the PDF file
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Delete the certificate
                      _deleteCertificate(certificate['id'], context);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteCertificate(int id, BuildContext context) async {
    try {
      List<Map<String, dynamic>> certificates =
          await _database.query('certificates');
      if (certificates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('There are no certificates to delete.'),
          ),
        );
        return;
      }

      await _database.delete(
        'certificates',
        where: 'id = ?',
        whereArgs: [id],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Certificate deleted successfully.'),
        ),
      );
      _initializeDatabase(); // Reload history after deleting
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${e.toString()} There was an error deleting the certificate.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeDatabase(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return _buildPage(context);
      },
    );
  }

  bool _downloading = false; // Track if the download is in progress
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        foregroundColor: AppColors.white2,
        backgroundColor: AppColors.blue,
        title: Text('Certificate Downloader'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              _showHistory(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: List.filled(5, BoxShadow(blurRadius: 5),
                        growable: true),
                    color: AppColors.primaryAppColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(
                          color: AppColors.textColor,
                          height: 0.8,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        controller: certificateNumberController,
                        decoration: InputDecoration(
                            prefixIconColor: AppColors.primaryAppColor,
                            labelText: 'Certificate Number',
                            labelStyle: TextStyle(
                              color: AppColors.textColor,
                            ),
                            prefixIcon: Icon(Icons.picture_as_pdf),
                            suffixText: "",
                            suffixIconColor: AppColors.primaryAppColor,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                setState(() {
                                  // formKey.currentState?.reset();
                                  //certificateNumberController.clear();
                                });
                              },
                            ),
                            hintText: "0",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                            //color: Colors.black, ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        // enabled: !_downloading, // Disable text field while downloading
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryAppColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          // Prevent multiple downloads
                          String certificateNumber =
                              certificateNumberController.text;
                          if (certificateNumber.isNotEmpty) {
                            // Check if certificate exists in the database
                            List<Map<String, dynamic>> certificates =
                                await _database.query('certificates',
                                    where: 'certificateNumber = ?',
                                    whereArgs: [certificateNumber]);
                            if (certificates.isNotEmpty) {
                              // Certificate already downloaded, show message and open it
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Certificate already downloaded.'),
                                ),
                              );
                              OpenFile.open(certificates.first['filePath']);
                            } else {
                              // Certificate not downloaded, download it
                              await downloadAndSavePDF(
                                  context, certificateNumber);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please Enter Certificate Number'),
                              ),
                            );
                            // Handle empty certificate number case
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.download, color: Colors.white, size: 24),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Download PDF',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              //  Text('Verification Date: $verificationDate'),
              Divider(),
              SizedBox(height: 5),
              Text(
                'History',
                style: TextStyle(
                  color: AppColors.white2,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: List.filled(5, BoxShadow(blurRadius: 5),
                        growable: true),
                    color: AppColors.primaryAppColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white2)),
                        Text("Certificate Number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white2)),
                        SizedBox(width: 10),
                        Text("Open",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white2)),
                        Text("Delete",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white2)),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: List.filled(5, BoxShadow(blurRadius: 5),
                          growable: true),
                      color: AppColors.primaryAppColor.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _database.query('certificates'),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading history'));
                      } else {
                        return _showHistoryView(snapshot.data!);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showHistoryView(List<Map<String, dynamic>> certificates) {
    return ListView.builder(
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final certificate = certificates[index];
        return Container(
          child: Column(
            children: [
              Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    certificate['id'].toString(),
                    style: TextStyle(color: AppColors.white2),
                  ),
                  TextButton(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${certificate['certificateNumber']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${certificate['downloadTime']}',
                          style:
                              TextStyle(color: AppColors.white2, fontSize: 10),
                        ),
                      ],
                    ),

                    onPressed: () {
                      try {
                        OpenFile.open(certificate['filePath']);
                        if (certificate['filePath'] != null) {
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
                                    'Certificate Does Not Exist in Device',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      } catch (e) {}
                    },
                    // trailing: IconButton(
                    //   icon: Icon(Icons.delete),
                    //   onPressed: () {
                    //     // Delete the certificate
                    //     _deleteCertificate(certificate['id'], context);
                    //     _initializeDatabase(); // Reload history after deleting
                    //   },
                    // ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        try {
                          OpenFile.open(certificate['filePath']);
                          if (certificate['filePath'] != null) {
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
                                      'Certificate Does Not Exist in Device',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        } catch (e) {}
                      },
                      icon: Icon(Icons.open_in_browser),
                      color: AppColors.white2),
                  IconButton(
                    icon: Icon(Icons.delete, color: AppColors.primaryAppColor),
                    onPressed: () {
                      // Delete the certificate
                      _deleteCertificate(certificate['id'], context);
                      _initializeDatabase(); // Reload history after deleting
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> downloadAndSavePDF(
      BuildContext context, String certificateNumber) async {
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
        OpenFile.open(file.path);

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
        final now = DateTime.now();
        final formatter = DateFormat('h:mm d/MM/yy'); // Adjust format as needed
        final formattedString = formatter.format(now);
        // Add downloaded certificate to database
        await _database.insert(
          'certificates',
          {
            'certificateNumber': certificateNumber,
            'filePath': file.path,
            'downloadTime': DateTime.now().toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
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

//History

class CertificateHistory extends StatelessWidget {
  final List<Map<String, dynamic>> certificates;
  final Function(int) onDelete;

  CertificateHistory({
    required this.certificates,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Download History',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final certificate = certificates[index];
                return ListTile(
                  title: Text(
                    '${certificate['certificateNumber']} - ${certificate['downloadTime']}',
                  ),
                  onTap: () {
                    try {
                      OpenFile.open(certificate['filePath']);
                      if (certificate['filePath'] != null) {
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
                                  'certicate Does Not Exist in Device',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    } catch (e) {}
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      onDelete(certificate['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
