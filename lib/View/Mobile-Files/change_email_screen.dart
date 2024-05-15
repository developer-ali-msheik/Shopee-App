import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final profileInjector = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newEmailController = TextEditingController();

  final _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
  );

  final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
  );
  TextAlign textAlign = TextAlign.center;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Column(
              children: [
                const ConstantTextWithAlign(
                    'For security measures we need to check that you are the owner of this account, please fill the form below, YOU will be directed to login again.',
                    17,
                    greyColors,
                    TextAlign.center,
                    FontWeight.bold),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ConstantText(
                        'Current Email Address',
                        17,
                        FontWeight.bold,
                        blueColor,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (!_emailRegex.hasMatch(value.toString())) {
                            return 'Please enter your email';
                          }
                          if (value == '') {
                            return 'Email cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const ConstantText(
                        'Current Password',
                        17,
                        FontWeight.bold,
                        blueColor,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (!_passwordRegex.hasMatch(value.toString())) {
                            return 'Please enter your password';
                          }
                          if (value == '') {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const ConstantText(
                        'New Email Address',
                        17,
                        FontWeight.bold,
                        blueColor,
                      ),
                      TextFormField(
                        controller: _newEmailController,
                        validator: (value) {
                          if (!_emailRegex.hasMatch(value.toString())) {
                            return 'Please enter the new email';
                          }
                          if (value == '') {
                            return 'Email cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const BeveledRectangleBorder(),
                                backgroundColor: greyColors,
                              ),
                              child: const ConstantText(
                                'Cancel',
                                20,
                                FontWeight.bold,
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  profileInjector.updateEmail(
                                    _emailController.text,
                                    _passwordController.text,
                                    _newEmailController.text,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const BeveledRectangleBorder(),
                                backgroundColor: blueColor,
                              ),
                              child: const ConstantText(
                                'Save',
                                20,
                                FontWeight.bold,
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
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
}
