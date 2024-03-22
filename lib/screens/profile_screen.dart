import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:diamond_app/screens/home_screen.dart';
import 'package:diamond_app/screens/setting/settings_page.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
              onPressed: () {
                // Get.to(() => loginscreen());
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Get.to(() => loginscreen());
              },
              icon: const Icon(Icons.settings))
        ],
        title: const Text('Profile'),
        backgroundColor: AppColors.blue,
      ),
      backgroundColor: AppColors.blue,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          child: Icon(
                            Icons.person,
                            color: AppColors.blue,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          'ANKIT KUMAR',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ankitkumar007@gmail.com',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              ' | ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              '+91 1234567890',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.blue),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.blue),
                                  ),
                                  child: Text(
                                    "Share Profile",
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CarouselSlider(
                        items: [
                          'My Stocks',
                          'My Certificates',
                          "Reports",
                          'Sold Diamond',
                          "Other"
                        ].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    '$i',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 100,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.5,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      title: Text(
                        'My Profile',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
