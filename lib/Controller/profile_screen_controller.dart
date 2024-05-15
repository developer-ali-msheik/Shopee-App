import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shopee_app/View/Mobile-Files/login_screen.dart';
import 'package:shopee_app/View/Mobile-Files/register_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  RxBool editProfileLoader = false.obs;
  RxBool logOutLoader = false.obs;
  GetStorage box = GetStorage();

  updateEmail(String email, String password, String newEmail) async {
    editProfileLoader.value = true;
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/update_email.php';
    var request = await http.post(Uri.parse(url), body: {
      'userEmail': email,
      'userPassword': password,
      'newEmail': newEmail
    });
    if (request.statusCode == 200) {
      editProfileLoader.value = false;
      final response = jsonDecode(request.body);
      if (response['status'] == 'updated') {
        Get.snackbar('updated successfully', '');
        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(() => const LoginScreen());
      } else {
        editProfileLoader.value = false;
        AwesomeDialog(
          barrierColor: Colors.blue.shade100,
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.leftSlide,
          body: Text(
            'Error: Email Or Password Incorrect',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          btnCancelOnPress: () {
            Navigator.pop(Get.context!);
          },
          btnCancel: TextButton(
            onPressed: () {
              Navigator.pop(Get.context!);
            },
            child: const Text(
              'Back',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ).show();
      }
    }
  }

  updateName(String newName) async {
    editProfileLoader.value = true;
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/update_name.php';
    var request = await http.post(Uri.parse(url), body: {
      'userId': box.read('userId'),
      'newName': newName,
    });
    if (request.statusCode == 200) {
      editProfileLoader.value = false;
      Get.back();
    } else {
      editProfileLoader.value = false;
      AwesomeDialog(
        barrierColor: Colors.blue.shade100,
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.leftSlide,
        body: Text(
          'Unkown error occured try again later',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        btnCancelOnPress: () {
          Navigator.pop(Get.context!);
        },
        btnCancel: TextButton(
          onPressed: () {
            Navigator.pop(Get.context!);
          },
          child: const Text(
            'Back',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ).show();
    }
  }

  updatePassword(String email, String password, String newPassword) async {
    editProfileLoader.value = true;
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/update_password.php';
    var request = await http.post(Uri.parse(url), body: {
      'userEmail': email,
      'userPassword': password,
      'newPassword': newPassword
    });
    if (request.statusCode == 200) {
      editProfileLoader.value = false;
      final response = jsonDecode(request.body);
      if (response['status'] == 'updated') {
        Get.snackbar('updated successfully', '');
        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(() => const LoginScreen());
      } else {
        editProfileLoader.value = false;
        AwesomeDialog(
          barrierColor: Colors.blue.shade100,
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.leftSlide,
          body: Text(
            'Error: Email Or Password Incorrect',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          btnCancel: TextButton(
            onPressed: () {
              Navigator.pop(Get.context!);
            },
            child: const Text(
              'Back',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ).show();
      }
    }
  }

  deleteAccountForever(String userId) async {
    logOutLoader.value = true;
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/delete_account.php';
    var request = await http.post(
      Uri.parse(url),
      body: {'userId': userId},
    );
    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);

      if (response['status'] == 'success') {
        logOutLoader.value = false;
        box.remove('userId');
        Get.offAll(() => const RegisterScreen());
      } else {
        logOutLoader.value = false;
        AwesomeDialog(
          barrierColor: Colors.blue.shade100,
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.leftSlide,
          body: Text(
            'Unkown error occured try again later',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          btnCancel: TextButton(
            onPressed: () {
              Navigator.pop(Get.context!);
            },
            child: const Text(
              'Back',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ).show();
      }
    }
  }

  Future<void> launchWhatsapp() async {
    final Uri url = Uri.parse('https://wa.me/+96181642419');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchFacebook() async {
    final Uri url = Uri.parse('https://www.facebook.com/hoda.flity.1');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launcheInstagram() async {
    final Uri url = Uri.parse('https://www.instagram.com/ali_msheik_666');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
