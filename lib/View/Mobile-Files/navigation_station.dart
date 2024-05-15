import 'package:flutter/material.dart';
import 'package:shopee_app/View/Mobile-Files/cart_screen.dart';
import 'package:shopee_app/View/Mobile-Files/favorite_screen.dart';
import 'package:shopee_app/View/Mobile-Files/home_screen.dart';

class NavigationStation extends StatefulWidget {
  const NavigationStation({super.key});

  @override
  State<NavigationStation> createState() => _NavigationStationState();
}

class _NavigationStationState extends State<NavigationStation> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          CartScreen(),
          FavoriteScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey.shade800,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outlined,
            ),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
