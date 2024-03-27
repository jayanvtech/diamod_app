import 'dart:io';

import 'package:diamond_app/database/certificate_model.dart';
import 'package:path/path.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart'; // Might not be needed for iOS
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
// Import for iOS share functionality

class GiaCertificateScreen extends StatefulWidget {
  final String certificateNumber;
  const GiaCertificateScreen({super.key, required this.certificateNumber});

  @override
  State<GiaCertificateScreen> createState() => _GiaCertificateScreenState();
}

bool _isdownloading = false;
late Database _database;

class _GiaCertificateScreenState extends State<GiaCertificateScreen> {
  @override
  Widget build(BuildContext context) {
    //late final WebViewController _controller;
    InAppWebViewController _webViewController;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.certificateNumber),
      ),
      body: _isdownloading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: InAppWebView(
                initialSettings: InAppWebViewSettings(allowFileAccess: true),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onDownloadStartRequest:
                    (controller, downloadStartRequest) async {
                  setState(() {
                    _isdownloading = true;
                  });
                  print("Download Start Request");
                  print("URL: ${downloadStartRequest.url}");
                  final Uri url = Uri.parse("${downloadStartRequest.url}");
                  try {
                    var response = await http.get(url);
                    print(response);
                    if (response.statusCode == 200) {
                      if (Platform.isAndroid || Platform.isIOS) {
                        await Permission.storage.request();
                      }
                      String fileName =
                          'GIAertificate_${widget.certificateNumber}.pdf';
                      String downloadsFolderPath =
                          await _getDownloadsFolderPath();
                      Directory dir = Directory(downloadsFolderPath);
                      File file = File('${dir.path}/$fileName');
                      print('File Path: ${file.path}');
                      try {
                        OpenFile.open(file.path);
                      } catch (e) {
                        print('Error opening file: $e');
                      }
                      await file.writeAsBytes(response.bodyBytes);
                      AwesomeNotifications().createNotification(
                        actionButtons: [
                          NotificationActionButton(
                            key: 'OPEN',
                            label: 'Open',
                          ),
                        ],
                        content: NotificationContent(
                          payload: {
                            'PDF_Downloader': dir.path,
                            'file': fileName
                          },
                          id: 1,
                          channelKey: "PDF_Downloader",
                          title: "Certificate Downloaded",
                          body:
                              "PDF has been downloaded successfully in Download Folder",
                        ),
                      );
                      try {
                        if (response.statusCode == 200) {
                          final now = DateTime.now();
                          final formatter = DateFormat('h:mm d/MM/yy');
                          final formattedString = formatter.format(now);
                          await _database.insert(
                            'certificates',
                            {
                              'certificateNumber': widget.certificateNumber,
                              'filePath': file.path,
                              'downloadTime': DateTime.now().toString(),
                            },
                            conflictAlgorithm: ConflictAlgorithm.replace,
                          );
                          await DatabaseHelper.insertCertificate(Certificate(
                              certificateNumber: widget.certificateNumber,
                              filePath: file.path,
                              downloadDate: now));

                          print("Database Uploading");
                        } else {
                          showCustomSnackbar(
                              context,
                              "Error " + response.statusCode.toString(),
                              "Failed to download PDF.",
                              Icon(
                                Icons.error_outline_outlined,
                                color: Colors.white,
                              ));
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
                      setState(() {
                        _isdownloading = false;
                      });
                    }
                  } catch (e) {
                    print('Error downloading file: $e');
                  }
                },
                initialUrlRequest: URLRequest(
                    url: WebUri(
                        'https://www.gia.edu/report-check?reportno=${widget.certificateNumber}')),
              ),
            ),
    );
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

  Future<String> _getDownloadsFolderPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      print(await getApplicationDocumentsDirectory());
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      throw Exception('Unsupported platform');
    }
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
}
