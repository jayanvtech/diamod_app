import 'dart:async';
import 'dart:convert';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

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

class SpotrateWidget extends StatefulWidget {
  @override
  _SpotrateWidgetState createState() => _SpotrateWidgetState();
}

class _SpotrateWidgetState extends State<SpotrateWidget> {
  late List<SpotRate> spotRates;
  late DateTime lastUpdated;
  late Timer timer;
  String? errorMessage;
  String selectedCurrency = 'USD/INR'; // Default currency selection

  @override
  void initState() {
    super.initState();
    spotRates = [];
    lastUpdated = DateTime.now();
    fetchData();

    // Set up a timer for automatic refresh every 60 seconds
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => fetchData());
    timer;
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.moneycontrol.com/mcapi/v1/currency/getCurrencyConverter'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('success') && data['success'] == 1) {
          final List<dynamic> spotRatesData = data['data']['spotRates'];

          spotRates = spotRatesData
              .map((spot) => SpotRate(
                    name: spot['name'],
                    ltp: spot['ltp'],
                    chg: spot['chg'],
                    time: spot['time'],
                  ))
              .toList();
        } else {}
      } else {
        SnackBar(
            content: Text(
                'Failed to fetch datass. Check your internet connection.'));
      }

      // Reset error message on successful fetch
      setState(() {
        errorMessage = null;
      });
    } catch (error) {
      // Handle other exceptions (e.g., network/internet issues)
      print('Error: $error');

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content: Container(
              padding: EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 218, 80, 71),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: const Text(
                'Failed to fetch data. Check your internet connection.',
                style: TextStyle(),
              ),
            )));
        // errorMessage =
        //     'Failed to fetch datasssssssss. Check your internet connection.';
      });
    } finally {
      // Update last updated time
      setState(() {
        lastUpdated = DateTime.now();
        // String formattedDate = DateFormat.yMMMEd().format(lastUpdated);
      });
    }
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SpotRate> selectedSpotRates =
        spotRates.where((spot) => spot.name == selectedCurrency).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryAppColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedSpotRates.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            " ",
                            style: TextStyle(
                                color: AppColors.primaryAppColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                          DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down),
                            borderRadius: BorderRadius.circular(16),
                            value: selectedCurrency,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCurrency = newValue!;
                              });
                            },
                            style: TextStyle(
                              color: AppColors.primaryAppColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: Container(
                              height: 2,
                              color: AppColors.primaryAppColor,
                            ),
                            items: spotRates
                                .map<DropdownMenuItem<String>>((SpotRate spot) {
                              return DropdownMenuItem<String>(
                                value: spot.name,
                                child: Text(
                                  spot.name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedSpotRates[0].name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Row(
                                  children: [
                                    Text(selectedSpotRates[0].ltp,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),

                                    // Text(lastUpdated.toLocal().toString().characters.take(5).toString(),
                                    // Text(selectedSpotRates[0]
                                    //     .time
                                    //     . //toString().characters.take(5).toString(),
                                    //     substring(11, 19)),
                                    // Text(
                                    //   DateFormat.Hms().format(DateTime.now()),
                                    // )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Last Changed: ",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      selectedSpotRates[0]
                                          .time
                                          .substring(11, 19),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(""),
                                    Text(
                                      selectedSpotRates[0].chg,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ListTile(
                      //   title: Text(selectedSpotRates[0].name),
                      //   subtitle: Text(
                      //       'Price: ${selectedSpotRates[0].ltp}, Change: ${selectedSpotRates[0].chg}'),
                      //   trailing:
                      //       Text('Updated: ${selectedSpotRates[0].time}'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          if (errorMessage != null)
            SizedBox(
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
