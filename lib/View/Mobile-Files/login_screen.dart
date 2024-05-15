import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/authentication_controller.dart';
import 'package:shopee_app/View/Mobile-Files/forget_password_credential_screen.dart';
import 'package:shopee_app/View/Mobile-Files/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GetStorage box = GetStorage();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Regular expression for email validation
  final _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
  );

  // Regular expression for password validation
  final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
  );

  TextEditingController emailController = TextEditingController();
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
        return authControllerInjector.loginLoadingIndicator.value == true
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
                    'Sign In',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 13),
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth / 17,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.015,
                        ),
                        Text(
                          'Sign in with your email and password or continue with social media',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 23,
                              color: Colors.grey),
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
                                controller: emailController,
                                validator: (value) {
                                  if (value == '') {
                                    return 'email address cannot be empty';
                                  }
                                  if (!_emailRegex.hasMatch(value.toString())) {
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
                                        color: Colors.blue),
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
                                controller: passwordController,
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
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  label: Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
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
                                height: screenHeight * 0.025,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                    onPressed: () {
                                      Get.to(
                                          () => const ForgetPasswordScreen());
                                    },
                                    child: Text(
                                      'forget password',
                                      style: TextStyle(
                                          fontSize: screenWidth / 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 1.2),
                                      textAlign: TextAlign.end,
                                    )),
                              ),
                              SizedBox(
                                height: screenHeight * 0.025,
                              ),
                              SizedBox(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.055,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      authControllerInjector.userLogin(
                                          emailController.text,
                                          passwordController.text);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.blue,
                                      elevation: 3,
                                      backgroundColor: Colors.blue),
                                  child: Text(
                                    'Sign In ',
                                    style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              SizedBox(
                                height: 45,
                                child: SignInButton(
                                  elevation: 10,
                                  Buttons.Google,
                                  onPressed: () {
                                    authControllerInjector.loginWithGoogle();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.035,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Dont have an account ?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth / 22),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.01,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Get.to(() => const RegisterScreen());
                                    },
                                    child: Text(
                                      'Sign Up',
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
              );
      }),
    );
  }
}
