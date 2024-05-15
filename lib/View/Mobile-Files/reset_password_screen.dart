import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/authentication_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(this.email, {super.key});
  final String email;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
  );

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  GetStorage box = GetStorage();

  void togglePasswordVisibility1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void togglePasswordVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  final authControllerInjector = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GetX<AuthController>(
      builder: ((controller) {
        return authControllerInjector.forgetPasswordStep2Indicator.value == true
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
                    'Reset Password',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 13),
                  ),
                ),
                body: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              obscureText: _obscureText1,
                              controller: newPasswordController,
                              validator: (value) {
                                if (value == '') {
                                  return 'password cannot be empty';
                                }
                                if (!_passwordRegex
                                    .hasMatch(value.toString())) {
                                  return 'Please enter a valid password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                label: Text(
                                  'New Password',
                                  style: TextStyle(
                                      fontSize: screenWidth / 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                suffixIcon: IconButton(
                                  icon: _obscureText1
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  onPressed: togglePasswordVisibility1,
                                  color: Colors.blue,
                                ),
                                suffixIconColor: Colors.blue,
                                hintText: 'Enter your passord..',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                            TextFormField(
                              obscureText: _obscureText2,
                              controller: repeatPasswordController,
                              validator: (value) {
                                if (value == '') {
                                  return 'password cannot be empty';
                                }
                                if (repeatPasswordController.text !=
                                    newPasswordController.text) {
                                  return 'Password doesnt match try again !';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                label: Text(
                                  'Repeat Password',
                                  style: TextStyle(
                                      fontSize: screenWidth / 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                suffixIcon: IconButton(
                                  icon: _obscureText2
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  onPressed: togglePasswordVisibility2,
                                  color: Colors.blue,
                                ),
                                suffixIconColor: Colors.blue,
                                hintText: 'write again your password..',
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
                                    authControllerInjector.forgetPasswordStep2(
                                        newPasswordController.text,
                                        widget.email);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: Text(
                                  'Save',
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
              );
      }),
    );
  }
}
