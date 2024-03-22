// ignore_for_file: unused_field, override_on_non_overriding_member, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diamond_app/screens/certificates/gia_certificaate_screen.dart';
import 'package:diamond_app/screens/certificates/hrd_certificate_screen.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Download History',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryContainer),
          ),
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
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
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
      body: KeyboardDismisser(
        gestures: [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
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
                            color: Theme.of(context).colorScheme.primary,
                            height: 0.8,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.number,
                          controller: certificateNumberController,
                          decoration: InputDecoration(
                            prefixIconColor:
                                Theme.of(context).colorScheme.primary,
                            labelText: 'Certificate Number',
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            prefixIcon: Icon(Icons.picture_as_pdf),
                            suffixText: "",
                            suffixIconColor:
                                Theme.of(context).colorScheme.primary,
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
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            //color: Colors.black, ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),

                            enabled:
                                !_downloading, // Disable text field while downloading
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: TextButton(
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GiaCertificateScreen(
                                          certificateNumber: certificateNumberController.text,
                                        ),
                                      ),
                                    );                                      
                                  },
                                  child: Text(
                                    'GIA',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ))),
                          SizedBox(width: 10),
                          Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HrdCertificateScreen(
                                          certificateNumber: certificateNumberController.text,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'HRD',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ))),
                          SizedBox(width: 10),
                          Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'IGI',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ))),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (Platform.isIOS || Platform.isAndroid) {
                              FocusScope.of(context).unfocus();
                            }

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
                                showCustomSnackbar(
                                    context,
                                    'Certificate already downloaded',
                                    'Certificate already downloaded',
                                    Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.white,
                                    ));
                                OpenFile.open(certificates.first['filePath']);
                              } else {
                                if (Platform.isAndroid || Platform.isIOS) {
                                  await Permission.storage.request();
                                }

                                setState(() {
                                  _downloading = true;
                                });

                                // Certificate not downloaded, download it
                                await downloadAndSavePDF(
                                    context, certificateNumber);

                                // Update _downloading state after download completes
                                setState(() {
                                  _downloading = false;
                                });
                              }
                            } else {
                              showCustomSnackbar(
                                  context,
                                  'Please enter certificate number',
                                  'Certificate number cannot be empty',
                                  Icon(
                                    Icons.error_outline_outlined,
                                    color: Colors.white,
                                  ));
                              // Handle empty certificate number case
                            }
                          },
                          child: _downloading
                              ? Center(
                                  child: LoadingAnimationWidget.prograssiveDots(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  size: 30,
                                )) // Show progress indicator while downloading
                              : Row(
                                  // Display button content when not downloading
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.download,
                                        color: Colors.white, size: 24),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Download PDF',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
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
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer)),
                          Text("Certificate Number",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer)),
                          SizedBox(width: 10),
                          Text("Open",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer)),
                          Text("Delete",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer)),
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
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(10)),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _database.query('certificates'),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
      ),
    );
  }

  void showCustomSnackbar(
    BuildContext context,
    String title,
    String message,
    Icon icon,
  ) {
    Get.snackbar(
      titleText:
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: Duration(milliseconds: 500),
      barBlur: 20,
      icon: icon,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Theme.of(context).colorScheme.primary,
      colorText: Colors.white,
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
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20),
                  ),
                  TextButton(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${certificate['certificateNumber']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        Text(
                          '${certificate['downloadTime']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10,
                          ),
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
                            showCustomSnackbar(
                                context,
                                'Certificate Does Not Exist in Device',
                                'Certificate Does Not Exist in Device',
                                Icon(
                                  Icons.error_outline_outlined,
                                  color: Colors.white,
                                ));
                          }
                        } catch (e) {}
                      },
                      icon: Icon(Icons.open_in_browser),
                      color: AppColors.primaryAppColor),
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

    try {
      var response = await http.get(Uri.parse(url));


      // Request storage permission for both platforms
      if (Platform.isAndroid || Platform.isIOS) {
        await Permission.storage.request();
      }

      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      if (response.statusCode == 200) {
        String fileName = 'certificate_$certificateNumber.pdf';
        showCustomSnackbar(
            context,
            'Downloading PDF...',
            'Downloading PDF...',
            Icon(
              Icons.download,
              color: Colors.white,
            ));
        // Get the downloads folder path for both platforms
        String downloadsFolderPath = await _getDownloadsFolderPath();

        Directory dir = Directory(downloadsFolderPath);
        File file = File('${dir.path}/$fileName');
        print('File Path: ${file.path}');
        // Open the file
        String filepath = file.path;

        try {
          OpenFile.open(filepath);
          print("File Opened  " + filepath);
        } catch (e) {
          print('Error opening file: $e');
        }
        OpenFile.open(filepath);

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

        this.setState(() {
          verificationDate = date;
          _downloading = false;
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
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
        showCustomSnackbar(
            context,
            "Error " + response.statusCode.toString(),
            "Failed to download PDF.",
            Icon(
              Icons.error_outline_outlined,
              color: Colors.white,
            ));
        print('Failed to download PDF. Status code: ${response.statusCode}');
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      showCustomSnackbar(
          context,
          "Error",
          "Failed to download PDF.",
          Icon(
            Icons.error_outline_outlined,
            color: Colors.white,
          ));
      print('Error: $e');
    }
  }

// Function to get the downloads folder path for both platforms
  Future<String> _getDownloadsFolderPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      throw Exception('Unsupported platform');
    }
  }
  Widget webView = InAppWebView(
    initialUrlRequest: URLRequest(url: WebUri('https://www.gia.edu/report-check?reportno=2201265284')
  ));
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
