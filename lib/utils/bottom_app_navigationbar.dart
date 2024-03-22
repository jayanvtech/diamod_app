// ignore_for_file: unused_field, unused_element

import 'package:diamond_app/Provider/theme_changer.dart';
import 'package:diamond_app/screens/certificates/certificate_generate_screen.dart';
import 'package:diamond_app/screens/home_screen.dart';
import 'package:diamond_app/screens/setting/settings_page.dart';
import 'package:diamond_app/screens/stock_management.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:diamond_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.calculate),
      title: ("Calculator"),
      activeColorPrimary: Theme.of(context).colorScheme.primary,
      inactiveColorPrimary: Theme.of(context).colorScheme.secondaryContainer,
    ),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.description),
        title: ("Certificate"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondaryContainer),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.diamond),
        title: ("Stock"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondaryContainer),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondaryContainer),
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
      loginscreen(),
      // ProfileScreen(),
    ],
    items: _navBarsItems(context),
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
    loginscreen()
    //ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeChanger()),
        ],
        child: Builder(
          builder: (BuildContext context) {
            final themeChanger = Provider.of<ThemeChanger>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeChanger.themeMode,
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
                  loginscreen()
                  // ProfileScreen(),
                ],
                items: _navBarsItems(context),
                confineInSafeArea: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                handleAndroidBackButtonPress: true,
                resizeToAvoidBottomInset: true,
                stateManagement: true,
                screenTransitionAnimation: ScreenTransitionAnimation(
                  // animateTabTransition: true,
                  // curve: Curves.easeInOutCubicEmphasized,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle.style3,
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
          },
        ));
  }
}
