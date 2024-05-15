import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/home_screen_controller.dart';
import 'package:shopee_app/View/Mobile-Files/product_details_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen(this.title, {super.key});
  final String title;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  GetStorage box = GetStorage();
  final homeScreenControllerInjector = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    final x = widget.title;
    final List<Map<String, dynamic>> products;
    if (x == 'gadgets') {
      products = homeScreenControllerInjector.gadgetProducts;
    } else if (x == 'clothes') {
      products = homeScreenControllerInjector.clotheProducts;
    } else if (x == 'kitchens') {
      products = homeScreenControllerInjector.kitchenProducts;
    } else {
      products = homeScreenControllerInjector.gameProducts;
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth / 13),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<HomeScreenController>(
            builder: (controller) {
              return SizedBox(
                height: screenheight,
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.9),
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        box.write('productId', products[index]['id']);

                        Get.to(() => ProductDetails(products[index]));
                      },
                      child: Card(
                        surfaceTintColor: Colors.blue.shade100,
                        shadowColor: Colors.blue,
                        elevation: 10,
                        child: Column(
                          children: [
                            Image.network(
                              products[index]['product_image'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                products[index]['product_name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(
                              height: screenheight * 0.01,
                            ),
                            Text(
                              '${products[index]['product_price'].toString()} \$',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
