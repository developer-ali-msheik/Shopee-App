import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';
import 'package:shopee_app/View/Mobile-Files/checkout2.dart';
import 'package:shopee_app/View/Mobile-Files/checkout4.dart';

class CheckOutScreen3 extends StatefulWidget {
  const CheckOutScreen3({super.key});

  @override
  State<CheckOutScreen3> createState() => _CheckOutScreen3State();
}

class _CheckOutScreen3State extends State<CheckOutScreen3> {
  final GetStorage box = GetStorage();
  final CheckOutController checkOutController = Get.find<CheckOutController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: ConstantText(
          'Your Products',
          22,
          FontWeight.bold,
          greyColor800,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.25,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(width: screenWidth * 0.05);
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: checkOutController.finalProducts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColors),
                      ),
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.2,
                      child: Image.network(
                        checkOutController.finalProducts[index]
                            ['product_image'],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConstantText(
                    'Total To Pay :',
                    18,
                    FontWeight.bold,
                    greyColor800,
                  ),
                  GetX<CheckOutController>(
                    builder: ((controller) {
                      return ConstantText(
                        '${checkOutController.totalPriceToPay.value.toStringAsFixed(2)} \$',
                        16,
                        FontWeight.bold,
                        blueColor,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConstantText(
                    'Total Products :',
                    18,
                    FontWeight.bold,
                    greyColor800,
                  ),
                  GetX<CheckOutController>(
                    builder: ((controller) {
                      return ConstantText(
                        '${checkOutController.finalProducts.length}  Product(s)',
                        16,
                        FontWeight.bold,
                        blueColor,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ConstantText(
                'Your Address :',
                22,
                FontWeight.bold,
                greyColor800,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 25,
                      color: blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    ConstantText(
                      box.read('fullName'),
                      16,
                      FontWeight.normal,
                      blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.02),
                    const Icon(
                      Icons.location_on,
                      size: 25,
                      color: blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    ConstantText(
                      box.read('streetName'),
                      16,
                      FontWeight.normal,
                      blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.02),
                    const Icon(
                      Icons.location_city,
                      size: 25,
                      color: blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    ConstantText(
                      box.read('cityName'),
                      16,
                      FontWeight.normal,
                      blueColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_searching,
                      size: 25,
                      color: blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    ConstantText(
                      box.read('stateName'),
                      16,
                      FontWeight.normal,
                      blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.02),
                    const Icon(
                      Icons.public,
                      size: 25,
                      color: blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.02),
                    ConstantText(
                      box.read('countryName'),
                      16,
                      FontWeight.normal,
                      blueColor,
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    const Icon(
                      Icons.phone,
                      size: 25,
                      color: blueColor,
                    ),
                    ConstantText(
                      box.read('phonenumber'),
                      16,
                      FontWeight.normal,
                      blueColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.off(() => const UserAddress());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: const RoundedRectangleBorder(),
                ),
                child: const ConstantText(
                  'Change Address',
                  16,
                  FontWeight.bold,
                  Colors.white,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Visibility(
                visible: checkOutController.dateChosen.value.isNotEmpty,
                child: Row(
                  children: [
                    ConstantText(
                      'Arrival date for your order  : ',
                      16,
                      FontWeight.bold,
                      greyColor800,
                    ),
                    ConstantText(
                      checkOutController.dateChosen.value,
                      16,
                      FontWeight.bold,
                      blueColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const FinalPay());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const ConstantText(
                    'Final Checkout',
                    20,
                    FontWeight.bold,
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
