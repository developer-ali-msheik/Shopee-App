import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/home_screen_controller.dart';
import 'package:shopee_app/Controller/product_details_controller.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails(this.e, {super.key});

  final Map<String, dynamic> e;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final productDetailsInjector = Get.find<ProductController>();
  final homeControllerInjector = Get.find<HomeScreenController>();

  @override
  void initState() {
    homeControllerInjector.similarProductsFuntion(widget.e);
    productDetailsInjector.checkIfProductIsInFavorites(widget.e);

    super.initState();
  }

  GetStorage box = GetStorage();
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    double finalproductPrice = widget.e['product_price'] as double;
    if (widget.e['product_discount'] == 0) {
      finalproductPrice = widget.e['product_price'];
    } else if (widget.e['product_discount'] != 0) {
      final price =
          widget.e['product_price'] * widget.e['product_discount'] / 100;

      finalproductPrice = widget.e['product_price'] - price;
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.3,
                  child: PageView.builder(
                    itemCount: widget.e['products_multi_images'].length,
                    itemBuilder: (context, index) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: constraints.maxHeight,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              widget.e['products_multi_images'][index],
                              fit: BoxFit.fill,
                              width: screenWidth * 0.9,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        widget.e['product_name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    GetX<ProductController>(
                      builder: (controller) {
                        return IconButton(
                          onPressed: () async {
                            productDetailsInjector
                                .addOrDeleteProductFromFavorites(
                                    widget.e, finalproductPrice);
                          },
                          icon: Icon(
                            Icons.favorite,
                            size: 35,
                            color: productDetailsInjector.exists.value == false
                                ? Colors.grey.shade700
                                : Colors.blue,
                          ),
                        );
                      },
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Text(
                      'Price:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      '${finalproductPrice.toStringAsFixed(2)} \$',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.blue,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                widget.e['category_id'] == 3
                    ? const SizedBox(
                        height: 0,
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.015),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Product Variations:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey.shade800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Row(
                              children: [
                                for (var product in widget.e['variation'])
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        productDetailsInjector
                                                .productColor.value =
                                            product['product_color'] ?? '';
                                        productDetailsInjector
                                                .productSize.value =
                                            product['product_size'] ?? '';

                                        setState(() {
                                          selectedOption =
                                              '${product['product_size']}-${product['product_color']}';
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        surfaceTintColor: Colors.blue,
                                        elevation: 10,
                                        shadowColor: greyColors,
                                        shape: const RoundedRectangleBorder(),
                                        foregroundColor: Colors.black,
                                        backgroundColor: selectedOption ==
                                                '${product['product_size']}-${product['product_color']}'
                                            ? Colors.lightBlue
                                            : null,
                                      ),
                                      child: Text(
                                        '${product['product_size']}-${product['product_color']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: selectedOption ==
                                                  '${product['product_size']}-${product['product_color']}'
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  '${widget.e['description']}.',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 17,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                SizedBox(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      productDetailsInjector.checkProductCategory(
                          widget.e, finalproductPrice);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        letterSpacing: 1.5,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.035),
                Text(
                  'Similar Category Products:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  height: screenHeight * 0.24,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeControllerInjector.similarProduct.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.3,
                    ),
                    itemBuilder: (context, index) {
                      final products = homeControllerInjector.similarProduct;
                      return GestureDetector(
                        onTap: () {
                          box.write('productId', products[index]['id']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(products[index]),
                            ),
                          );
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
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                '${products[index]['product_price']} \$',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  '©2024-ShopeeCorp-Products',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
