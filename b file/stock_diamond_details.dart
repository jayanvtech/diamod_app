import 'package:diamond_app/database/stock_database.dart';
import 'package:diamond_app/screens/view_more_details.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class DiamondDetailsPage extends StatefulWidget {
  final List<DiamondData> diamonds;

  DiamondDetailsPage({required this.diamonds});

  @override
  _DiamondDetailsPageState createState() => _DiamondDetailsPageState();
}

class _DiamondDetailsPageState extends State<DiamondDetailsPage> {
  // Define filter options and selected options lists
  List<String> shapeFilters = [
    'HT',
    'OV',
    'RAD',
    'PEAR',
    'EM',
    'PR',
    'MQ',
    'CMB',
    'AC',
    'RD'
  ];
  List<String> clarityFilters = ['Vs1', 'si1', 'Vvs2'];
  List<String> colorFilters = ['D', 'E', 'F', 'G', 'H', 'I'];
  List<String> sizeFilters = ['<1', '1-2', '2-4', '4+'];

  List<String> selectedShapes = [];
  List<String> selectedClarities = [];
  List<String> selectedColors = [];
  List<String> selectedSizes = [];

  @override
  Widget build(BuildContext context) {
    // Filter diamonds based on selected options
    List<DiamondData> filteredDiamonds = filterDiamonds();

    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white2,
        title: Text('Diamond Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              // Show filter options when filter button is pressed
              showFilterOptions(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: filteredDiamonds.isEmpty
            ? Center(
                child: Text(
                  'No diamonds found.',
                  style: TextStyle(
                    color: AppColors.white2,
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: filteredDiamonds.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle tap event
                    },
                    child: buildDiamondContainer(filteredDiamonds[index]),
                  );
                },
              ),
        // : GridView.builder(
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       childAspectRatio: 1 / 1.109,
        //       crossAxisCount: 1,
        //       mainAxisSpacing: 18.0,
        //       crossAxisSpacing: 18.0,
        //     ),
        //     itemCount:
        //         filteredDiamonds.length, // Use filtered diamonds count
        //     itemBuilder: (context, index) {
        //       return GestureDetector(
        //         onTap: () {
        //           // Handle tap event
        //         },
        //         child: buildDiamondContainer(filteredDiamonds[index]),
        //       );
        //     },
        //   ),
      ),
    );
  }

  // Method to build diamond container
  Widget buildDiamondContainer(DiamondData diamond) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAppColor.withOpacity(0.20),
          ),
        ],
        color: AppColors.primaryAppColor.withOpacity(0.20),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SNo: ${diamond.stockNum}',
                style: TextStyle(color: AppColors.white2),
              ),
              InkWell(
                onTap: () {
                  launchUrl(Uri.parse("${diamond.certUrl}"));
                  // Handle button press event
                },
                child: Text(
                  'Cert No: ${diamond.certNum}',
                  style: TextStyle(color: AppColors.white2),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.primaryAppColor)],
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 200,
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assests/imagenotfound.png',
                      color: AppColors.black,
                      width: 180,
                      height: 180,
                    );
                  },
                  diamond.imageUrl ?? "assests/imagenotfound.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Size: ${diamond.size}',
                style: TextStyle(color: AppColors.white2),
              ),
              Text(
                'Color: ${diamond.color}',
                style: TextStyle(color: AppColors.white2),
              ),
              Text(
                'Rap Price: ${diamond.rapPrice}',
                style: TextStyle(color: AppColors.white2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shape: ${diamond.shape}',
                style: TextStyle(color: AppColors.white2),
              ),
              Text(
                'Clarity: ${diamond.clarity}',
                style: TextStyle(color: AppColors.white2),
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
                    Get.to(() => ViewDiamondDetailsPage(diamond: diamond));
                  },
                  child: Text('View More'),
                ),
              ),
              Text(
                '${diamond.availability}',
                style: TextStyle(
                  color: AppColors.white2,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to show filter options
  void showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filters'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFilterOptions('Shape', shapeFilters, selectedShapes),
                buildFilterOptions(
                    'Clarity', clarityFilters, selectedClarities),
                buildFilterOptions('Color', colorFilters, selectedColors),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  // Apply filter and close dialog
                  Navigator.of(context).pop();
                });
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  // Method to build filter options
  Widget buildFilterOptions(
      String title, List<String> options, List<String> selectedOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: selectedOptions.contains(option),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                });
              },
              selectedColor:
                  Colors.green, // Add this line to change color when selected
              checkmarkColor:
                  Colors.white, // Add this line to change checkmark color
              labelStyle: TextStyle(
                color: selectedOptions.contains(option)
                    ? Colors.white
                    : Colors
                        .black, // Add this line to change text color based on selection
              ),
              backgroundColor: selectedOptions.contains(option)
                  ? Colors.blue
                  : Colors
                      .grey, // Add this line to change background color based on selection
            );
          }).toList(),
        ),
      ],
    );
  }

  // Method to filter diamonds based on selected options
  List<DiamondData> filterDiamonds() {
    // If no filters are selected, return all diamonds
    if (selectedShapes.isEmpty &&
        selectedClarities.isEmpty &&
        selectedColors.isEmpty &&
        selectedSizes.isEmpty) {
      return widget.diamonds;
    }

    // Otherwise, filter diamonds based on selected options
    return widget.diamonds.where((diamond) {
      return (selectedShapes.isEmpty ||
              selectedShapes.contains(diamond.shape)) &&
          (selectedClarities.isEmpty ||
              selectedClarities.contains(diamond.clarity)) &&
          (selectedColors.isEmpty || selectedColors.contains(diamond.color)) &&
          (selectedSizes.isEmpty || selectedSizes.contains(diamond.size));
    }).toList();
  }
}
