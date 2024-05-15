import 'package:intl/intl.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/View/Mobile-Files/checkout2.dart';
import 'package:shopee_app/View/Mobile-Files/checkout3.dart';
import 'package:shopee_app/View/Mobile-Files/navigation_station.dart';
import 'package:shopee_app/main.dart';
import 'package:http/http.dart' as http;

class CheckOutController extends GetxController {
  RxDouble totalPriceToPay = 0.0.obs;
  RxInt paymentOptionNumber = 0.obs;
  GetStorage box = GetStorage();
  RxString phonenumber = ''.obs;
  RxString deliverynumber = ''.obs;
  RxString deliveryOption = ''.obs;
  RxString dateChosen = ''.obs;
  RxString fullName = ''.obs;
  RxString streetName = ''.obs;
  RxString cityName = ''.obs;
  RxString stateName = ''.obs;
  RxString countryName = ''.obs;
  RxList<Map<String, dynamic>> finalProducts = RxList<Map<String, dynamic>>();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 90)), // 3 months from now
    );
    if (picked != null) {
      // Format the picked date
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dateChosen.value = formattedDate;
    }
  }

  tttt() {
    if (deliverynumber.value == '') {
      AwesomeDialog(
        barrierColor: Colors.blue.shade100,
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.leftSlide,
        body: Text(
          'Choose a delivery option ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        btnCancelOnPress: () {
          Navigator.pop(Get.context!);
        },
        btnCancel: TextButton(
          onPressed: () {
            Navigator.pop(Get.context!);
          },
          child: const Text(
            'Back',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ).show();
    } else {
      if (deliverynumber.value == '1' || deliverynumber.value == '2') {
        if (box.read('skip') != null) {
          Get.to(() => const CheckOutScreen3());
        } else {
          box.write('skip', 'yes');
          Get.to(() => const UserAddress());
        }
      } else if (deliverynumber.value == '3') {
        if (dateChosen.value == '') {
          AwesomeDialog(
            barrierColor: Colors.blue.shade100,
            context: Get.context!,
            dialogType: DialogType.error,
            animType: AnimType.leftSlide,
            body: Text(
              'Please choose a delivery date. ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            btnCancelOnPress: () {
              Navigator.pop(Get.context!);
            },
            btnCancel: TextButton(
              onPressed: () {
                Navigator.pop(Get.context!);
              },
              child: const Text(
                'Back',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ).show();
        } else {
          if (box.read('skip') != null) {
            Get.to(() => const CheckOutScreen3());
          } else {
            box.write('skip', 'yes');
            Get.to(() => const UserAddress());
          }
        }
      }
    }
  }

  checkOutStep2(String name, String street, String city, String state,
      String country, String phone) {
    fullName.value = name;
    streetName.value = street;
    cityName.value = city;
    stateName.value = state;
    countryName.value = country;
    phonenumber.value = phone;

    box.write('fullName', name);
    box.write('streetName', street);
    box.write('cityName', city);
    box.write('stateName', state);
    box.write('countryName', country);
    box.write('phonenumber', phone);
    Get.to(() => const CheckOutScreen3());
  }

  returnUserProducts() async {
    final res = await supabase
        .from('cart_products')
        .select()
        .eq('user_id', box.read('userId') ?? box.read('googleId'));
    finalProducts.value = res;
    for (var product in finalProducts) {
      totalPriceToPay.value += product['product_total_price'];
    }
  }

  finalCheckOutPayment() async {
    final res = await supabase.from('users_info').select('id').match({
      'user_name': box.read('fullName') ?? fullName.value,
      'user_street': box.read('streetName') ?? streetName.value,
      'user_city': box.read('cityName') ?? cityName.value,
      'user_state': box.read('stateName') ?? stateName.value,
      'user_country': box.read('countryName') ?? countryName.value,
      'user_phone': box.read('phonenumber') ?? phonenumber.value
    });

    if (res.isEmpty) {
      if (deliverynumber.value == '1') {
        dateChosen.value = 'standard';
      } else if (deliverynumber.value == '2') {
        dateChosen.value = 'nextDay';
      }
      await supabase.from('users_info').insert({
        'user_name': box.read('fullName') ?? fullName.value,
        'user_street': box.read('streetName') ?? streetName.value,
        'user_city': box.read('cityName') ?? cityName.value,
        'user_state': box.read('stateName') ?? stateName.value,
        'user_country': box.read('countryName') ?? countryName.value,
        'user_phone': box.read('phonenumber') ?? phonenumber.value
      });
      final response = await supabase.from('users_info').select('id').match({
        'user_name': fullName.value,
        'user_street': streetName.value,
        'user_city': cityName.value,
        'user_state': stateName.value,
        'user_country': countryName.value,
        'user_phone': phonenumber.value
      });

      for (int i = 0; i < finalProducts.length; i++) {
        final xx = finalProducts[i];
        await supabase.from('users_ordered_products').insert({
          'product_name': xx['product_name'],
          'product_color': xx['product_color'],
          'product_size': xx['product_size'],
          'product_quantity': xx['product_nb_order'].toString(),
          'product_total_price': xx['product_total_price'].toString(),
          'product_delivery_date': dateChosen.value,
          'user_id': response[0]['id'],
          'php_user_id_for_order_history':
              box.read('userId') ?? box.read('googleId'),
          'product_image': xx['product_image']
        });
      }
      for (int i = 0; i < finalProducts.length; i++) {
        final xx = finalProducts[i];
        await supabase.from('history_of_purchases').insert({
          'product_name': xx['product_name'],
          'product_color': xx['product_color'],
          'product_size': xx['product_size'],
          'product_quantity': xx['product_nb_order'].toString(),
          'product_total_price': xx['product_total_price'].toString(),
          'product_delivery_date': dateChosen.value,
          'php_user_id_for_order_history':
              box.read('userId') ?? box.read('googleId'),
          'product_image': xx['product_image']
        });
      }
    } else {
      if (deliverynumber.value == '1') {
        dateChosen.value = 'standard';
      } else if (deliverynumber.value == '2') {
        dateChosen.value = 'nextDay';
      }
      for (int i = 0; i < finalProducts.length; i++) {
        final xx = finalProducts[i];
        await supabase.from('users_ordered_products').insert({
          'product_name': xx['product_name'],
          'product_color': xx['product_color'],
          'product_size': xx['product_size'],
          'product_quantity': xx['product_nb_order'].toString(),
          'product_total_price': xx['product_total_price'].toString(),
          'product_delivery_date': dateChosen.value,
          'user_id': res[0]['id'],
          'php_user_id_for_order_history':
              box.read('userId') ?? box.read('googleId'),
          'product_image': xx['product_image']
        });
      }
      for (int i = 0; i < finalProducts.length; i++) {
        final xx = finalProducts[i];
        await supabase.from('history_of_purchases').insert({
          'product_name': xx['product_name'],
          'product_color': xx['product_color'],
          'product_size': xx['product_size'],
          'product_quantity': xx['product_nb_order'].toString(),
          'product_total_price': xx['product_total_price'].toString(),
          'product_delivery_date': dateChosen.value,
          'php_user_id_for_order_history':
              box.read('userId') ?? box.read('googleId'),
          'product_image': xx['product_image']
        });
      }
    }
    await supabase
        .from('cart_products')
        .delete()
        .match({'user_id': box.read('userId') ?? box.read('googleId')});
    const url =
        'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/email_after_purchase.php';

    await http.post(Uri.parse(url), body: {
      'user_email': box.read('userEmail') ?? box.read('googleEmailAddress'),
      'user_name': box.read('userName')
    });
  }

  deleteProductFromOrderHistory(Map<String, dynamic> product) async {
    await supabase
        .from('history_of_purchases')
        .delete()
        .eq('id', product['id']);
  }

  retrieveDeletedOrderes() async {
    final res = await supabase.from('users_ordered_products').select().eq(
        'php_user_id_for_order_history',
        box.read('userId') ?? box.read('googleId'));
    if (res.isNotEmpty) {
      Get.back();
      for (int i = 0; i < res.length; i++) {
        final xx = res[i];
        await supabase.from('history_of_purchases').insert({
          'product_name': xx['product_name'],
          'product_color': xx['product_color'],
          'product_size': xx['product_size'],
          'product_quantity': xx['product_quantity'],
          'product_total_price': xx['product_total_price'],
          'product_delivery_date': xx['product_delivery_date'],
          'time_ordered_product': xx['time_ordered_product'],
          'php_user_id_for_order_history':
              box.read('userId') ?? box.read('googleId'),
          'product_image': xx['product_image']
        });
      }
    } else {
      Get.back();
      Get.defaultDialog(
          onConfirm: () {
            Get.offAll(() => const NavigationStation());
          },
          textConfirm: 'Lets Shop Something',
          buttonColor: Colors.blue,
          middleText: 'Go buy and see what you like',
          middleTextStyle: const TextStyle(fontSize: 19, color: Colors.blue),
          title: 'No products found !',
          titleStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey.shade800));
    }
  }

  @override
  void onInit() {
    returnUserProducts();
    super.onInit();
  }
}
