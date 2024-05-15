import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({super.key});

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  final checkOutController = Get.find<CheckOutController>();
  final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  final TextEditingController street = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  // Regex for street 1 (allows letters, numbers, spaces, and some special characters)
  final RegExp street1Regex = RegExp(r'^[a-zA-Z0-9\s\-\.,\/]+$');

  // Regex for city (allows letters, spaces, and some special characters)
  final RegExp cityRegex = RegExp(r'^[a-zA-Z\s\-\.,\/]+$');

  // Regex for state (allows letters and spaces)
  final RegExp stateRegex = RegExp(r'^[a-zA-Z\s]+$');

  // Regex for country (allows letters and spaces)
  final RegExp countryRegex = RegExp(r'^[a-zA-Z\s]+$');

  // Regex for full name (allows letters and spaces)
  final RegExp fullNameRegex = RegExp(r'^[a-zA-Z\s]+$');

  final RegExp phoneNumberRegex = RegExp(r'^[0-9]{1,11}$');

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (myFormKey.currentState!.validate()) {
            checkOutController.checkOutStep2(fullName.text, street.text,
                city.text, state.text, country.text, phoneNumber.text);
          }
        },
        backgroundColor: blueColor,
        child: const Icon(
          Icons.arrow_right_alt_rounded,
          size: 40.0,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: ConstantText(
          'User Address',
          20,
          FontWeight.bold,
          greyColor800,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Form(
                  key: myFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstantText(
                        'Full Name',
                        screenHeight * 0.025,
                        FontWeight.bold,
                        greyColors,
                      ),
                      TextFormField(
                        controller: fullName,
                        validator: (value) {
                          if (value == '') {
                            return 'Enter full name';
                          }
                          if (!fullNameRegex.hasMatch(value.toString())) {
                            return 'Please enter a valid full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      ConstantText(
                        'Street',
                        screenHeight * 0.025,
                        FontWeight.bold,
                        greyColors,
                      ),
                      TextFormField(
                        controller: street,
                        validator: (value) {
                          if (value == '') {
                            return 'Enter street name';
                          }
                          if (!street1Regex.hasMatch(value.toString())) {
                            return 'Please enter a valid street name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      ConstantText(
                        'Phone Number',
                        screenHeight * 0.025,
                        FontWeight.bold,
                        greyColors,
                      ),
                      TextFormField(
                        controller: phoneNumber,
                        validator: (value) {
                          if (value == '') {
                            return 'Enter phone number';
                          }
                          if (!phoneNumberRegex.hasMatch(value.toString())) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      ConstantText(
                        'City',
                        screenHeight * 0.025,
                        FontWeight.bold,
                        greyColors,
                      ),
                      TextFormField(
                        controller: city,
                        validator: (value) {
                          if (value == '') {
                            return 'Enter city name';
                          }
                          if (!cityRegex.hasMatch(value.toString())) {
                            return 'Please enter a valid city name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstantText(
                                'State',
                                screenHeight * 0.025,
                                FontWeight.bold,
                                greyColors,
                              ),
                              SizedBox(
                                width: screenWidth * 0.4,
                                child: TextFormField(
                                  controller: state,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Enter state name';
                                    }
                                    if (!stateRegex
                                        .hasMatch(value.toString())) {
                                      return 'Please enter a valid state name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstantText(
                                'Country',
                                screenHeight * 0.025,
                                FontWeight.bold,
                                greyColors,
                              ),
                              SizedBox(
                                width: screenWidth * 0.4,
                                child: TextFormField(
                                  controller: country,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Enter country name';
                                    }
                                    if (!countryRegex
                                        .hasMatch(value.toString())) {
                                      return 'Please enter a valid country name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          )
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
