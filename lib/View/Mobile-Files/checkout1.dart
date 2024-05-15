import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';
import 'package:shopee_app/View/Mobile-Files/checkout3.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final box = GetStorage();
  final checkOutController = Get.find<CheckOutController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: ConstantText(
          'Delivery Status',
          20,
          FontWeight.bold,
          greyColor800,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkOutController.tttt();
        },
        backgroundColor: blueColor,
        child: const Icon(
          Icons.arrow_right_alt_rounded,
          size: 40.0,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantText(
                  'Choose Your Delivery Plan',
                  screenHeight * 0.025,
                  FontWeight.bold,
                  greyColor800,
                ),
                SizedBox(height: screenHeight * 0.04),
                buildDeliveryOption(
                  title: 'Standard Delivery :',
                  description: 'Order will be delivered in 3-5 business days.',
                  value: '1',
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.06),
                buildDeliveryOption(
                  title: 'Next Day Delivery :',
                  description:
                      'Place your order before 6pm and your items will be delivered next day.',
                  value: '2',
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.06),
                buildDeliveryOption(
                  title: 'Nominated Delivery :',
                  description:
                      'Pick a particular date from the calendar and your order will be delivered on selected date.',
                  value: '3',
                  screenWidth: screenWidth,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Visibility(
                  visible: checkOutController.deliverynumber.value == '3'
                      ? true
                      : false,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          checkOutController.selectDate(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: blueColor),
                        child: const ConstantText(
                          'Choose a date',
                          16,
                          FontWeight.bold,
                          Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Obx(() => ConstantText(
                            checkOutController.dateChosen.value,
                            16,
                            FontWeight.bold,
                            greyColors,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeliveryOption({
    required String title,
    required String description,
    required String value,
    required double screenWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantText(
          title,
          screenWidth * 0.05,
          FontWeight.bold,
          greyColor800,
        ),
        SizedBox(height: screenWidth * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.only(right: screenWidth * 0.03),
              width: screenWidth * 0.65,
              child: ConstantTextWithAlign(
                description,
                screenWidth * 0.045,
                blueColor,
                TextAlign.center,
                FontWeight.bold,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.08,
              child: RadioListTile(
                activeColor: blueColor,
                value: value,
                groupValue: checkOutController.deliverynumber.value,
                onChanged: (val) {
                  setState(
                    () {
                      checkOutController.deliverynumber.value = val.toString();
                      checkOutController.deliveryOption.value = description;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
