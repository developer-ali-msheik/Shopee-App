import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:shopee_app/Controller/authentication_controller.dart';
import 'package:shopee_app/Controller/cart_screen_controller.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';
import 'package:shopee_app/Controller/favorite_screen_controller.dart';
import 'package:shopee_app/Controller/home_screen_controller.dart';
import 'package:shopee_app/Controller/onboarding_controller.dart';
import 'package:shopee_app/Controller/product_details_controller.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';

class OnboardingScreenBinding with Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => HomeScreenController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => FavoriteController(), fenix: true);
    Get.lazyPut(() => CheckOutController(), fenix: true);
  }
}
