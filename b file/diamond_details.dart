import 'package:diamond_app/database/stock_database.dart';
import 'package:diamond_app/screens/view_more_details.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class DiamondDetailsPage extends StatelessWidget {
  final List<DiamondData> diamonds;

  DiamondDetailsPage({required this.diamonds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text('Diamond Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.9,
            crossAxisCount: 1,
            mainAxisSpacing: 18.0,
            crossAxisSpacing: 18.0,
          ),
          itemCount: diamonds.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle tap event, maybe navigate to a detailed view
                // of the diamond.
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primaryAppColor.withOpacity(0.20))
                  ],
                  color: AppColors.primaryAppColor.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display diamond details here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SNo: ${diamonds[index].stockNum}',
                          style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                        ),
                        InkWell(
                          onTap: () {
                            () => launch(
                                'https://www.gia.edu/report-check?reportno=${diamonds[index].certNum}');
                            // Handle button press event
                          },
                          child: Text(
                            'Cert No: ${diamonds[index].certNum}',
                            style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    // Display other details similarly
                    // ...
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: AppColors.primaryAppColor)
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(diamonds[index].imageUrl ?? '',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Size: ${diamonds[index].size}',
                              style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                            ),
                            Text(
                              'Color: ${diamonds[index].color}',
                              style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                            ),
                            Text(
                              'Rap Price: ${diamonds[index].rapPrice}',
                              style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shape: ${diamonds[index].shape}',
                              style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                            ),
                            Text(
                              'Clarity: ${diamonds[index].clarity}',
                              style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => ViewDiamondDetailsPage(
                                  diamond: diamonds[index]));
                            },
                            child: Text('View More'),
                          ),
                        ),
                        Text(
                          '${diamonds[index].availability}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

