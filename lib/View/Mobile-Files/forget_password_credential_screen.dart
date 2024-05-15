import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopee_app/Controller/authentication_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
  );
  final authControllerInjector = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GetX<AuthController>(
      builder: (controller) {
        return authControllerInjector.forgetPasswordStep1Indicator.value == true
            ? Scaffold(
                body: Center(
                  child: Image.asset(
                    'assets/images/loadingGif.gif',
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Check User Status',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 13),
                  ),
                  centerTitle: true,
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Text(
                            'For security reasons we need to verify its you before resetting the password,please enter below your email',
                            style: TextStyle(
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth / 23,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'email address cannot be empty';
                                    }
                                    if (!_emailRegex
                                        .hasMatch(value.toString())) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    label: Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: screenWidth / 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    suffixIcon: const Icon(Icons.email),
                                    suffixIconColor: Colors.blue,
                                    hintText: 'Enter your email..',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.05,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.055,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        authControllerInjector
                                            .forgetPasswordStep1(
                                                emailController.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    child: Text(
                                      'Check  ',
                                      style: TextStyle(
                                          fontSize: screenWidth / 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
