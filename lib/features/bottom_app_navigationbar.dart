// ignore_for_file: unused_field, unused_element

import 'package:diamond_app/screens/certificate_generate_screen.dart';
import 'package:diamond_app/screens/home_screen.dart';
import 'package:diamond_app/screens/stock_management.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.description),
      title: ("Certificate"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.diamond),
      title: ("Stock"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.settings),
      title: ("Settings"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}

PersistentTabController _controller = PersistentTabController();

PersistentTabView _buildBottomNavigationScreens(context) {
  return PersistentTabView(
    context,
    controller: _controller,
    screens: [
      HomeScreen(),
      CertificateGeneratePage(),
      StockManagementScreen(),
      CertificateGeneratePage(),
    ],
    items: _navBarsItems(),
    confineInSafeArea: true,
    backgroundColor: Colors.white,
    handleAndroidBackButtonPress: true,
    resizeToAvoidBottomInset: true,
    stateManagement: true,
    hideNavigationBarWhenKeyboardShows: true,
    decoration: NavBarDecoration(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    CertificateGeneratePage(),
    StockManagementScreen(),
    CertificateGeneratePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: AppColors.primaryAppColor,
        useMaterial3: true,
      ),
      home: PersistentTabView(
        neumorphicProperties: NeumorphicProperties(
          curveType: CurveType.convex,
        ),
        context,
        controller: _controller,
        screens: [
          HomeScreen(),
          CertificateGeneratePage(),
          StockManagementScreen(),
          CertificateGeneratePage(),
        ],
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: AppColors.primaryAppColor.withOpacity(0.10),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
