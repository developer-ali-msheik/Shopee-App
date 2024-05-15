import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/cart_screen_controller.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';
import 'package:shopee_app/View/Mobile-Files/checkout1.dart';
import 'package:shopee_app/View/Mobile-Files/empty_cart_screen.dart';
import 'package:shopee_app/main.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final checkOutInjector = Get.find<CheckOutController>();

  final cartControllerInjector = Get.find<CartController>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    Stream<List<Map<String, dynamic>>> cartProducts = supabase
        .from('cart_products')
        .stream(primaryKey: ['id']).eq(
            'user_id', box.read('userId') ?? box.read('googleId'));

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: cartProducts,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Image.asset(
                'assets/images/loadingGif.gif',
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('unknown error, try again later')),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const EmptyCart();
        }
        double totalPrice = 0;
        for (var product in snapshot.data!) {
          totalPrice += product['product_total_price'];
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blueColor,
                fontSize: 27,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: GetBuilder<CartController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final ss = snapshot.data!;
                            return Slidable(
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      cartControllerInjector
                                          .deleteProductFromCart(ss[index]);
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: SizedBox(
                                  height: screenHeight * 0.22,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: SizedBox(
                                          height: screenHeight * 0.16,
                                          width: screenWidth * 0.42,
                                          child: GestureDetector(
                                            onTap: () {
                                              cartControllerInjector
                                                  .popUpInCartScreen(
                                                      ss[index], context);
                                            },
                                            child: Image.network(
                                              ss[index]['product_image'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstantText(
                                                ss[index]['product_name'],
                                                18,
                                                FontWeight.bold,
                                                greyColors,
                                              ),
                                              const SizedBox(height: 8),
                                              ConstantText(
                                                'Price: \$${ss[index]['product_total_price'].toStringAsFixed(2)}',
                                                15,
                                                FontWeight.bold,
                                                blueColor,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      cartControllerInjector
                                                          .addProductsNbOrder(
                                                              ss[index]);
                                                    },
                                                    icon: const Icon(Icons.add),
                                                  ),
                                                  ConstantText(
                                                    ss[index]
                                                            ['product_nb_order']
                                                        .toStringAsFixed(0),
                                                    18,
                                                    FontWeight.bold,
                                                    greyColor800,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      cartControllerInjector
                                                          .decrementProductNbOrder(
                                                              ss[index]);
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstantText(
                                  'TOTAL',
                                  17,
                                  FontWeight.bold,
                                  greyColor800,
                                ),
                                ConstantText(
                                  '${totalPrice.toStringAsFixed(2)} \$',
                                  15,
                                  FontWeight.bold,
                                  blueColor,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const CheckOutScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blueColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: const ConstantText(
                                  'CheckOut',
                                  19,
                                  FontWeight.bold,
                                  Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
