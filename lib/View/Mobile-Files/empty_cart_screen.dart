import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopee_app/View/Mobile-Files/navigation_station.dart';

class EmptyCart extends StatefulWidget {
  const EmptyCart({super.key});

  @override
  State<EmptyCart> createState() => _EmptyCartState();
}

class _EmptyCartState extends State<EmptyCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/emptyCart.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 22, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => const NavigationStation());
              },
              child: Text(
                'Return to Home',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
