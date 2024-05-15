import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/View/Mobile-Files/login_screen.dart';
import 'package:shopee_app/View/Mobile-Files/navigation_station.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    String userId = box.read('userId') ?? '0';
    String googleId = box.read('googleId') ?? '0';
    return userId != '0' || googleId != '0'
        ? const NavigationStation()
        : const LoginScreen();
  }
}
