import 'package:diamond_app/database/database_helper.dart';
import 'package:diamond_app/database/diamond_data.dart';
import 'package:diamond_app/features/spotrate_widget.dart';

import 'package:diamond_app/main.dart';
import 'package:diamond_app/screens/certificate_generate_screen.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<String> shapes = [
  'BR',
  'PS',
  'PR',
  'RAD',
  'AC',
  'EM',
  'MQ',
  'BAG',
  'HS',
  'CU',
  'TRI',
  'OV',
  'OTH'
];
List<String> colors = ['D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];
List<String> clarities = [
  'IF',
  'VVS1',
  'VVS2',
  'VS1',
  'VS2',
  'SI1',
  'SI2',
  'SI3',
  'I1',
  'I2',
  'I3'
];

int selectedShapeIndex = 0;
int selectedColorIndex = 0;
int selectedClarityIndex = 0;
double selectedCarat = 0.0;
double selectedDiscountIndex = 0.0;

bool _isInitialDataFetched = false;
TextEditingController priceController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updatePrice();

    fetchDataAndStore(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(
                          color: const Color.fromARGB(0, 158, 158, 158)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      autovalidateMode: AutovalidateMode.always,
                      style: TextStyle(
                          height: 0.8,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black),
                      decoration: InputDecoration(
                          labelText: 'Carat',
                          prefixIcon: Icon(Icons.diamond),
                          suffixText: "Ct.",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              setState(() {
                                formKey.currentState?.reset();
                                selectedCarat = 0.0;
                                _updatePrice();
                              });
                            },
                          ),
                          hintText: "0",
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black),
                          //color: Colors.black, ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          selectedCarat = double.tryParse(value) ?? 0.0;
                          _updatePrice();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey[100],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSelector("Shape", shapes, selectedShapeIndex,
                            (index) {
                          setState(() {
                            selectedShapeIndex = index;
                            _updatePrice();
                          });
                        }),
                        _buildSelector("Color", colors, selectedColorIndex,
                            (index) {
                          setState(() {
                            selectedColorIndex = index;
                            _updatePrice();
                          });
                        }),
                        _buildSelector(
                            "Clarity", clarities, selectedClarityIndex,
                            (index) {
                          setState(() {
                            selectedClarityIndex = index;
                            _updatePrice();
                          });
                        }),
                        _buildDiscountSelector("Discount", (value) {
                          setState(() {
                            selectedDiscountIndex = value;
                            // _updatePrice();
                          });
                        })
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          0, 158, 158, 158)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: _buildPriceTextField(
                                  "Price", priceController)),
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(22, 255, 0, 0),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(0, 158, 158, 158)),
                                borderRadius: BorderRadius.circular(10)),
                            child: _buildDiscountTextField(
                                "Discount", selectedDiscountIndex),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(0, 158, 158, 158)),
                                borderRadius: BorderRadius.circular(10)),
                            child: _buildDiscountPriceTextField(
                                "Discount Price", priceController),
                          ),
                          Container(
                            child: _buildTotalPriceTextField(
                                "Total Price", priceController),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: ElevatedButton.icon(
                                  icon: const Icon(Icons.share),
                                  label: const Text('Share'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.black,
                                    elevation: 0,
                                    //primary: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CertificateGenerate(),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.172,
                        child: SpotrateWidget(),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 60,
                        child: ElevatedButton.icon(
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Generate Certificate'),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 0,
                                primary: Colors.black,
                                disabledBackgroundColor:
                                    Color.fromARGB(255, 76, 0, 255)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CertificateGenerate(),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildDiscountPriceTextField(
      String title, TextEditingController controller) {
    String totalPrice = calculateDiscountPrice();
    TextEditingController discountPriceController =
        TextEditingController(text: totalPrice.toString());

    return Container(
      width: 160,
      child: TextFormField(
        textAlign: TextAlign.start,
        readOnly: true,
        controller: discountPriceController,
        inputFormatters: [LengthLimitingTextInputFormatter(8)],
        style: TextStyle(
          height: 0.8,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          labelText: title,
          // prefixIcon: Icon(Icons.attach_money, size: 14),
          suffixText: "/Ct.",
          suffixStyle: TextStyle(fontSize: 12),
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPriceTextField(
      String title, TextEditingController controller) {
    String totalPrice = calculateTotalPrice();
    TextEditingController totalPriceController =
        TextEditingController(text: totalPrice.toString());

    return Container(
      width: 160,
      child: TextFormField(
        textAlign: TextAlign.start,
        readOnly: true,
        controller: totalPriceController,
        inputFormatters: [LengthLimitingTextInputFormatter(8)],
        style: TextStyle(
          height: 0.8,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          labelText: title,
          // prefixIcon: Icon(Icons.attach_money, size: 14),
          suffixText: "/Ct.",
          suffixStyle: TextStyle(fontSize: 12),
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  String calculateDiscountPrice() {
    double DiscountPrice = priceController.text.isNotEmpty
        ? double.parse(priceController.text) * (1 + selectedDiscountIndex / 100)
        : 0.0;
    String formattedDiscountPrice = DiscountPrice.toStringAsFixed(2);
    return formattedDiscountPrice;
  }

  String calculateTotalPrice() {
    // double DiscountPrice = priceController.text.isNotEmpty
    //     ? double.parse(selectedCarat.toString()) * (formattedDiscountPrice)
    //     : 0.0;
    // double formattedDiscountPrice = DiscountPrice;
    // ;
    double Totalprice =
        selectedCarat * (double.parse(calculateDiscountPrice()));

    String formattedTotalPrice = Totalprice.toStringAsFixed(2);
    return formattedTotalPrice;
  }

  Widget _buildDiscountTextField(String title, double value) {
    TextEditingController discountController =
        TextEditingController(text: value.toStringAsFixed(1));

    return Container(
      width: 160,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.end,
        controller: discountController,
        inputFormatters: [LengthLimitingTextInputFormatter(5)],
        style: TextStyle(
          height: 0.8,
          fontSize: 16,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          double discount = double.tryParse(value) ?? 0.0;
          setState(() {
            selectedDiscountIndex = discount;
            _updatePrice();
          });
        },
        decoration: InputDecoration(
          labelText: title,
          prefix: Text(' - '),
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

Widget _buildPriceTextField(String title, TextEditingController controller) {
  return Container(
    width: 160,
    child: TextFormField(
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      controller: controller,
      inputFormatters: [
        LengthLimitingTextInputFormatter(5)
      ], // Limit to 5 characters
      style: TextStyle(
        height: 0.8,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        suffixText: "/Ct.",
        suffixStyle: TextStyle(fontSize: 12),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 8, right: 8), // Adjust the padding
          child: Icon(Icons.attach_money, size: 18), // Adjust the size
        ),
        labelText: title,
        labelStyle: TextStyle(fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget _buildDiscountSelector(String title, ValueChanged<double> onChanged) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        Container(
          height: 120,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              double discount = (index - 100) / 1.0;
              onChanged(discount);
            },

            // looping: bool.fromEnvironment("true"),
            children: List.generate(201, (index) {
              double discount = (index - 100) / 1.0;
              return Center(
                child: Text(
                  '${discount.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    color: discount == selectedDiscountIndex
                        ? Colors.red
                        : Colors.black,
                    fontWeight: discount == selectedDiscountIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    ),
  );
}

Future<void> _updatePrice() async {
  final Database db = await DBHelper.initDB();
  final List<Diamond> matchingDiamonds = await DBHelper.queryDiamonds(
    db,
    shapes[selectedShapeIndex],
    colors[selectedColorIndex],
    clarities[selectedClarityIndex],
    selectedCarat,
  );
  priceController.text =
      matchingDiamonds.map((diamond) => '${diamond.price}').join(', ');
}

Widget _buildSelector(String title, List<String> items, int selectedIndex,
    ValueChanged<int> onChanged) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 120,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: onChanged,
            children: items.map((item) {
              return Center(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: selectedIndex == items.indexOf(item)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Future<void> fetchDataAndStore(BuildContext context) async {
  // Check if data is already fetched
  if (_isInitialDataFetched) {
    return;
  }

  final response =
      await http.get(Uri.parse('http://27.54.182.126:5001/v1/diamondData'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];

    final Database db = await DBHelper.initDB();

    for (var diamondData in data) {
      final Diamond diamond = Diamond(
        diamondData[0],
        diamondData[1],
        diamondData[2],
        diamondData[3],
        diamondData[4],
        diamondData[5],
        diamondData[6],
      );

      // Check if data is already present before inserting
      if (!await DBHelper.isDiamondExist(db, diamond)) {
        await DBHelper.insertDiamond(db, diamond);
      }
    }

    Provider.of<DiamondProvider>(context, listen: false).loadDiamonds();

    // Set the flag to true after initial data fetch
    _isInitialDataFetched = true;
  }
}

class SpotRate {
  final String name;
  final String ltp;
  final String chg;
  final String time;

  SpotRate({
    required this.name,
    required this.ltp,
    required this.chg,
    required this.time,
  });
}
