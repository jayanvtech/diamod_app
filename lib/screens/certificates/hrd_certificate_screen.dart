import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart'; // Might not be needed for iOS
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// Import for iOS share functionality

class HrdCertificateScreen extends StatefulWidget {
 final String certificateNumber;
const HrdCertificateScreen({super.key, required this.certificateNumber});

  @override
  State<HrdCertificateScreen> createState() => _HrdCertificateScreenState();
}
bool _isdownloading = false;
class _HrdCertificateScreenState extends State<HrdCertificateScreen> {
  @override
  Widget build(BuildContext context) {
    //late final WebViewController _controller;
    InAppWebViewController _webViewController;

    return Scaffold(
      appBar: AppBar(title: Text(widget.certificateNumber),),
      body: _isdownloading? Center(child: CircularProgressIndicator()): Container(
        child: InAppWebView(
          initialSettings: InAppWebViewSettings(allowFileAccess: true),
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
          onDownloadStartRequest: (controller, downloadStartRequest) async {
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
               String fileName = 'certificate_${widget.certificateNumber}.pdf';
                String downloadsFolderPath = await _getDownloadsFolderPath();
                Directory dir = Directory(downloadsFolderPath);
                File file = File('${dir.path}/$fileName');
                print('File Path: ${file.path}');
                try {
                  OpenFile.open(file.path);
                } catch (e) {
                  print('Error opening file: $e');
                }
                await file.writeAsBytes(response.bodyBytes);
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
                'https://my.hrdantwerp.com')),
                 // 'https://www.gia.edu/report-check?reportno=${widget.certificateNumber}')),
        ),
      ),
    );
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
}