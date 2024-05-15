import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final profileInjector = Get.find<ProfileController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Who Are We'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantText('Welcome to Our Company', screenWidth * 0.06,
                  FontWeight.bold, blueColor),

              SizedBox(height: screenHeight * 0.02),
              ConstantText(
                  'Our Story:', screenWidth * 0.05, FontWeight.bold, blueColor),

              SizedBox(height: screenHeight * 0.01),
              ConstantTextNoFontWeight(
                  'Founded in Lebanon, our company aims to provide high-quality products to customers both locally and worldwide. With our warehouse located in Lebanon, we ensure fast and efficient delivery to our customers.',
                  screenWidth * 0.04,
                  greyColor800),

              SizedBox(height: screenHeight * 0.02),
              Text(
                'Our Mission:',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.05, // Adjust font size based on screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.01), // Adjust height based on screen height
              Text(
                'To become the leading provider of top-notch products, delivering exceptional value and service to our customers across Lebanon and beyond.',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.04, // Adjust font size based on screen width
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.02), // Adjust height based on screen height
              Text(
                'Our Vision:',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.05, // Adjust font size based on screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.01), // Adjust height based on screen height
              Text(
                'To create a seamless shopping experience for our customers, offering a diverse range of products and ensuring customer satisfaction at every step.',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.04, // Adjust font size based on screen width
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.02), // Adjust height based on screen height
              Text(
                'Our Contacts:',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.05, // Adjust font size based on screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      profileInjector.launchFacebook();
                    },
                    icon: const Icon(
                      Icons.facebook,
                      color: Colors.blue,
                      size: 35.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      profileInjector.launchWhatsapp();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      size: 35.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      profileInjector.launcheInstagram();
                    },
                    icon: Icon(
                      FontAwesomeIcons.instagram,
                      color: Colors.orange.shade300,
                      size: 35.0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Text(
                ' ©2024-CopyRight-ShopeeTeam',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
