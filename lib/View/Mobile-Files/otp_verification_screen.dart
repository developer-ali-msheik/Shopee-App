import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shopee_app/Controller/authentication_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen(
      this.username, this.email, this.number, this.password,
      {super.key});
  final String username;
  final String email;
  final String number;
  final String password;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final authControllerInjector = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetX<AuthController>(
      builder: (controller) {
        return authControllerInjector.signUpStep2Indicator.value == true
            ? Scaffold(
                body: Center(
                  child: Image.asset(
                    'assets/images/loadingGif.gif',
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    'Verify to continue',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 13),
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: screenWidth * 0.1),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.2,
                        ),
                        SizedBox(
                          width: screenWidth * 0.866,
                          child: OtpTextField(
                            enabledBorderColor: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                            focusedBorderColor: Colors.blue,
                            autoFocus: true,
                            fieldWidth: screenWidth * 0.11,
                            numberOfFields: 6,
                            showFieldAsBox: true,
                            onCodeChanged: (String code) {
                              // Handle validation or checks here
                            },
                            onSubmit: (String verificationCode) async {
                              if (authControllerInjector.otpCode ==
                                  verificationCode) {
                                authControllerInjector.signUpStep2(
                                    widget.username,
                                    widget.email,
                                    widget.number,
                                    widget.password);
                              } else {
                                Get.defaultDialog(
                                    title:
                                        'Otp code is incorrect ,check your inbox again.',
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
