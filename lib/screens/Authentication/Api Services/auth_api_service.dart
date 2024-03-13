import 'package:diamond_app/screens/Authentication/signup_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Remove the authentication token
    Get.offAll(() => SignUpScreen());
    // Navigate the user to the login/signup screen
    print(prefs.getString('authToken'));
  }
}
