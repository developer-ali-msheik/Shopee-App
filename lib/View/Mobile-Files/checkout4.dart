import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';
import 'package:shopee_app/View/Mobile-Files/navigation_station.dart';
import 'package:shopee_app/View/Mobile-Files/visa_form.dart';

class FinalPay extends StatefulWidget {
  const FinalPay({super.key});

  @override
  State<FinalPay> createState() => _FinalPayState();
}

class _FinalPayState extends State<FinalPay> {
  final box = GetStorage();
  final checkOutControllerInjector = Get.find<CheckOutController>();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                  onPressed: () {
                    Get.offAll(() => const NavigationStation());
                  },
                  icon: const Icon(
                    Icons.home,
                    size: 35.0,
                    color: Colors.blue,
                  )),
            ),
          )
        ],
        title: Text(
          'final Checkout',
          style: TextStyle(
              color: Colors.grey.shade800, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (checkOutControllerInjector.paymentOptionNumber.value == 0) {
            AwesomeDialog(
              barrierColor: Colors.blue,
              context: Get.context!,
              dialogType: DialogType.question,
              animType: AnimType.topSlide,
              body: Text(
                'Submit your order please.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              btnOk: TextButton(
                onPressed: () async {
                  Navigator.pop(Get.context!);

                  Get.snackbar('Thanks for your purchase,', 'happing shopping.',
                      duration: const Duration(seconds: 2),
                      shouldIconPulse: true,
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      dismissDirection: DismissDirection.vertical,
                      backgroundColor: blueColor,
                      colorText: Colors.white);
                  await checkOutControllerInjector.finalCheckOutPayment();
                  Get.offAll(() => const NavigationStation());
                },
                child: const Text(
                  'Confirm',
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
          } else if (checkOutControllerInjector.paymentOptionNumber.value ==
              1) {
            Get.defaultDialog(
              title: 'Enter Your  Details',
              titleStyle: TextStyle(color: Colors.grey.shade800, fontSize: 20),
              content: const PaymentForm(),
            );
          } else {
            Get.defaultDialog(
              title: 'Enter Your  Details',
              titleStyle: TextStyle(color: Colors.grey.shade800, fontSize: 20),
              content: const PaymentForm(),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.payment,
          size: 40.0,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, right: 10, left: 10),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.34,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Radio<int>(
                        activeColor: Colors.blue,
                        value: 0,
                        groupValue: checkOutControllerInjector
                            .paymentOptionNumber.value,
                        onChanged: (value) {
                          setState(() {
                            checkOutControllerInjector
                                .paymentOptionNumber.value = value!;
                          });
                        },
                      ),
                      title: Text(
                        'Cash on Delivery',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          fontSize: 19,
                        ),
                      ),
                      subtitle: const Text(
                        'Pay when the order is delivered',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/images/cashOnDelivery.png',
                        width: 35,
                        height: 35,
                        color: Colors.red,
                      ),
                    ),
                    ListTile(
                      leading: Radio<int>(
                        activeColor: Colors.blue,
                        value: 1,
                        groupValue: checkOutControllerInjector
                            .paymentOptionNumber.value,
                        onChanged: (value) {
                          setState(() {
                            checkOutControllerInjector
                                .paymentOptionNumber.value = value!;
                          });
                        },
                      ),
                      title: Text(
                        'Visa Card',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          fontSize: 19,
                        ),
                      ),
                      subtitle: const Text(
                        'Pay securely with your Visa card',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/images/visa.png',
                        width: 35,
                        height: 35,
                      ),
                    ),
                    ListTile(
                      leading: Radio<int>(
                        activeColor: Colors.blue,
                        value: 2,
                        groupValue: checkOutControllerInjector
                            .paymentOptionNumber.value,
                        onChanged: (value) {
                          setState(() {
                            checkOutControllerInjector
                                .paymentOptionNumber.value = value!;
                          });
                        },
                      ),
                      title: Text(
                        'Stripe',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          fontSize: 19,
                        ),
                      ),
                      subtitle: const Text(
                        'Pay using Stripe payment gateway',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/images/stripe.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.15,
              ),
              Text(
                ' ©2024 Shopee. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                'We appreciate your visit!',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
