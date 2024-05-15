import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shopee_app/View/Mobile-Files/login_screen.dart';
import 'package:shopee_app/View/Mobile-Files/navigation_station.dart';
import 'package:shopee_app/View/Mobile-Files/otp_verification_screen.dart';
import 'package:shopee_app/View/Mobile-Files/reset_password_screen.dart';
import 'package:shopee_app/main.dart';

class AuthController extends GetxController {
  RxBool loginLoadingIndicator = false.obs;
  RxBool signUpStep1Indicator = false.obs;
  RxBool signUpStep2Indicator = false.obs;
  RxBool forgetPasswordStep1Indicator = false.obs;
  RxBool forgetPasswordStep2Indicator = false.obs;

  late String otpCode;
  GetStorage box = GetStorage();
  userLogin(String email, String password) async {
    loginLoadingIndicator.value = true;
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/log_in.php';
    final request = await http.post(
      Uri.parse(url),
      body: {
        'user_email': email,
        'user_password': password,
      },
    );

    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);
      if (response['userExist'] == true) {
        box.write('userId', response['userData']['user_id']);
        box.write('userName', response['userData']['user_name']);
        box.write('userEmail', email);
        loginLoadingIndicator.value = false;
        Get.offAll(() => const NavigationStation());
      } else if (response['userExist'] == false) {
        loginLoadingIndicator.value = false;
        Get.defaultDialog(
            middleText: 'Try to register',
            middleTextStyle: const TextStyle(fontSize: 19),
            title: 'User not found or  your email & passcode are incorrect.',
            titleStyle: const TextStyle(fontWeight: FontWeight.bold));
      }
    }
  }

  signUpStep1(
      String username, String email, String number, String password) async {
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/register1.php';
    signUpStep1Indicator.value = true;
    final request = await http.post(
      Uri.parse(url),
      body: {'user_email': email, 'user_name': username},
    );
    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);

      if (response['userExist'] == true) {
        signUpStep1Indicator.value = false;
        Get.defaultDialog(
            middleText: 'Try to login.',
            middleTextStyle: const TextStyle(fontSize: 19),
            title: 'User already exist.',
            titleStyle: const TextStyle(fontWeight: FontWeight.bold));
      } else {
        otpCode = response['otp'].toString();
        signUpStep1Indicator.value = false;
        Get.to(() => OtpVerificationScreen(username, email, number, password));
      }
    }
  }

  signUpStep2(
      String username, String email, String number, String password) async {
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/register2.php';
    signUpStep2Indicator.value = true;
    var request = await http.post(
      Uri.parse(url),
      body: {
        'user_name': username,
        'user_email': email,
        'user_password': password,
        'user_number': number,
      },
    );
    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);
      if (response['status'] == 'success') {
        box.write('userName', username);
        box.write('userEmail', email);
        box.write('userId', response['userData']['user_id']);
        signUpStep2Indicator.value = false;
        Get.offAll(() => const NavigationStation());
      }
    }
  }

  forgetPasswordStep1(String email) async {
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/forget_password_step1.php';
    forgetPasswordStep1Indicator.value = true;
    var request = await http.post(Uri.parse(url), body: {'user_email': email});
    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);
      if (response['status'] == 'true') {
        forgetPasswordStep1Indicator.value = false;
        Get.to(() => ResetPasswordScreen(email));
      } else {
        forgetPasswordStep1Indicator.value = false;
        Get.defaultDialog(
            middleText: ' try to register.',
            middleTextStyle: const TextStyle(fontSize: 19),
            title: 'Email doesnt exist',
            titleStyle: const TextStyle(fontWeight: FontWeight.bold));
      }
    }
  }

  forgetPasswordStep2(String password, String email) async {
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/forget_password_step2.php';
    forgetPasswordStep2Indicator.value = true;
    var request = await http.post(
      Uri.parse(url),
      body: {'user_password': password, 'user_email': email},
    );
    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);

      if (response['status'] == 'updated') {
        forgetPasswordStep2Indicator.value = false;
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  Future<void> loginWithGoogle() async {
    final user = await googleSignIn.signIn();
    if (user == null) {
      return;
    } else {
      box.write('googleId', user.id);
      box.write('googleEmailAddress', user.email);
      Get.offAll(() => const NavigationStation());
    }
  }

  logOutFunction() async {
    if (box.read('userId') != null && box.read('googleId') == null) {
      box.remove('userId');
      box.remove('userEmail');
      print('normal sign in');
    } else if (box.read('googleId') != null && box.read('userId') == null) {
      await googleSignIn.signOut();
      box.remove('googleId');
      box.remove('googleEmailAddress');
      print('google sign in');
    } else if (box.read('userId') != null && box.read('googleId') != null) {
      box.remove('userId');
      box.remove('userEmail');
      box.remove('googleId');
      box.remove('googleEmailAddress');
      print('both userId and googleId are deleted');
    }
    Get.offAll(() => const LoginScreen());
  }
}
