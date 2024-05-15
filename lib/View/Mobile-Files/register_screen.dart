import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shopee_app/Controller/authentication_controller.dart';
import 'package:shopee_app/View/Mobile-Files/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _usernameRegex = RegExp(
    r'^[a-zA-Z0-9_]+$',
  );

  final _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
  );

  final _phoneRegex = RegExp(
    r'^[0-9]{8}$',
  );

  final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
  );

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final authControllerInjector = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GetX<AuthController>(
      builder: ((controller) {
        return authControllerInjector.signUpStep1Indicator.value == true
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
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 13),
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Text(
                            'Register by filling the form below or go sign in if user-In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth / 22,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: usernameController,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'your name cannot be empty';
                                    }
                                    if (!_usernameRegex
                                        .hasMatch(value.toString())) {
                                      return 'Please enter a name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    label: Text(
                                      'Username',
                                      style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    suffixIcon: const Icon(Icons.person),
                                    suffixIconColor: Colors.blue,
                                    hintText: 'Enter your name..',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
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
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
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
                                  height: screenHeight * 0.04,
                                ),
                                TextFormField(
                                  controller: phoneController,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'number  cannot be empty';
                                    }
                                    if (!_phoneRegex
                                        .hasMatch(value.toString())) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    label: Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    suffixIcon: const Icon(Icons.numbers),
                                    suffixIconColor: Colors.blue,
                                    hintText: 'Enter your number..',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                                TextFormField(
                                  obscureText: _obscureText,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'password  cannot be empty';
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
                                      'Password ',
                                      style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: _obscureText
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                      onPressed: togglePasswordVisibility,
                                      color: Colors.blue,
                                    ),
                                    suffixIconColor: Colors.blue,
                                    hintText: 'Enter your password',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.05,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        authControllerInjector.signUpStep1(
                                            usernameController.text,
                                            emailController.text,
                                            phoneController.text,
                                            passwordController.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    child: Text(
                                      'Sign Up ',
                                      style: TextStyle(
                                          fontSize: screenWidth / 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.035,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ' Already have an account ?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth / 22),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.offAll(() => const LoginScreen());
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: screenWidth / 22),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
