import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';
import 'package:shopee_app/View/Mobile-Files/change_email_screen.dart';
import 'package:shopee_app/View/Mobile-Files/change_name.dart';

import 'change_password.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GetStorage box = GetStorage();
  final profileContollerInjector = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileController>(
      builder: (controller) {
        return profileContollerInjector.editProfileLoader.value == false
            ? Scaffold(
                appBar: AppBar(
                  title: const Text('Edit Profile'),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 17, right: 17),
                      child: box.read('userId') != null
                          ? Column(
                              children: [
                                const SizedBox(height: 30),
                                buildProfileTile(
                                  'Change your email address',
                                  Icons.email,
                                  () => Get.to(() => const ChangeEmail()),
                                ),
                                const SizedBox(height: 20),
                                buildProfileTile(
                                  'Change your name',
                                  Icons.person,
                                  () => Get.to(() => const ChangeName()),
                                ),
                                const SizedBox(height: 20),
                                buildProfileTile(
                                  'Change your password',
                                  Icons.lock,
                                  () => Get.to(() => const ChangePassword()),
                                ),
                              ],
                            )
                          : const Text(
                              'NOTE:\n Signed in using third part like google ...etc updating services are not available.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: Center(
                  child: Image.asset(
                    'assets/images/loadingGif.gif',
                  ),
                ),
              );
      },
    );
  }

  Widget buildProfileTile(String title, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        tileColor: Colors.grey.shade300, // Using the constants
        leading: Icon(
          icon,
          size: 30,
          color: blueColor, // Using the constants
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: greyColor800, // Using the constants
          ),
        ),
      ),
    );
  }
}
