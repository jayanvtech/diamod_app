import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
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
        decoration: BoxDecoration(color: AppColors.blue),
        child: ListView(
          children: [
            _buildListItem('Home', 0),
            _buildListItem('Marketplace', 1),
            _buildListItem('Account', 2),
            _buildListItem('Certificate Generate', 3),
            _buildListItem('Refresh', 4),
            _buildListItem('Settings', 5),
          ],
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
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ListTile(
            hoverColor: AppColors.blue,
            title: Text(title, style: TextStyle(color: Colors.white)),
            onTap: () {
              setState(() {
                isActive = true;
                selectedItemIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
