import 'package:diamond_app/database/database_helper.dart';
import 'package:diamond_app/database/diamond_data.dart';
import 'package:diamond_app/features/drawer_menu_screen.dart';
import 'package:diamond_app/features/spotrate_widget.dart';
import 'package:diamond_app/main.dart';
import 'package:diamond_app/screens/certificates/certificate_generate_screen.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:diamond_app/utils/bottom_app_navigationbar.dart';
import 'package:diamond_app/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isDrawerOpen = false;
  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  bool _isRefreshing = false;
  @override
  Widget build(BuildContext context) {
    return _isRefreshing
        ? Center(
            child: LoadingAnimationWidget.prograssiveDots(
            color: Theme.of(context).colorScheme.secondaryContainer,
            size: 30,
          ))
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  foregroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,

                  //  shadowColor: Colors.deepOrange,
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Natural",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "CVD",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          print("refreshingddddddddddd");
                          _isRefreshing = true;
                          DBHelper.initDB();
                        });
                        setState(() {
                          _isRefreshing = false;
                        });
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu, color: Colors.white)),
                  ],
                  pinned: false,
                  floating: true,
                  title: Text('Home',
                      style: TextStyle(color: Colors.white),
                      selectionColor: AppColors.primaryAppColor),
                ),

                // Add more Sliver widgets as needed for your content
              ],
            ),
          );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey _globalKey = GlobalKey();
Future<void> _capturePngAndShare() async {
  try {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Share the captured image using share_plus
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').writeAsBytes(pngBytes);

    // Share the captured image using share_plus
    await Share.shareFiles([file.path], text: 'Diomand Details');
  } catch (e) {
    print('Error capturing image: $e');
  }
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
int _selectedOptionIndex = 0;
bool _isInitialDataFetched = false;
TextEditingController priceController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
Gradient _containerGradient = LinearGradient(
    colors: [Colors.blue, Colors.green], // Initial colors for the gradient
  );
  void updateColor(Gradient gradient, int index) {
    setState(() {
      _containerGradient = gradient;
      _selectedOptionIndex = index;
    });
  }

  Widget _buildGradientOptions(StateSetter setState) {
    List<Gradient> gradients = [
      LinearGradient(colors: [Colors.blue, Colors.green]),
      LinearGradient(colors: [Colors.blue, Colors.pink]),
      LinearGradient(colors: [Colors.yellow, Colors.brown]),
      LinearGradient(colors: [Colors.red, Colors.yellow]),
      LinearGradient(colors: [Colors.redAccent, Colors.orange]),
      LinearGradient(colors: [Colors.indigo, Colors.teal]),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        gradients.length,
        (index) => _buildGradientOption(gradients[index], index, setState),
      ),
    );
  }

  Widget _buildGradientOption(
      Gradient gradient, int index, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _containerGradient = gradient;
          _selectedOptionIndex = index;
        });
      },
      child: Container(
        width: 50,
        height: 25,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _selectedOptionIndex == index
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: _selectedOptionIndex == index
            ? Center(
                child: Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }

 void _showColorPickerBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
        backgroundColor: Colors.grey[100],
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              DateTime currentDate = DateTime.now();
              String formattedDate =
                  "${currentDate.day}/${currentDate.month}/${currentDate.year}";

              return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Share",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel_presentation_sharp),
                            ),
                          ],
                        ),
                        RepaintBoundary(
                          key: _globalKey,
                          child: Column(
                            textDirection: TextDirection.rtl,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),

                                                      // Default style
                                                      children: [
                                                        TextSpan(
                                                          text: "Color\n", //
                                                        ),
                                                        TextSpan(
                                                          text: colors[
                                                              selectedColorIndex], // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors
                                                              .black), // Default style
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              " Discount\n", // Regular text
                                                        ),
                                                        TextSpan(
                                                          text: selectedDiscountIndex
                                                              .toStringAsFixed(
                                                                  2), // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors
                                                              .black), // Default style
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Weight\n", // Regular text
                                                        ),
                                                        TextSpan(
                                                          text: selectedCarat
                                                              .toString(), // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors
                                                              .black), // Default style
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Shape\n", // Regular text
                                                        ),
                                                        TextSpan(
                                                          text: shapes[
                                                              selectedShapeIndex], // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors
                                                              .black), // Default style
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Per carat\n", // Regular text
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              calculateDiscountPrice(), // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors
                                                              .black), // Default style
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Clarity\n", // Regular text
                                                        ),
                                                        TextSpan(
                                                          text: clarities[
                                                              selectedClarityIndex], // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                gradient: _containerGradient),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 14,
                                                          color: Colors
                                                              .black), // Default style
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Total\n", // Regular text
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              calculateTotalPrice(), // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 14,
                                                          color: Colors
                                                              .black), // Default style
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Price\n", // Regular text
                                                        ),
                                                        TextSpan(
                                                          text: priceController
                                                              .text, // Text to be bold
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal), // Bold style
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors
                                                            .black), // Default style
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "Date:", // Regular text
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            formattedDate, // Text to be bold
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal), // Bold style
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildGradientOptions(setState),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.image),
                              onPressed: _capturePngAndShare,
                              label: Text('Share Image'),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.text_fields),
                              onPressed: () {
                                // Build the message to share
                                String message = ""
                                    "Stone Weight: ${selectedCarat.toString()} Ct.\n"
                                    "Shape: ${shapes[selectedShapeIndex]}\n"
                                    "Color: ${colors[selectedColorIndex]}\n"
                                    "Clarity: ${clarities[selectedClarityIndex]}\n"
                                    "Discount: ${selectedDiscountIndex.toStringAsFixed(1)}%\n"
                                    "Per carat: ${calculateDiscountPrice()}\n"
                                    "Total: ${calculateTotalPrice()}\n"
                                    'price:${priceController.text}\n'
                                    'Date:${formattedDate}';

                                // Share the message using share_plus
                                Share.share(message);
                              },
                              label: Text('Share Text'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors
                                        .blueAccent), // Blue background color
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // White text color
                              ),
                            ),
                          ],
                        )
                      ]));
            },
          );
        });
  }
  @override
  void initState() {
    super.initState();
    _updatePrice();
    fetchDataAndStore(context);
  }

  bool _isRefreshing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        // backgroundColor: AppColors.blue,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          actions: [
            IconButton(
                onPressed: () {
                  
                },
                icon: Icon(Icons.diamond_outlined, color: Theme.of(context).colorScheme.onPrimary)),
            TextButton(
              onPressed: () {},
              child: Text(
                "CVD",
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () async {
                if (mounted) {
                  setState(() {
                    _isRefreshing = true;
                  });
                }

                try {
                  fetchDataAndStore(context);
                  print("object");
                } catch (e) {
                  print(e.toString());
                }

                await Future.delayed(const Duration(milliseconds: 5000));
                setState(() {
                  _isRefreshing = false;
                });
              },
              icon: Icon(
                Icons.refresh,
              ),
            ),
          ],
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          shadowColor: Colors.transparent,
          scrolledUnderElevation: 0,
          title: Text(
            'Calculator',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: DrawerMenuScreen(),
        ),
        body: _isRefreshing
            ? Center(
                child: LoadingAnimationWidget.prograssiveDots(
                color: Theme.of(context).colorScheme.secondaryContainer,
                size: 50,
              ))
            : KeyboardDismisser(
                gestures: [
                  GestureType.onTap,
                  GestureType.onPanUpdateDownDirection,
                ],
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,

                      // color: Theme.of(context).colorScheme.background,
                      // gradient: LinearGradient(
                      //   colors: [
                      //     AppColors.primaryAppColor
                      //         .withOpacity(0.000000000000000000001),
                      //     Theme.of(context).colorScheme.secondaryContainer,
                      //   ],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              autovalidateMode: AutovalidateMode.always,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                height: 0.8,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixIconColor:
                                    Theme.of(context).colorScheme.primary,
                                labelText: 'Carat',
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                prefixIcon: Icon(Icons.diamond),
                                suffixText: "Ct.",
                                suffixIconColor:
                                    Theme.of(context).colorScheme.primary,
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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                //color: Colors.black, ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedCarat = double.tryParse(value) ?? 0.0;
                                  _updatePrice();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              //color: Theme.of(context).colorScheme.onSecondary,
                              // borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                //color: Theme.of(context).colorScheme.onSecondary,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: _buildSelector("Shape", shapes,
                                        selectedShapeIndex, context, (index) {
                                      setState(() {
                                        selectedShapeIndex = index;
                                        _updatePrice();
                                      });
                                    }),
                                  ),
                                  _buildSelector("Color", colors,
                                      selectedColorIndex, context, (index) {
                                    setState(() {
                                      selectedColorIndex = index;
                                      _updatePrice();
                                    });
                                  }),
                                  _buildSelector("Clarity", clarities,
                                      selectedClarityIndex, context, (index) {
                                    setState(() {
                                      selectedClarityIndex = index;
                                      _updatePrice();
                                    });
                                  }),
                                  _buildDiscountSelector(
                                    "Discount",
                                    (value) {
                                      setState(() {
                                        selectedDiscountIndex = value;
                                        // _updatePrice();
                                      });
                                    },
                                    context,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(
                              //     color: Theme.of(context).colorScheme.primary),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.primaryAppColor
                                                  .withOpacity(0.12),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      0, 158, 158, 158)),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: _buildPriceTextField("Price",
                                              priceController, context)),
                                      Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(22, 255, 0, 0),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    0, 158, 158, 158)),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: _buildDiscountTextField(
                                            "Discount", selectedDiscountIndex),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    0, 255, 0, 0)),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: _buildDiscountPriceTextField(
                                            "Discount Price", priceController),
                                      ),
                                      Container(
                                        child: _buildTotalPriceTextField(
                                            "Total Price", priceController),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.share,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      label: Text(
                                        'Share',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        elevation: 0,
                                        //primary: Colors.blue,
                                      ),
                                      onPressed: () {
                                        if (selectedCarat <= 0) {
                                          // Show a Snackbar indicating that the stone weight needs to be entered
                                          showCustomSnackbar(context, "Error", "Please Enter the stone weight", Icon(Icons.error_outline));
                                        } else {
                                          // Build the message to display in the AlertDialog
                                          // String message = ""
                                          //     "Stone Weight: ${selectedCarat.toString()} Ct.\n"
                                          //     "Shape: ${shapes[selectedShapeIndex]}\n"
                                          //     "Color: ${colors[selectedColorIndex]}\n"
                                          //     "Clarity: ${clarities[selectedClarityIndex]}\n"
                                          //     "Discount: ${selectedDiscountIndex.toStringAsFixed(1)}%";

                                          // Show the AlertDialog
                                        _showColorPickerBottomSheet(context
                                              
                                        );
                                          
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            // height: 102,
                            child: SpotrateWidget(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 60,
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.filter_list),
                                label: const Text('Generate Certificate'),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 0,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    // primary: AppColors.primaryAppColor,
                                    disabledBackgroundColor:
                                        Color.fromARGB(255, 76, 0, 255)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CertificateGeneratePage(),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextFormField(
        textAlign: TextAlign.start,
        readOnly: true,
        controller: discountPriceController,
        inputFormatters: [LengthLimitingTextInputFormatter(8)],
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          height: 0.8,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          labelText: title,
          // prefixIcon: Icon(Icons.attach_money, size: 14),
          suffixText: "/Ct.",
          suffixStyle: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
          labelStyle: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
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
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextFormField(
        textAlign: TextAlign.start,
        readOnly: true,
        controller: totalPriceController,
        inputFormatters: [LengthLimitingTextInputFormatter(8)],
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          height: 0.8,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          labelText: title,
          // prefixIcon: Icon(Icons.attach_money, size: 14),
          suffixText: "/Ct.",
          suffixStyle: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
          labelStyle: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryAppColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
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
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextFormField(
        readOnly: true,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.end,
        controller: discountController,
        inputFormatters: [LengthLimitingTextInputFormatter(5)],
        style: TextStyle(
          height: 0.8,
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          double discount = double.tryParse(value) ?? 0.0;
          selectedDiscountIndex = discount; // Update selectedDiscountIndex
          _updatePrice();
        },
        decoration: InputDecoration(
          labelText: title,
          prefixStyle: TextStyle(
            fontSize: 12,
            color: AppColors.textColor,
          ),
          prefixIcon: IconButton(
            onPressed: () {
              // Change the sign of the discount value
              setState(() {
                selectedDiscountIndex = -selectedDiscountIndex;
                discountController.text =
                    selectedDiscountIndex.toStringAsFixed(1);
                _updatePrice();
              });
            },

            icon: Icon(selectedDiscountIndex >= 0 ? Icons.add : Icons.remove),
            // Change the icon based on the sign of the discount value
            color: AppColors.primaryAppColor,
          ),
          labelStyle: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
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

Widget _buildPriceTextField(
    String title, TextEditingController controller, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.4,
    child: TextFormField(
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      controller: controller,
      inputFormatters: [
        LengthLimitingTextInputFormatter(5)
      ], // Limit to 5 characters
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        height: 0.8,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        suffixText: "/Ct.",
        suffixStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.primary,
        ),
        prefixIconColor: Theme.of(context).colorScheme.primary,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 8, right: 8), // Adjust the padding
          child: Icon(Icons.attach_money, size: 18), // Adjust the size
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.primary,
        ),
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

Widget _buildDiscountSelector(
    String title, ValueChanged<double> onChanged, BuildContext context) {
  int selectedIndex = (selectedDiscountIndex * 10).toInt() +
      100; // Calculate the selected index for CupertinoPicker
  bool isNegative =
      selectedDiscountIndex < 0; // Check if selected discount is negative

  return Expanded(
    child: Container(decoration: BoxDecoration( color: Theme.of(context).colorScheme.onSecondary,
      borderRadius: BorderRadius.circular(10)),
     
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondaryContainer),
          ),
          Container(decoration: BoxDecoration(),
            height: 150,
            child: CupertinoPicker(
              // backgroundColor: Theme.of(context).colorScheme.onSecondary,
              scrollController:
                  FixedExtentScrollController(initialItem: selectedIndex),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                double discount = (index - 100) / 1.0;
                onChanged(discount);
              },
              children: List.generate(201, (index) {
                double discount = (index - 100) / 1.0;
                // Adjust the discount value based on whether it's negative or positive
                if (isNegative) {
                  discount = -discount;
                }
                return Center(
                  child: Text(
                    '${discount.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: discount == selectedDiscountIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: discount == selectedDiscountIndex
                          ? Colors.red
                          : Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
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
Widget _buildSelector(String title, List<String> items, int selectedIndex,
    BuildContext context, ValueChanged<int> onChanged) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Container(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondaryContainer),
            ),
          ),
          Container(
            height: 150,
            child: CupertinoPicker(
              // backgroundColor: Theme.of(context).colorScheme.onSecondary,
              itemExtent: 40,
              onSelectedItemChanged: onChanged,
              children: items.map((item) {
                return Center(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: selectedIndex == items.indexOf(item)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondaryContainer,
                      fontSize: 20,
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
