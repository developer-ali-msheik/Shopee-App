import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopee_app/Controller/checkout_controller.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final checkOutController = Get.find<CheckOutController>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardholderNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid card number';
                }
                // Add built-in validation for Visa card numbers
                if (!isVisaCard(value)) {
                  return 'Please enter a valid Visa card number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _expiryDateController,
              decoration: const InputDecoration(
                labelText: 'Expiry Date',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the expiry date';
                }
                // Add built-in validation for expiry date (MM/YY format)
                if (!isValidExpiryDate(value)) {
                  return 'Please enter a valid expiry date (MM/YY)';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cvvController,
              decoration: const InputDecoration(
                labelText: 'CVV',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the CVV';
                }
                // Add built-in validation for CVV (3 digits)
                if (!isValidCVV(value)) {
                  return 'Please enter a valid 3-digit CVV';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cardholderNameController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the cardholder name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  checkOutController.finalCheckOutPayment();
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to validate Visa card numbers
  bool isVisaCard(String value) {
    return RegExp(r'^4[0-9]{15}$').hasMatch(value);
  }

  // Function to validate expiry date (MM/YY format)
  bool isValidExpiryDate(String value) {
    return RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$').hasMatch(value);
  }

  // Function to validate CVV (3 digits)
  bool isValidCVV(String value) {
    return RegExp(r'^[0-9]{3}$').hasMatch(value);
  }
}
