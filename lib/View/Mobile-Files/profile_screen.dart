import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';
import 'package:shopee_app/View/Mobile-Files/about_us.dart';
import 'package:shopee_app/View/Mobile-Files/edit_prodile_screen.dart';
import 'package:shopee_app/View/Mobile-Files/log_out_screen.dart';
import 'package:shopee_app/View/Mobile-Files/product_location_screen.dart';
import 'package:shopee_app/View/Mobile-Files/purchase_history_screen.dart';
import 'package:shopee_app/View/Mobile-Files/setting_notifi_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GetStorage box = GetStorage();
  final profileContollerInjector = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    List<Icon> icons = const [
      Icon(Icons.edit),
      Icon(Icons.location_on),
      Icon(Icons.schedule),
      Icon(Icons.notifications),
      Icon(Icons.local_activity),
      Icon(Icons.exit_to_app),
    ];
    List<String> iconNames = [
      'Update Info',
      'Track Order',
      'Order History',
      'Notifications',
      'About us',
      'Log Out'
    ];
    List<Widget> navogationList = [
      const EditProfileScreen(),
      const ProductLocationScreen(),
      const PurchaseHistory(),
      const SettingNotificationScreen(),
      const AboutUs(),
      const LogOutScreen()
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: icons.length,
                  itemBuilder: ((context, index) {
                    var icon = icons[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => navogationList[index]);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            iconColor: Colors.blue,
                            leading: icon,
                            title: Text(
                              iconNames[index],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            trailing:
                                const Icon(Icons.keyboard_arrow_right_sharp),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
