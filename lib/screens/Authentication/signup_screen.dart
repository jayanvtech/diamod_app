import 'package:diamond_app/screens/Authentication/login_screen.dart';
import 'package:diamond_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordCheckController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  Future<void> signUp() async {
    final String apiUrl = 'http://192.168.130.41:3013/v1/user/signup';

    Map<String, String> userData = {
      'username': _usernameController.text,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'location': _locationController.text,
      'email': _emailController.text,
      'phone_no': _mobileController.text,
      'dob': _dobController.text,
      'password': _passwordController.text,
    };
    // Encode the data to JSON
    String requestBody = json.encode(userData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      // Check if the request is successful
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success: ${responseData['message']}'),
          ),
        );
        Get.to(() => LoginScreen());
        //print(responseData['message']);
        // Handle response data here
        print(responseData);
      } else {
        String errorMessage = response.body;
        Map<String, dynamic> errorJson = jsonDecode(errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ' +
                '${response.statusCode}' +
                ' ' '${errorJson['message']}'),
          ),
        );

        // Handle errors here
        // print('Request failed with status: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );

      print('Error making request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        foregroundColor: AppColors.white2,
        backgroundColor: AppColors.blue,
        title: Text('Sign Up'),
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
                  controller: _usernameController,
                  style: TextStyle(color: AppColors.white2),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    // Add more validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
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
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    // Add more email validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        style: TextStyle(color: AppColors.white2),
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }

                          // Add more validation logic here if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        style: TextStyle(color: AppColors.white2),
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          // Add more validation logic here if needed
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: AppColors.white2),
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
                TextFormField(
                  controller: _passwordCheckController,
                  style: TextStyle(color: AppColors.white2),
                  decoration: InputDecoration(
                    labelText: 'Re-enter Password',
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please re-enter your password';
                    }
                    // Add more validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _mobileController,
                  style: TextStyle(color: AppColors.white2),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    // Add more validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _locationController,
                  style: TextStyle(color: AppColors.white2),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your location';
                    }
                    // Add more validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _dobController,
                  style: TextStyle(color: AppColors.white2),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    // Add more validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAppColor,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform sign up logic here
                        signUp();
                      }
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: AppColors.white2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Alredy Have have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => LoginScreen());
                        // Add sign up navigation logic here
                      },
                      child: Text(
                        'Sign In',
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
}
