import 'package:diamond_app/database/stock_database.dart';
import 'package:diamond_app/screens/view_more_details.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  List<String> clarityFilters = ['Vs1', 'Si1', 'Vs2', 'Vvs2'];
  List<String> colorFilters = ['D', 'E', 'F', 'G', 'H', 'I'];
  List<String> sizeFilters = ['<1', '1-2', '2-4', '4+'];
  int height = 0;
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
            : AnimationLimiter(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 0.66,
                    crossAxisCount: 1,
                    mainAxisSpacing: 18.0,
                    crossAxisSpacing: 18.0,
                  ),
                  itemCount:
                      filteredDiamonds.length, // Use filtered diamonds count
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 1000),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              print(
                                MediaQuery.of(context).size.height,
                              ); // Handle tap event
                            },
                            child:
                                buildDiamondContainer(filteredDiamonds[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  // Method to build diamond container
  Widget buildDiamondContainer(DiamondData diamond) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: AppColors.primaryAppColor),
        ],
        color: AppColors.white,
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
              // SwitchApp()
              // SwitchExample()
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: AppColors.primaryAppColor)],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 100,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                            child: LoadingAnimationWidget.stretchedDots(
                          color: AppColors.white2,
                          size: 20,
                        ));
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        height: 100,
                        scale: 2,
                        'assests/imagenotfound.png',
                        color: AppColors.white2,
                      );
                    },
                    diamond.imageUrl ?? "assests/imagenotfound.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Text(
                        'Rap Price: ${diamond.rapPrice}',
                        style: TextStyle(
                            color: AppColors.white2,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10.0),
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
              //add to cart

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
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.blue,
              title: Text(
                'Filters',
                style: TextStyle(color: AppColors.white2),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFilterOptions(
                        'Shape', shapeFilters, selectedShapes, setState),
                    buildFilterOptions(
                        'Clarity', clarityFilters, selectedClarities, setState),
                    buildFilterOptions(
                        'Color', colorFilters, selectedColors, setState),
                    buildFilterOptions(
                      'Size',
                      sizeFilters,
                      selectedSizes,
                      setState,
                    ),
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
          });
        });
  }

  // Method to build filter options
  Widget buildFilterOptions(String title, List<String> options,
      List<String> selectedOptions, setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: AppColors.white2)),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: selectedOptions.contains(option),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {super.setState(() {
                    selectedOptions.add(option);
                  });       
                    
                  } else {
                    super.setState(() {
                    selectedOptions.remove(option);
                    });
                    //selectedOptions.remove(option);
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
                  : AppColors.white2,
              // Add this line to change background color based on selection
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

class SwitchApp extends StatelessWidget {
  const SwitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Switch Sample')),
        body: SwitchExample(),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }
        // Otherwise return null to set default track color
        // for remaining states such as when the switch is
        // hovered, focused, or disabled.
        return null;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );

    return Switch(
      // This bool value toggles the switch.
      value: light,
      overlayColor: overlayColor,
      trackColor: trackColor,
      thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
      onChanged: (bool value) {},
    );
  }
}
// This is called when the user toggles the switch.
