import 'package:diamond_app/Provider/theme_changer.dart';
import 'package:diamond_app/screens/setting/drc_pro.dart';
import 'package:diamond_app/screens/setting/mobile_and_otp.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:diamond_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  bool _isPrice_10ct = false;
  bool _vibration = false;
  bool _open_keyboard = false;
  bool _share_currency = false;
  bool _isDarkTheme = false;
  //final themeChanger = Provider.of<ThemeChanger>(context);

  Widget _buildRadioListTile(
    ThemeMode value,
    String title,
  ) {
    var themeChanger = Provider.of<ThemeChanger>(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
      leading: Radio<ThemeMode>(
        value: value,
        groupValue: themeChanger.themeMode,
        onChanged: (newValue) {
          themeChanger.setTheme; // Pass the new value to setTheme
          setState(() {}); // Call setState to update the UI
        },
      ),
      onTap: () {
        themeChanger.setTheme; // Pass the new value to setTheme
        setState(() {}); // Call setState to update the UI
      },
    );
  }

  Widget _buildSwitchListTile(
    ThemeMode value,
    String title,
  ) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    ;
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
      value: themeChanger.themeMode == value,
      onChanged: (newValue) {
        if (newValue) {
          themeChanger.setTheme; // Pass the new value to setTheme
          setState(() {}); // Call setState to update the UI
        }
      },
    );
  }

  Widget build(BuildContext context) {
    ThemeMode value;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Theme(
      data: _isDarkTheme ? darkTheme : lightTheme,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: Icon(Icons.settings_outlined),
          title: Text('Settings'),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MobileAndOTP(),
                          ));
                    },
                    leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(Icons.person_pin,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer)),
                    title: Text(
                      'Login or SignUp',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    ),
                    subtitle: Text(
                      'Unlock More Features',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    ),
                    trailing: Icon(Icons.arrow_right_alt_rounded,
                        color:
                            Theme.of(context).colorScheme.secondaryContainer),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.workspace_premium_rounded,
                                color: AppColors.primaryAppColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Subscriptions',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => drc_pro(),
                              ));
                        },
                        title: Text(
                          'DRC Pro',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        subtitle: Text(
                          'Chechout the Pro Features',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Icon(Icons.arrow_right_alt_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.architecture_outlined,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Preferences',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _isPrice_10ct =
                                !_isPrice_10ct; // Toggle the selected state
                          });
                        },
                        title: Text(
                          'Price With 10Ct.',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        subtitle: Text(
                          'No Need to Re-update Price List After Changing This.',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Switch(
                          hoverColor: Theme.of(context).colorScheme.tertiary,
                          value: _isPrice_10ct,
                          onChanged: (newValue) {
                            setState(() {
                              _isPrice_10ct =
                                  newValue; // Update the selected state
                            });
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _vibration =
                                !_vibration; // Toggle the selected state
                          });
                        },
                        title: Text(
                          'Touch Vibration',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        subtitle: Text(
                          'Vibration Must Be Enabled in System Seetings.',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Switch(
                          value: _vibration,
                          onChanged: (newValue1) {
                            setState(() {
                              _vibration =
                                  newValue1; // Update the selected state
                            });
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _open_keyboard =
                                !_open_keyboard; // Toggle the selected state
                          });
                        },
                        title: Text(
                          'Auto open Keypad',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        subtitle: Text(
                          'Automatically open Keypad On App launch',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Switch(
                          value: _open_keyboard,
                          onChanged: (newValue2) {
                            setState(() {
                              _open_keyboard =
                                  newValue2; // Update the selected state
                            });
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _share_currency =
                                !_share_currency; // Toggle the selected state
                          });
                        },
                        title: Text(
                          'Share Currency',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        subtitle: Text(
                          'Include converted Total Price when sharing diamond',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Switch(
                          value: _share_currency,
                          onChanged: (newValue3) {
                            setState(() {
                              _share_currency =
                                  newValue3; // Update the selected state
                            });
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _isDarkTheme = !_isDarkTheme;
                            // Toggle the selected state
                          });
                        },
                        title: Text('Dark Theme',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer) // Use appropriate text style
                            ),
                        trailing: Switch(
                          value: _isDarkTheme,
                          onChanged: (value) {
                            setState(() {
                              _isDarkTheme = value; // Update the selected state
                            });
                          },
                        ),
                      ),
                      _buildSwitchListTile(
                        ThemeMode.light,
                        'Light Theme',
                      ),
                      _buildSwitchListTile(
                        ThemeMode.dark,
                        'Dark Theme',
                      ),
                      _buildSwitchListTile(
                        ThemeMode.system,
                        'System Theme',
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        groupValue: themeChanger.themeMode,
                        onChanged: (value) {
                          themeChanger.setTheme(ThemeData.light());
                        },
                        title: Text(
                          'Light Theme',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        groupValue: themeChanger.themeMode,
                        onChanged: (value) {
                          print(themeChanger.setTheme);
                          themeChanger.setTheme;
                          setState(() {
                            value = ThemeMode.dark;
                          });
                        },
                        title: Text(
                          'Dark Theme',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        groupValue: themeChanger.themeMode,
                        onChanged: (ThemeMode? value) {
                          themeChanger.setTheme;
                        },
                        title: Text(
                          'System Theme',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.miscellaneous_services_rounded,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'More Apps',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        thickness: 1,
                      ),
                      ListTile(
                        title: Text(
                          'DRC - Suppliers',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Text('Free',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer)),
                      ),
                      ListTile(
                        title: Text(
                          'Rough Diamond Calculator Lite',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Text('Free',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer)),
                      ),
                      ListTile(
                        title: Text(
                          'Rough Diamond Calculator',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Text('10.99',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer)),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.share,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Share',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        thickness: 1,
                      ),
                      ListTile(
                          leading: Image.asset(
                            'assests/diamond.png',
                            height: 20,
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'DRC',
                                  style: TextStyle(
                                    color: Colors
                                        .red, // Change color as per your requirement
                                    // Add any other styling properties you need
                                  ),
                                ),
                                TextSpan(
                                  text: ' - Suppliers',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                ),
                              ],
                            ),
                          )),
                      ListTile(
                          leading: Image.asset(
                            'assests/diamond.png',
                            height: 20,
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'RDC',
                                  style: TextStyle(
                                    color: Colors
                                        .blueAccent, // Change color as per your requirement
                                    // Add any other styling properties you need
                                  ),
                                ),
                                TextSpan(
                                  text: ' - Rough Diamond Calculator',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                ),
                              ],
                            ),
                          )),
                      ListTile(
                          leading: Image.asset(
                            'assests/diamond.png',
                            height: 20,
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'DRC',
                                  style: TextStyle(
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [Colors.red, Colors.yellow],
                                      ).createShader(Rect.fromLTWH(0, 0, 200,
                                          70)), // Adjust the dimensions as needed
                                    // Add any other styling properties you need
                                  ),
                                ),
                                TextSpan(
                                  text: ' - Diamond RapValue Calculator',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.live_help_outlined,
                                color: Colors.blue),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Help & Feedback',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () async {
                          String email = Uri.encodeComponent(
                            "arhamshare.flutter.2@gmail.com",
                          );
                          String subject = Uri.encodeComponent("");
                          String body = Uri.encodeComponent("");
                          print(subject);
                          Uri mail = Uri.parse(
                              "mailto:$email?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                            //email app opened
                          } else {
                            //email app is not opened
                          }
                        },
                        leading: Icon(Icons.email, color: Colors.red),
                        title: Text('Email',
                            style: TextStyle(
                                fontFamily: 'Gotham', color: Colors.red)),
                        trailing: Text('arhamshare.flutter.2@gmail.com'),
                      ),
                      ListTile(
                        onTap: () async {},
                        leading: Icon(Icons.telegram, color: Colors.blue),
                        title: Text('Telegram',
                            style: TextStyle(
                                fontFamily: 'Gotham', color: Colors.blue)),
                        trailing: Text('@deepss1'),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.sticky_note_2, color: Colors.blueAccent),
                        title: Text('Skype',
                            style: TextStyle(
                                fontFamily: 'Gotham',
                                color: Colors.blueAccent)),
                        trailing: Text('@deepss121'),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          String url =
                              "https://www.arhamshare.com"; // Replace with your URL
                          bool launched = await launchInChrome(url);
                          if (!launched) {
                            // If Chrome wasn't launched, fallback to the default launcher
                            await launch(url);
                          }
                        },
                        leading: Icon(
                          Icons.compass_calibration,
                          color: Colors.amber,
                        ),
                        title: Text(
                          'By AnvTech',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Icon(Icons.ios_share_outlined),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: Colors.green,
                        ),
                        title: Text(
                          'Privacy & Policy',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text(
                          'App Version',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        trailing: Text('V1.0.1'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> launchInChrome(String url) async {
    // Specify Chrome package name
    const chromePackageName = 'com.android.chrome';
    try {
      bool launched = await launch(
        url,
        // Specify Chrome's package name
        forceSafariVC: false,
        forceWebView: false,
        // Specify Chrome's package name
        // If not specified, the function tries to open the URL in Chrome
        // and falls back to the default browser if it's not installed
        // androidPackageName: chromePackageName,
      );
      return launched;
    } catch (e) {
      // Error handling
      return false;
    }
  }
}
