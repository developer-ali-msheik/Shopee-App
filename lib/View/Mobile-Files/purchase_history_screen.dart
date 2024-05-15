import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';
import 'package:shopee_app/main.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({super.key});

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  final checkOutInjector = Get.find<CheckOutController>();
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Stream<List<Map<String, dynamic>>> productsStream = supabase
        .from('history_of_purchases')
        .stream(primaryKey: ['id']).eq('php_user_id_for_order_history',
            box.read('userId') ?? box.read('googleId'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Of Purchases'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Retrieve your orders.',
                  middleText: '',
                  middleTextStyle:
                      const TextStyle(color: Colors.transparent, fontSize: 0),
                  cancel: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 17),
                      )),
                  confirm: ElevatedButton(
                      onPressed: () {
                        if (box.read('emptyPurchase') == 'yes') {
                          checkOutInjector.retrieveDeletedOrderes();
                        } else {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Products Already Fetched',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                  titlePadding: const EdgeInsets.all(20),
                  titleStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                );
              },
              icon: const Icon(
                Icons.more_vert,
                size: 30.0,
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: productsStream,
            builder: (context, snapshot) {
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
                if (snapshot.data!.isEmpty) {
                  box.write('emptyPurchase', 'yes');
                } else {
                  box.write('emptyPurchase', 'no');
                }
                return const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No orders Yet',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ));
              }
              if (snapshot.data!.isEmpty) {
                box.write('emptyPurchase', 'yes');
              } else {
                box.write('emptyPurchase', 'no');
              }

              return Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Note: ** Your purchase history will be auto deleted every 30-days',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: screenHeight,
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 30,
                          );
                        },
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Order History'),
                                    content: const Text(
                                        'Are you sure you want to delete this product-order history?'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text('Confirm'),
                                        onPressed: () {
                                          checkOutInjector
                                              .deleteProductFromOrderHistory(
                                                  snapshot.data![index]);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: ExpansionTile(
                              backgroundColor: Colors.grey.shade200,
                              leading: Image.network(
                                  snapshot.data![index]['product_image']),
                              iconColor: Colors.blue,
                              title: Text(
                                snapshot.data![index]['product_name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text(
                                            'Delivery-type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            snapshot.data![index]
                                                ['product_delivery_date'],
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          const SizedBox(width: 30),
                                          IconButton(
                                              onPressed: () {
                                                checkOutInjector
                                                    .deleteProductFromOrderHistory(
                                                        snapshot.data![index]);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 30.0,
                                              ))
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const Text(
                                            'Time ordered',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            snapshot.data![index]
                                                ['time_ordered_product'],
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Color :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              snapshot.data![index]
                                                      ['product_color'] ??
                                                  'null',
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                            SizedBox(
                                                width: screenWidth * 0.035),
                                            const Text(
                                              'Size :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              snapshot.data![index]
                                                      ['product_size'] ??
                                                  'null',
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                            SizedBox(
                                                width: screenWidth * 0.035),
                                            const Text(
                                              'Quantity :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              snapshot.data![index]
                                                  ['product_quantity'],
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                            SizedBox(
                                                width: screenWidth * 0.035),
                                            const Text(
                                              'Total :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              snapshot.data![index]
                                                  ['product_total_price'],
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
