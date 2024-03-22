import 'package:diamond_app/screens/Authentication/Api%20Services/auth_api_service.dart';
import 'package:diamond_app/screens/Authentication/login_screen.dart';
import 'package:diamond_app/screens/certificates/certificate_generate_screen.dart';
import 'package:diamond_app/screens/home_screen.dart';
import 'package:diamond_app/screens/profile_screen.dart';
import 'package:diamond_app/screens/setting/settings_page.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DrawerMenuScreen extends StatefulWidget {
  const DrawerMenuScreen({Key? key}) : super(key: key);

  @override
  State<DrawerMenuScreen> createState() => _DrawerMenuScreenState();
}

class _DrawerMenuScreenState extends State<DrawerMenuScreen> {
  bool isActive = false;
  int selectedItemIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
        child: AnimatedContainer(
          padding: EdgeInsets.all(10),
          duration: const Duration(milliseconds: 300),
          child: ListView(
            children: [
              _buildListItem('Calculator', 0),    // 
              //_buildListItem('Marketplace', 1),
              //_buildListItem('Account', 2),
              _buildListItem('Certificate Generate', 3),
              _buildListItem('Refresh', 4),
              _buildListItem('Settings', 5),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
              ),
              // ListTile(
              //   title: Text('Logout', style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     try {
              //       AuthService.logout();
              //     } catch (e) {
              //       print(e);
              //     }
              //     AuthService.logout();
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => LoginScreen()));
              //   },
              // ),
              Text(" Version 1.0.0",
                  style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5))),
              Text("© 2024 Diamond App",
                  style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5))),
              Text(
                " Powered By ANVTECH, All rights  reserved",
                style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Stack(
        children: [
          if (selectedItemIndex == index)
            Positioned(
              height: 56,
              left: 0,
              width: isActive ? 288 : 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ListTile(
            hoverColor: AppColors.blue,
            title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer)),
            onTap: () {
              setState(() {                
                isActive = true;
                selectedItemIndex = index;
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }
                if (index == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                }
                if (index == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                }
                if (index == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CertificateGeneratePage()));
                }
                if (index == 4) {


                  
                  RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 3));
                    },
                    child: FutureBuilder<void>(
                      future: fetchDataAndStore(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          return CircularProgressIndicator();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  );
                  
                }
                if (index == 5) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => loginscreen()));
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
