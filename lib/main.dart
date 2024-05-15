import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Bindings/binding.dart';
import 'package:shopee_app/View/Mobile-Files/mobile_main_screen.dart';
import 'package:shopee_app/View/Tablet-Files/tablet_main_screen.dart';
import 'package:shopee_app/View/Website-Files/desktop_main_screen.dart';
import 'package:shopee_app/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Supabase.initialize(
    url: 'https://niuvtmtuvwlkuoadpmhi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pdXZ0bXR1dndsa3VvYWRwbWhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIwNTA2NDksImV4cCI6MjAyNzYyNjY0OX0.0K3Sa8k83-3eWoKCn4XxrWxPPyBYV6cNaMo5TllGebE',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DevicePreview(builder: (context) => const ShopeeApp()));
}

class ShopeeApp extends StatelessWidget {
  const ShopeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: OnboardingScreenBinding(),
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 950) {
            return const WebsiteApp();
          } else if (constraints.maxWidth > 600 && constraints.maxWidth < 950) {
            return const TabletMainScreen();
          }
          return const MobileMainScreen();
        },
      ),
    );
  }
}
