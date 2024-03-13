import 'package:diamond_app/database/stock_database.dart';
import 'package:diamond_app/screens/stock_diamond_details.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({Key? key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white2,
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                _isRefreshing = true;
              });
              await DataManager().refreshDatabase();
              setState(() {
                _isRefreshing = false;
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
        title: Text('Diamonds in Stock'),
      ),
      body: _isRefreshing
          ? Center(
              child: LoadingAnimationWidget.stretchedDots(
                  color: AppColors.white2, size: 50))
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      // Dark blue
                      Colors.pink.withOpacity(0.90), AppColors.blue, // Pink
                    ],
                    radius: 0.5,
                    tileMode: TileMode.clamp,
                    // Adjust the radius as needed
                    center: Alignment
                        .centerRight, // Set the center of the gradient to top-left
                    stops: [0.2, 1.5],
                    focal: Alignment.centerRight, // Set stops for colors
                  ),
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text("Diamonds By its Type",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white2)),
                      ],
                    ),
                    Container(
                      child: CarouselSlider.builder(
                          itemCount: 2,
                          itemBuilder: (context, index, realIndex) {
                            final type = index == 0 ? 'CVD' : 'Natrual';
                            return Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    // Dark blue

                                    Colors.pink.withOpacity(0.90),
                                    AppColors.white.withOpacity(0.90),
                                    // Pink
                                  ],
                                  radius: 1.5,
                                  tileMode: TileMode.clamp,
                                  // Adjust the radius as needed
                                  center: Alignment
                                      .centerRight, // Set the center of the gradient to top-left
                                  stops: [0.5, 0.5],
                                  focal: Alignment
                                      .centerRight, // Set stops for colors
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(8.0),
                              width: 600,
                              child: GestureDetector(
                                onTap: () async {
                                  final cvdDiamonds = await DatabaseHelper()
                                      .getDiamondsByType(type);
                                  Get.to(() => DiamondDetailsPage(
                                      diamonds: cvdDiamonds));
                                },
                                child: DiamondTypeGridItem(type: type),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 164,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          )),
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // Shape: HT
                          GestureDetector(
                            onTap: () async {
                              final cvdDiamonds = await DatabaseHelper()
                                  .getDiamondsByType('CVD');
                              Get.to(() =>
                                  DiamondDetailsPage(diamonds: cvdDiamonds));
                            },
                            child: DiamondTypeGridItem(type: 'CVD'),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final cvdDiamonds = await DatabaseHelper()
                                  .getDiamondsByType('Natrual');
                              Get.to(() =>
                                  DiamondDetailsPage(diamonds: cvdDiamonds));
                            },
                            child: DiamondTypeGridItem(type: 'Natrual'),
                          ),
                        ]),
                    // Button to show CVD diamonds

                    Text("Diamonds By its Color",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white2)),
                    // GridView for different diamond shapes
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        // Shape: HT
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('D');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'D'),
                        ),

                        // Add other shapes similarly
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('E');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'E'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('F');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'F'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('G');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'G'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('H');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'H'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('I');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'I'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('J');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'J'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('K');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'K'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('L');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'L'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByColor('M');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondColorGridItem(color: 'M'),
                        ), // Add more shapes...
                      ],
                    ),
                    Text("Diamonds By its Clarities",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white2)),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        // Shape: HT
                        GestureDetector(
                          onTap: () async {
                            final diamonds = await DatabaseHelper()
                                .getDiamondsByClarity('Vs1');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondclarityGridItem(clarity: 'Vs1'),
                        ),

                        // Add other shapes similarly
                        GestureDetector(
                          onTap: () async {
                            final diamonds = await DatabaseHelper()
                                .getDiamondsByClarity('Vvs2');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondclarityGridItem(clarity: 'Vvs2'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds = await DatabaseHelper()
                                .getDiamondsByShape('Vs2');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondclarityGridItem(clarity: 'Vs2'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds = await DatabaseHelper()
                                .getDiamondsByShape('Si1');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondclarityGridItem(clarity: 'Si1'),
                        ),
                        // Add more Clarity...
                      ],
                    ),
                    Text("Diamonds By its Shape",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white2)),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        // Shape: HT
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByShape('HT');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'HT'),
                        ),

                        // Add other shapes similarly
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByShape('OV');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'OV'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds = await DatabaseHelper()
                                .getDiamondsByShape('RAD');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'RAD'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds = await DatabaseHelper()
                                .getDiamondsByShape('PEAR');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'PEAR'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByShape('EM');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'EM'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByShape('PR');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'PR'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByShape('MQ');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'MQ'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds = await DatabaseHelper()
                                .getDiamondsByShape('CMB');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'CMB'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByShape('AC');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'AC'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final diamonds =
                                await DatabaseHelper().getDiamondsByShape('RD');
                            Get.to(
                                () => DiamondDetailsPage(diamonds: diamonds));
                          },
                          child: DiamondGridItem(shape: 'RD'),
                        ),
                        // Add more Clarity...
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class DiamondGridItem extends StatelessWidget {
  final String shape;

  DiamondGridItem({required this.shape});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            shape,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          FutureBuilder<int>(
            future: DatabaseHelper().getDiamondCountByShape(shape),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final count = snapshot.data ?? 0;
                return Text(
                  'Total: $count',
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class DiamondColorGridItem extends StatelessWidget {
  final String color;

  DiamondColorGridItem({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          focalRadius: 0.5,
          colors: [
            // Dark blue
            Color.fromARGB(255, 30, 111, 233).withOpacity(0.90),
            AppColors.white, // Pink
          ],
          radius: 0.5,
          transform: GradientRotation(3.14 / 2),
          // Adjust the radius as needed
          center: Alignment
              .centerRight, // Set the center of the gradient to top-left
          stops: [0.2, 1.5],
          focal: Alignment.centerRight, // Set stops for colors
        ),
        //color: AppColors.primaryAppColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            color,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white2),
          ),
          SizedBox(height: 8),
          FutureBuilder<int>(
            future: DatabaseHelper().getDiamondCountByColor(color),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: LoadingAnimationWidget.waveDots(
                      color: Colors.white, size: 50),
                );
              } else {
                final count = snapshot.data ?? 0;
                return Text(
                  'Total: $count',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.white2),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class DiamondTypeGridItem extends StatelessWidget {
  final String type;

  DiamondTypeGridItem({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          focalRadius: 0.5,
          colors: [
            // Dark blue
            AppColors.primaryAppColor.withOpacity(0.90),
            AppColors.white, // Pink
          ],
          radius: 0.5,
          transform: GradientRotation(3.14 / 2),
          // Adjust the radius as needed
          center: Alignment
              .centerRight, // Set the center of the gradient to top-left
          stops: [0.2, 1.5],
          focal: Alignment.centerRight, // Set stops for colors
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white2),
          ),
          SizedBox(height: 8),
          FutureBuilder<int>(
            future: DatabaseHelper().getDiamondCountByType(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final count = snapshot.data ?? 0;
                return Text(
                  'Total: $count',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.white2),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class DiamondclarityGridItem extends StatelessWidget {
  final String clarity;

  DiamondclarityGridItem({required this.clarity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            clarity,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          FutureBuilder<int>(
            future: DatabaseHelper().getDiamondCountByClarity(clarity),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final count = snapshot.data ?? 0;
                return Text(
                  'Total: $count',
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
