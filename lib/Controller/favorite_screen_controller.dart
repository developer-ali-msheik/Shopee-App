import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/View/Mobile-Files/product_details_screen.dart';
import 'package:shopee_app/main.dart';

class FavoriteController extends GetxController {
  GetStorage box = GetStorage();

  getToProductDetails(Map<String, dynamic> product) async {
    List<Map<String, dynamic>> res = await supabase
        .from('products')
        .select(
            '*,variation:products_variation(product_size,product_color,product_quantity)')
        .eq('product_name', product['product_name']);
    Get.to(() => ProductDetails(res[0]));
  }

  deleteProductFromFavorites(Map<String, dynamic> product) async {
    await supabase
        .from('favorite_products')
        .delete()
        .match({'product_name': product['product_name']});
  }
}
