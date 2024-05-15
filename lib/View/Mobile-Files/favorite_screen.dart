import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/favorite_screen_controller.dart';
import 'package:shopee_app/View/Mobile-Files/empty_favorite_screen.dart';
import 'package:shopee_app/main.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final box = GetStorage();
  final favoriteControllerInjector = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    Stream<List<Map<String, dynamic>>> favoriteProducts = supabase
        .from('favorite_products')
        .stream(primaryKey: ['id']).eq(
            'user_id', box.read('userId') ?? box.read('googleId'));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: favoriteProducts,
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
            body: Center(child: Text('unkown error, try again later')),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const EmptyFavorites();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Favorites',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 27,
                  letterSpacing: 1.2),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: SizedBox(
                          height: screenHeight * 0.16,
                          width: screenWidth * 0.42,
                          child: GestureDetector(
                            onTap: () {
                              favoriteControllerInjector
                                  .getToProductDetails(product);
                            },
                            child: Image.network(
                              product['product_image'],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['product_name'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Price: \$${product['product_price']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  favoriteControllerInjector
                                      .deleteProductFromFavorites(product);
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                              ),
                            )
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
