import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/authentication_controller.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';

class LogOutScreen extends StatefulWidget {
  const LogOutScreen({super.key});

  @override
  State<LogOutScreen> createState() => _LogOutScreenState();
}

class _LogOutScreenState extends State<LogOutScreen> {
  final authControllerInjector = Get.find<AuthController>();

  final profileInjector = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    final screenHeight = MediaQuery.of(context).size.height;
    return GetX<ProfileController>(builder: (controller) {
      return profileInjector.logOutLoader.value == false
          ? Scaffold(
              appBar: AppBar(
                title: const Text('We Will Miss You !'),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 17, right: 17),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                              middleText: '',
                              middleTextStyle: const TextStyle(
                                  color: Colors.transparent, fontSize: 0),
                              cancel: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 17),
                                  )),
                              confirm: ElevatedButton(
                                  onPressed: () {
                                    authControllerInjector.logOutFunction();
                                    // box.remove('isOnboardScreenShown');
                                    // box.remove('userId');
                                    // Get.offAll(() => const LoginScreen());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade800),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  )),
                              titlePadding: const EdgeInsets.all(20),
                              titleStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800),
                              title: 'Are you sure you want to log out ?');
                        },
                        child: ListTile(
                          tileColor: Colors.grey.shade200,
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.blue,
                            size: 35,
                          ),
                          title: Text(
                            'Log out',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                                fontSize: 22),
                          ),
                          subtitle: Text(
                            'You will be directed to log in ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      box.read('userId') != null
                          ? GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                    middleText: '',
                                    middleTextStyle: const TextStyle(
                                        color: Colors.transparent, fontSize: 0),
                                    cancel: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 17),
                                        )),
                                    confirm: ElevatedButton(
                                        onPressed: () {
                                          box.remove('isOnboardScreenShown');
                                          profileInjector.deleteAccountForever(
                                              box.read('userId'));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade800),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        )),
                                    titlePadding: const EdgeInsets.all(20),
                                    titleStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800),
                                    title:
                                        'Are you sure you want to delete this account ?');
                              },
                              child: ListTile(
                                tileColor: Colors.grey.shade200,
                                leading: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 35,
                                ),
                                title: Text(
                                  'Delete account',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                      fontSize: 22),
                                ),
                                subtitle: Text(
                                  'Delete this account forever',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 0.0,
                            ),
                    ],
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
    });
  }
}
