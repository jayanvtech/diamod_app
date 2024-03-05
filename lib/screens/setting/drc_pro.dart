// import 'package:flutter/material.dart';

// class drc_pro extends StatefulWidget {
//   const drc_pro({super.key});

//   @override
//   State<drc_pro> createState() => _drc_proState();
// }

// class _drc_proState extends State<drc_pro> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('DRC Pro'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Card(
//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           'Developers Note',
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: ,
//                          icon: Icon(Icons.arrow_downward_sharp))

//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child: Card(
//                       color: Colors.amber.shade100,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('''Drc for android was launched back in Q2,2019 and has been available to all for no change.\n\nnow, as we plan to add more value with every updates, we are making the andorid version freemium starting December 2022.\n\nBy this one time payment,you will be supperting continued development and maintenance of DRC.\n\n\n-Team DRC''',style: TextStyle(fontFamily: 'Gotham'),),
//                       )),
//                   ),
//               //   ),
//                 ],
//               ),

//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class drc_pro extends StatefulWidget {
  const drc_pro({Key? key}) : super(key: key);

  @override
  State<drc_pro> createState() => _drc_proState();
}

class _drc_proState extends State<drc_pro> {
  bool isCardOpen = true;

  void toggleCard() {
    setState(() {
      isCardOpen = !isCardOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DRC Pro'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Developers Note',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: toggleCard,
                          icon: Icon(isCardOpen
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp),
                        ),
                      ],
                    ),
                    if (isCardOpen)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.amber.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '''Drc for android was launched back in Q2,2019 and has been available to all for no charge.\n\nnow, as we plan to add more value with every update, we are making the android version freemium starting December 2022.\n\nBy this one-time payment, you will be supporting continued development and maintenance of DRC.\n\n\n-Team DRC''',
                              style: TextStyle(fontFamily: 'Gotham'),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            ComparisonTable(),
            Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'DRC Pro',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.lightBlue.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Unlock All For 1 Hour by Watching An AD',
                              style: TextStyle(
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Please Note :',
                              style: TextStyle(
                                fontFamily: 'Gotham',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '> You can Unlock for longer By Watching more ads',
                              style: TextStyle(
                                fontFamily: 'Gotham',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '> get Additional 1 Hour When You click on the ad',
                              style: TextStyle(
                                fontFamily: 'Gotham',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '> This does not remove non-interrupting ads',
                              style: TextStyle(
                                fontFamily: 'Gotham',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black, // Background color
                                onPrimary: Colors.white, // Text/icon color
                              ),
                              icon: Icon(Icons.lock),
                              label: Text('Unlock Now'),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FixedColumnWidth(220), // Width of the Features column
                1: FlexColumnWidth(), // Width of the Free column
                2: FlexColumnWidth(), // Width of the Pro column
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.grey[300],
                        child: Center(child: Text('Availability')),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.grey[300],
                        child: Center(
                            child: Text(
                          'Free',
                          style: TextStyle(
                              color: Colors.amber, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.grey[300],
                        child: Center(
                            child: Text(
                          'Pro',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Calculator',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Gotham'),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Diomand Price List \n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Gotham'),
                            children: [
                              TextSpan(
                                text: 'Directly from Rapnet',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontFamily: 'Gotham'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Share Calculationt \n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Gotham'),
                            children: [
                              TextSpan(
                                text: 'as Text / Image',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontFamily: 'Gotham'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Create Reports \n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Gotham'),
                            children: [
                              TextSpan(
                                text: 'Quick Report / Save as a File',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontFamily: 'Gotham'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Adverstisements',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Gotham'),
                            children: [],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.cancel_sharp,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Exchanges Rates \n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Gotham'),
                            children: [
                              TextSpan(
                                text: '₹,€,A\$, AU\$',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontFamily: 'Gotham'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.lock,
                          size: 20,
                          color: Colors.red,
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Certificates \n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Gotham'),
                            children: [
                              TextSpan(
                                text:
                                    'Share and download GIA,HRD,IGI Certificates',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontFamily: 'Gotham'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.lock,
                          size: 20,
                          color: Colors.red,
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Cut Estimator',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Gotham'),
                            children: [],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.lock,
                          size: 20,
                          color: Colors.red,
                        )),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.lightBlue.shade100,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '₹699.00\nfor Lifetime',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Gotham', fontSize: 20),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 150,
                  height: 50,
                  child: Center(
                    child: Text(
                      'BUY NOW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
