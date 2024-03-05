import 'package:diamond_app/main.dart';
import 'package:diamond_app/screens/Authentication/signup_screen.dart';
import 'package:diamond_app/screens/home_screen.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:diamond_app/utils/bottom_app_navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

  static checkAuthentication() async {
    final uri = Uri.parse("http://192.168.130.41:3013/v1/user/verify_user");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$authToken', // Add the authToken to the headers
    };
    print('Token checkauith: $authToken');
    try {
      http.Response response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        // User is authenticated
        bool isAuthenticated = await checkAuthentication();
        print(isAuthenticated);
        if (isAuthenticated) {
          Get.to(() => MyHomePage());
          print("Authenticated");
        } else {
          Get.to(() => LoginScreen());
          print("Not Authenticated");
        }
        return true;
      } else {
        // User is not authenticated
        return false;
      }
    } catch (error) {
      print('Error checking authentication: $error');
      return false;
    }
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    final uri = Uri.parse("http://192.168.130.41:3013/v1/user/login");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };
    Map<String, String> body = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    String requestBody = json.encode(body);

    try {
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        String authToken = responseData['data']['authToken'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success: ${responseData['message']}'),
          ),
        );

        // Save authToken to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken);
        print(authToken);
        print("success authtocken");
        // Verify authentication status
        bool isAuthenticated = await checkAuthentication();
        print(isAuthenticated);
        if (isAuthenticated) {
          Get.to(() => MyHomePage());
          print("Authenticated");
        } else {
          Get.to(() => LoginScreen());
          print("Not Authenticated");
        }
      } else {
        var errorJson = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error: ${response.statusCode} ${errorJson['message']}'),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: AppColors.white2,
        backgroundColor: AppColors.blue,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: AppColors.white2),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add more email validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  style: TextStyle(color: AppColors.white2),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add more password validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAppColor
                        // primary: AppColors.white2,
                        ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform login logic here
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        login();
                        DiamondProvider();
                        // Add your login logic here
                      }
                    },
                    child: Text('Login',
                        style: TextStyle(color: AppColors.white2)),
                  ),
                ),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    // Add forgot password logic here
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.white2),
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => SignUpScreen());
                        // Add sign up navigation logic here
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkAuthentication() async {
    final uri = Uri.parse("http://192.168.130.41:3013/v1/user/verify_user");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authToken': '$authToken', // Add the authToken to the headers
    };
    print('Token checkauith: $authToken');
    try {
      http.Response response =
          await http.post(uri, headers: headers, body: authToken);

      if (response.statusCode == 200) {
        // User is authenticated
        return true;
      } else {
        // User is not authenticated
        return false;
      }
    } catch (error) {
      print('Error checking authentication: $error');
      return false;
    }
  }
}
