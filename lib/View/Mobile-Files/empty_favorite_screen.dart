import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopee_app/View/Mobile-Files/navigation_station.dart';

class EmptyFavorites extends StatefulWidget {
  const EmptyFavorites({super.key});

  @override
  State<EmptyFavorites> createState() => _EmptyFavoritesState();
}

class _EmptyFavoritesState extends State<EmptyFavorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/emptyFavoritesIcon.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'No Favorites Added',
              style: TextStyle(fontSize: 22, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 25),
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
