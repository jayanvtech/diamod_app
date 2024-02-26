import 'package:diamond_app/database/stock_database.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ViewDiamondDetailsPage extends StatelessWidget {
  final DiamondData diamond;

  ViewDiamondDetailsPage({required this.diamond});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(diamond.comments ?? '');
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        foregroundColor: AppColors.white2,
        backgroundColor: AppColors.blue,
        title: Text('${diamond.stockNum}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryAppColor.withOpacity(0.20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: Container(
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height / 2.8,
                        child: InAppWebView(
                          initialUrlRequest:
                              URLRequest(url: WebUri(diamond.comments ?? '')),
                        ),
                      ),
                    )),
                Container(),
                // Container(
                //   child: Image.network(
                //     diamond.videoUrl ?? '',
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Shape: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white2),
                              ),
                              Text(
                                '${diamond.shape}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Size: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white2),
                              ),
                              Text(
                                '${diamond.size}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Color: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white2),
                              ),
                              Text(
                                '${diamond.color}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Clarity: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white2),
                              ),
                              Text(
                                '${diamond.clarity}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Cut: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white2),
                              ),
                              Text(
                                '${diamond.cut}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Polish: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white2),
                              ),
                              Text(
                                '${diamond.polish}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Diamond Gridle',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white2)),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Girdle Condition: ${diamond.girdleCondition}',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.white2),
                          ),
                          Text(
                            'Girdle Min: ${diamond.girdleMin}',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.white2),
                          ),
                          Text(
                            'Girdle Percantage: ${diamond.girdlePercent}',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.white2),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Diamond Intensity',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white2)),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Fluor Intensity: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.white2),
                              ),
                              Text(
                                ' ${diamond.fluorIntensity}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('Diamond PriceList',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white2)),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rap Price: ${diamond.rapPrice}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                              Text(
                                'Price Per Carat: ${diamond.pricePerCara}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                              Text(
                                'Total Sales Price: ${diamond.totalSalesPrice}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                              Text(
                                'Depth Percent: ${diamond.depthPercent}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                              Text(
                                'Table Percent: ${diamond.tablePercent}',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.white2),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
