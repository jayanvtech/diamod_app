import 'dart:async';
import 'dart:convert';
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
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => fetchData());
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

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedSpotRates.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10)),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shadowColor: Colors.transparent,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 1, 10, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select Currency",
                              style: TextStyle(
                                  color: Colors.blue,
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
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.blue,
                              ),
                              items: spotRates.map<DropdownMenuItem<String>>(
                                  (SpotRate spot) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedSpotRates[0].name),
                                  Row(
                                    children: [
                                      Text("Last Updated: "),

                                      // Text(lastUpdated.toLocal().toString().characters.take(5).toString(),
                                      Text(selectedSpotRates[0]
                                          .time
                                          . //toString().characters.take(5).toString(),
                                          substring(11, 19)),
                                      // Text(
                                      //   DateFormat.Hms().format(DateTime.now()),
                                      // )
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("Price: "),
                                      Text(selectedSpotRates[0].ltp),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Change: "),
                                      Text(selectedSpotRates[0].chg)
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
            ),
          SizedBox(height: 20),
          if (errorMessage != null)
            SizedBox(
              height: 20,
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
