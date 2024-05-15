import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/View/Mobile-Files/product_cart_pop_up.dart';
import 'package:shopee_app/main.dart';

class CartController extends GetxController {
  GetStorage box = GetStorage();

  addProductsNbOrder(Map<String, dynamic> product) async {
    if (product['product_size'] != null && product['product_color'] != null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({
        'product_color': product['product_color'],
        'product_size': product['product_size'],
        'product_id': product['product_id']
      });
      if (res[0]['product_quantity'] > 0) {
        int one = 1;
        await supabase.from('cart_products').update({
          'product_nb_order': product['product_nb_order'] + one,
          'product_total_price':
              product['product_total_price'] + product['product_price']
        }).match({
          'product_name': product['product_name'],
          'product_color': product['product_color'],
          'product_size': product['product_size'],
        });
        await supabase.from('products_variation').update(
            {'product_quantity': res[0]['product_quantity'] - one}).match({
          'product_color': product['product_color'],
          'product_size': product['product_size'],
          'product_id': product['product_id']
        });
      } else {
        awesomeDialog('no more quantity available !', DialogType.warning);
      }
    } else if (product['product_size'] == null &&
        product['product_color'] == null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({'product_id': product['product_id']});
      if (res[0]['product_quantity'] > 0) {
        int one = 1;
        await supabase.from('cart_products').update({
          'product_nb_order': product['product_nb_order'] + one,
          'product_total_price':
              product['product_total_price'] + product['product_price']
        }).match({
          'product_name': product['product_name'],
        });
        await supabase.from('products_variation').update({
          'product_quantity': res[0]['product_quantity'] - one
        }).match({'product_id': product['product_id']});
      } else {
        awesomeDialog('no more quantity available !', DialogType.warning);
      }
    } else if (product['product_size'] == null &&
        product['product_color'] != null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({
        'product_color': product['product_color'],
        'product_id': product['product_id']
      });
      if (res[0]['product_quantity'] > 0) {
        int one = 1;
        await supabase.from('cart_products').update({
          'product_nb_order': product['product_nb_order'] + one,
          'product_total_price':
              product['product_total_price'] + product['product_price']
        }).match({
          'product_name': product['product_name'],
          'product_color': product['product_color'],
        });
        await supabase.from('products_variation').update(
            {'product_quantity': res[0]['product_quantity'] - one}).match({
          'product_color': product['product_color'],
          'product_id': product['product_id']
        });
      } else {
        awesomeDialog('no more quantity available !', DialogType.warning);
      }
    }
  }

  decrementProductNbOrder(Map<String, dynamic> product) async {
    if (product['product_size'] != null && product['product_color'] != null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({
        'product_color': product['product_color'],
        'product_size': product['product_size'],
        'product_id': product['product_id']
      });

      if (product['product_nb_order'] > 1) {
        int one = 1;
        await supabase.from('cart_products').update({
          'product_nb_order': product['product_nb_order'] - one,
          'product_total_price':
              product['product_total_price'] - product['product_price']
        }).match({
          'product_name': product['product_name'],
          'product_color': product['product_color'],
          'product_size': product['product_size'],
        });

        await supabase.from('products_variation').update(
            {'product_quantity': res[0]['product_quantity'] + one}).match({
          'product_color': product['product_color'],
          'product_size': product['product_size'],
          'product_id': product['product_id']
        });
      } else {
        // showAlertDialog(context);
        showAlertDialog(product);
      }
    } else if (product['product_size'] == null &&
        product['product_color'] == null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({'product_id': product['product_id']});

      if (product['product_nb_order'] > 1) {
        int one = 1;
        await supabase.from('cart_products').update({
          'product_nb_order': product['product_nb_order'] - one,
          'product_total_price':
              product['product_total_price'] - product['product_price']
        }).match({
          'product_name': product['product_name'],
        });

        await supabase.from('products_variation').update({
          'product_quantity': res[0]['product_quantity'] + one
        }).match({'product_id': product['product_id']});
      } else {
        // showAlertDialog(context);
        showAlertDialog(product);
      }
    } else if (product['product_size'] == null &&
        product['product_color'] != null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({
        'product_color': product['product_color'],
        'product_id': product['product_id']
      });

      if (product['product_nb_order'] > 1) {
        int one = 1;
        await supabase.from('cart_products').update({
          'product_nb_order': product['product_nb_order'] - one,
          'product_total_price':
              product['product_total_price'] - product['product_price']
        }).match({
          'product_name': product['product_name'],
          'product_color': product['product_color'],
        });

        await supabase.from('products_variation').update(
            {'product_quantity': res[0]['product_quantity'] + one}).match({
          'product_color': product['product_color'],
          'product_id': product['product_id']
        });
      } else {
        // showAlertDialog(context);
        showAlertDialog(product);
      }
    }
  }

  deleteProductFromCart(Map<String, dynamic> product) async {
    if (product['product_size'] != null && product['product_color'] != null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({
        'product_color': product['product_color'],
        'product_size': product['product_size'],
        'product_id': product['product_id']
      });
      await supabase.from('products_variation').update({
        'product_quantity':
            res[0]['product_quantity'] + product['product_nb_order']
      }).match({
        'product_color': product['product_color'],
        'product_size': product['product_size'],
        'product_id': product['product_id']
      });
      await supabase.from('cart_products').delete().match({
        'product_name': product['product_name'],
        'product_color': product['product_color'],
        'product_size': product['product_size'],
      });
    } else if (product['product_size'] == null &&
        product['product_color'] == null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({'product_id': product['product_id']});
      await supabase.from('products_variation').update({
        'product_quantity':
            res[0]['product_quantity'] + product['product_nb_order']
      }).match({'product_id': product['product_id']});
      await supabase.from('cart_products').delete().match({
        'product_name': product['product_name'],
      });
    } else if (product['product_size'] == null &&
        product['product_color'] != null) {
      final res = await supabase
          .from('products_variation')
          .select('product_quantity')
          .match({
        'product_color': product['product_color'],
        'product_id': product['product_id']
      });
      await supabase.from('products_variation').update({
        'product_quantity':
            res[0]['product_quantity'] + product['product_nb_order']
      }).match({
        'product_color': product['product_color'],
        'product_id': product['product_id']
      });
      await supabase.from('cart_products').delete().match({
        'product_name': product['product_name'],
        'product_color': product['product_color'],
      });
    }
  }

  void showAlertDialog(Map<String, dynamic> product) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Do you want to delete this product ?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          // Cancel Button
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          // Delete Button
          TextButton(
            onPressed: () {
              deleteProductFromCart(product);
              Get.back(); // Close the dialog
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
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
  }

  popUpInCartScreen(Map<String, dynamic> product, context) async {
    List<Map<String, dynamic>> res = await supabase
        .from('products')
        .select(
            '*,variation:products_variation(product_size,product_color,product_quantity)')
        .eq('product_name', product['product_name']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUpInCart(product, res[0]);
      },
    );
  }
}
