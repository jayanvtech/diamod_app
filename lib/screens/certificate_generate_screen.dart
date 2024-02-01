import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CertificateGenerate extends StatefulWidget {
  const CertificateGenerate({super.key});

  @override
  State<CertificateGenerate> createState() => _CertificateGenerateState();
}

class _CertificateGenerateState extends State<CertificateGenerate> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Certificate'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: formKey,
                child: TextFormField(
                  style: TextStyle(
                    height: 0.8,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.picture_as_pdf_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        formKey.currentState?.reset();
                      },
                      icon: Icon(Icons.delete_forever),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "0",
                    hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                    border: OutlineInputBorder(),
                    labelText: 'Enter Diamond ID',
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
