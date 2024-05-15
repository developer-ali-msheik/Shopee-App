import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/View/Mobile-Files/checkout1.dart';
import 'package:shopee_app/View/Mobile-Files/favorite_screen.dart';
import 'package:shopee_app/main.dart';

class ProductController extends GetxController {
  RxBool exists = false.obs;
  RxString productColor = ''.obs;
  RxString productSize = ''.obs;

  GetStorage box = GetStorage();

  checkIfProductIsInFavorites(Map<String, dynamic> e) async {
    final res = await supabase.from('favorite_products').select().match({
      'product_name': e['product_name'],
      'user_id': box.read('userId') ?? box.read('googleId')
    });

    if (res.isEmpty) {
      exists.value = false;
    } else {
      exists.value = true;
    }
  }

  favoriteAwesomeDialog(String text, DialogType e) {
    AwesomeDialog(
      barrierColor: Colors.blue.shade100,
      context: Get.context!,
      dialogType: e,
      animType: AnimType.leftSlide,
      body: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: Colors.grey.shade800,
        ),
        textAlign: TextAlign.center,
      ),
      btnOk: TextButton(
        onPressed: () {
          Get.off(() => const FavoriteScreen());
        },
        child: const Text(
          'favorites ->',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
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
  }

  addOrDeleteProductFromFavorites(
      Map<String, dynamic> product, double totalPrice) async {
    if (exists.value == false) {
      await supabase.from('favorite_products').insert({
        'product_name': product['product_name'],
        'product_price': totalPrice,
        'product_image': product['product_image'],
        'user_id': box.read('userId') ?? box.read('googleId')
      });

      favoriteAwesomeDialog(
          'added successfully to your favorites', DialogType.success);
      exists.value = true;
    } else {
      await supabase
          .from('favorite_products')
          .delete()
          .match({'product_name': product['product_name']});
      favoriteAwesomeDialog(
          'deleted successfully from your favorites', DialogType.success);
      exists.value = false;
    }
  }

  addProductsToCart(
      Map<String, dynamic> e, String cat, double totalPrice) async {
    if (cat == 'colorAndSize') {
      final quantityData = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({
        'product_id': e['id'],
        'product_size': productSize.value,
        'product_color': productColor.value
      });
      if (quantityData[0]['product_quantity'] > 0) {
        final res = await supabase.from('cart_products').select().match({
          'product_name': e['product_name'],
          'product_color': productColor.value,
          'product_size': productSize.value
        });
        if (res.isNotEmpty) {
          final productPrice = res[0]['product_price'];
          int one = 1;
          await supabase.from('cart_products').update({
            'product_nb_order': res[0]['product_nb_order'] + one,
            'product_total_price': res[0]['product_total_price'] + productPrice
          }).match({
            'product_name': e['product_name'],
            'product_color': productColor.value,
            'product_size': productSize.value
          });
          int inc = 1;
          await supabase.from('products_variation').update({
            'product_quantity': quantityData[0]['product_quantity'] - inc
          }).match({
            'product_id': e['id'],
            'product_size': productSize.value,
            'product_color': productColor.value
          });
          awesomeDialog('added to cart again', DialogType.success);
        } else {
          await supabase.from('cart_products').insert({
            'product_name': e['product_name'],
            'product_price': totalPrice,
            'product_image': e['product_image'],
            'product_color': productColor.value,
            'product_size': productSize.value,
            'product_nb_order': 1,
            'product_total_price': totalPrice.toStringAsFixed(2),
            'product_id': e['id'],
            'user_id': box.read('userId') ?? box.read('googleId')
          });
          int inc = 1;
          await supabase.from('products_variation').update({
            'product_quantity': quantityData[0]['product_quantity'] - inc
          }).match({
            'product_id': e['id'],
            'product_size': productSize.value,
            'product_color': productColor.value
          });
          awesomeDialog('added  successfully to your cart', DialogType.success);
        }
      }
    } else if (cat == 'color') {
      final quantityData = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({'product_id': e['id'], 'product_color': productColor.value});

      if (quantityData[0]['product_quantity'] > 0) {
        final res = await supabase.from('cart_products').select().match({
          'product_name': e['product_name'],
          'product_color': productColor.value,
        });
        if (res.isNotEmpty) {
          final productPrice = res[0]['product_price'];
          int one = 1;
          await supabase.from('cart_products').update({
            'product_nb_order': res[0]['product_nb_order'] + one,
            'product_total_price': res[0]['product_total_price'] + productPrice
          }).match({
            'product_name': e['product_name'],
            'product_color': productColor.value,
          });
          int inc = 1;
          await supabase.from('products_variation').update({
            'product_quantity': quantityData[0]['product_quantity'] - inc
          }).match(
              {'product_id': e['id'], 'product_color': productColor.value});
          awesomeDialog('added to cart again', DialogType.success);
        } else {
          await supabase.from('cart_products').insert({
            'product_name': e['product_name'],
            'product_price': totalPrice,
            'product_image': e['product_image'],
            'product_color': productColor.value,
            'product_nb_order': 1,
            'product_total_price': totalPrice.toStringAsFixed(2),
            'product_id': e['id'],
            'user_id': box.read('userId') ?? box.read('googleId')
          });
          int inc = 1;
          await supabase.from('products_variation').update({
            'product_quantity': quantityData[0]['product_quantity'] - inc
          }).match(
              {'product_id': e['id'], 'product_color': productColor.value});
          awesomeDialog('added  successfully to your cart', DialogType.success);
        }
      }
    } else if (cat == 'game') {
      final quantityData = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({'product_id': e['id']});
      if (quantityData[0]['product_quantity'] > 0) {
        final res = await supabase.from('cart_products').select().match({
          'product_name': e['product_name'],
        });
        if (res.isNotEmpty) {
          final productPrice = res[0]['product_price'];
          int one = 1;
          await supabase.from('cart_products').update({
            'product_nb_order': res[0]['product_nb_order'] + one,
            'product_total_price': res[0]['product_total_price'] + productPrice
          }).match({
            'product_name': e['product_name'],
          });
          int inc = 1;
          await supabase.from('products_variation').update({
            'product_quantity': quantityData[0]['product_quantity'] - inc
          }).match({'product_id': e['id']});
          awesomeDialog('added to cart again', DialogType.success);
        } else {
          await supabase.from('cart_products').insert({
            'product_name': e['product_name'],
            'product_price': totalPrice,
            'product_image': e['product_image'],
            'product_nb_order': 1,
            'product_total_price': totalPrice.toStringAsFixed(2),
            'product_id': e['id'],
            'user_id': box.read('userId') ?? box.read('googleId')
          });
          int inc = 1;
          await supabase.from('products_variation').update({
            'product_quantity': quantityData[0]['product_quantity'] - inc
          }).match(
              {'product_id': e['id'], 'product_color': productColor.value});
          awesomeDialog('added  successfully to your cart', DialogType.success);
        }
      }
    }
  }

  addToCartRefactor(Map<String, dynamic> e, double totalPrice) {
    final cut = e['variation'][0];
    if (cut['product_color'] != null && cut['product_size'] != null) {
      if (productColor.value == '' && productSize.value == '') {
        awesomeDialog('please select any variation', DialogType.error);
      } else {
        addProductsToCart(e, 'colorAndSize', totalPrice);
      }
    } else if (cut['product_size'] == null && cut['product_color'] != null) {
      if (productColor.value == '') {
        awesomeDialog('please select a color', DialogType.error);
      } else {
        addProductsToCart(e, 'color', totalPrice);
        awesomeDialog('Added successfully', DialogType.success);
      }
    }
  }

  checkProductCategory(Map<String, dynamic> e, double totalPrice) {
    if (e['category_id'] == 1 ||
        e['category_id'] == 2 ||
        e['category_id'] == 4) {
      addToCartRefactor(e, totalPrice);
    } else if (e['category_id'] == 3) {
      addProductsToCart(e, 'game', totalPrice);
    }
  }

  awesomeDialog(String text, DialogType e) {
    AwesomeDialog(
      barrierColor: Colors.blue.shade100,
      context: Get.context!,
      dialogType: e,
      animType: AnimType.leftSlide,
      body: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: Colors.grey.shade800,
        ),
        textAlign: TextAlign.center,
      ),
      btnOk: TextButton(
        onPressed: () {
          Get.off(() => const CheckOutScreen());
        },
        child: const Text(
          'Check-Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
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
  }

  @override
  void onClose() {
    productColor.value = '';
    productSize.value = '';
    super.onClose();
  }
}
