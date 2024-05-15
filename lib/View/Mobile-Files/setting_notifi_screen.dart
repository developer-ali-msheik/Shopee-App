import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SettingNotificationScreen extends StatefulWidget {
  const SettingNotificationScreen({super.key});

  @override
  State<SettingNotificationScreen> createState() =>
      _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen> {
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification-Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 17, right: 17),
          child: Stack(
            children: [
              ListTile(
                tileColor: Colors.grey.shade200,
                leading: const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.blue,
                  size: 35,
                ),
                title: Text(
                  'Enable Or Disable',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 22),
                ),
                subtitle: Text(
                  box.read('googleId') ?? 'Notifications',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 16),
                ),
              ),
              const Positioned(
                right: 7,
                top: 7,
                child: SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Text('Enabled'),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Disabled'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
