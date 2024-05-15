import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/main.dart';

class HomeScreenController extends GetxController {
  GetStorage box = GetStorage();

  List<Map<String, dynamic>> res = [];
  RxBool homeScreenLoading = false.obs;
  List<Map<String, dynamic>> categoryData = [];
  List<Map<String, dynamic>> similarProduct = [];
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> gadgetProducts = [];
  List<Map<String, dynamic>> clotheProducts = [];
  List<Map<String, dynamic>> kitchenProducts = [];
  List<Map<String, dynamic>> gameProducts = [];
  List<Map<String, dynamic>> bestSellingProducts = [];
  List<Map<String, dynamic>> discountedProducts = [];
  List<Map<String, dynamic>> lowestToHighest = [];
  List<Map<String, dynamic>> highestToLowest = [];
  String whatToUse = '';
  RxBool changeUi = false.obs;

  RxString homeUiChanged = ''.obs;

  void sortFromlowestToHighest() {
    lowestToHighest = List.from(res);
    lowestToHighest
        .sort((a, b) => a['product_price'].compareTo(b['product_price']));
  }

  void sortFromHighestToLowest() {
    highestToLowest = List.from(res);
    highestToLowest
        .sort((a, b) => b['product_price'].compareTo(a['product_price']));
  }

  void lowerPressed() {
    if (changeUi.value == false) {
      sortFromlowestToHighest();
      whatToUse = 'lower';

      changeUi.value = !changeUi.value;
    } else if (changeUi.value == true) {
      if (whatToUse == 'higher') {
        sortFromlowestToHighest();
        whatToUse = 'lower';
        changeUi.value = !changeUi.value;
        changeUi.value = !changeUi.value;
      } else {
        changeUi.value = !changeUi.value;
        whatToUse = '';

        lowestToHighest = [];
      }
    }
  }

  void higherPressed() {
    if (changeUi.value == false) {
      sortFromHighestToLowest();
      whatToUse = 'higher';
      changeUi.value = !changeUi.value;
    } else if (changeUi.value == true) {
      if (whatToUse == 'lower') {
        sortFromHighestToLowest();
        whatToUse = 'higher';
        changeUi.value = !changeUi.value;
        changeUi.value = !changeUi.value;
      } else {
        changeUi.value = !changeUi.value;
        whatToUse = '';
        highestToLowest = [];
      }
    }
  }

  returnProducts() async {
    homeScreenLoading.value = true;
    res = await supabase.from('products').select(
        '*,variation:products_variation(product_size,product_color,product_quantity)');
    allProducts = res
        .where((element) =>
            element['product_discount'] == 0 &&
            element['best_selling'] == false)
        .toList();
    homeScreenLoading.value = false;
    gadgetProducts = res
        .where((element) =>
            element['category_id'] == 2 && element['product_discount'] == 0)
        .toList();
    clotheProducts = res
        .where((element) =>
            element['category_id'] == 1 && element['product_discount'] == 0)
        .toList();
    kitchenProducts = res
        .where((element) =>
            element['category_id'] == 4 && element['product_discount'] == 0)
        .toList();
    gameProducts = res
        .where((element) =>
            element['category_id'] == 3 && element['product_discount'] == 0)
        .toList();
    bestSellingProducts =
        res.where((element) => element['best_selling'] == true).toList();
    discountedProducts =
        res.where((element) => element['product_discount'] > 0).toList();
    update();
  }

  returnCategoryIcons() async {
    homeScreenLoading.value = true;
    categoryData = await supabase.from('catergories').select();
    homeScreenLoading.value = false;
  }

  similarProductsFuntion(Map<String, dynamic> product) async {
    similarProduct = res
        .where((element) =>
            element['category_id'] == product['category_id'] &&
            element['id'] != product['id'])
        .toList();
  }

  // writeIdAndEmailToStorage() async {
  //   homeScreenLoading.value = true;
  //   const url =
  //       'http://10.0.2.2/ISD_SHOPEE_APP flutter code/php_code/check_google_account.php';
  //   var request = await http.post(
  //     Uri.parse(url),
  //     body: {'user_email': box.read('googleEmailAddress')},
  //   );
  //   homeScreenLoading.value = false;
  //   if (request.statusCode == 200) {
  //     final response = jsonDecode(request.body);

  //     if (response['status'] == 'found') {
  //       box.write('googleId', response['user_id']);
  //     }
  //   }
  // }

  @override
  void onInit() {
    // writeIdAndEmailToStorage();
    returnProducts();
    returnCategoryIcons();
    super.onInit();
  }
}
