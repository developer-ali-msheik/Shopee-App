import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/home_screen_controller.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';
import 'package:shopee_app/Data/onboarding_screen_data.dart';
import 'package:shopee_app/View/Mobile-Files/category_screen.dart';
import 'package:shopee_app/View/Mobile-Files/notifications_screen.dart';
import 'package:shopee_app/View/Mobile-Files/product_details_screen.dart';
import 'package:shopee_app/View/Mobile-Files/profile_screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final profileInjector = Get.find<ProfileController>();

  OnBoardingScreenData onBoardingScreenDataInstance = OnBoardingScreenData();

  List<Map<String, dynamic>> filteredProducts = [];
  final homeScreenControllerInjector = Get.find<HomeScreenController>();
  TextEditingController searchBar = TextEditingController();

  GetStorage box = GetStorage();
  @override
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = onBoardingScreenDataInstance
        .imagesForCarousel
        .asMap()
        .entries
        .map((entry) {
      int idx = entry.key;
      String item = entry.value;

      return Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(197, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    onBoardingScreenDataInstance.homeScreenCarouselData[idx],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return GetX<HomeScreenController>(
      builder: ((controller) {
        return homeScreenControllerInjector.homeScreenLoading.value == true
            ? Scaffold(
                body: Center(
                  child: Image.asset(
                    'assets/images/loadingGif.gif',
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(),
                drawer: const Drawer(
                  child: ProfileScreen(),
                ),
                body: SafeArea(
                  child: LiquidPullToRefresh(
                    springAnimationDurationInMilliseconds: 300,
                    showChildOpacityTransition: false,
                    height: 50.0,
                    color: Colors.blue,
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.7,
                                  child: Autocomplete<Map<String, dynamic>>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      return homeScreenControllerInjector.res
                                          .where((element) =>
                                              element['product_name']
                                                  .toLowerCase()
                                                  .contains(textEditingValue
                                                      .text
                                                      .toLowerCase()));
                                    },
                                    optionsViewBuilder: (
                                      BuildContext context,
                                      AutocompleteOnSelected<
                                              Map<String, dynamic>>
                                          onSelected,
                                      Iterable<Map<String, dynamic>> options,
                                    ) {
                                      return ListView.builder(
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final Map<String, dynamic> option =
                                              options.elementAt(index);
                                          return Material(
                                            child: ListTile(
                                              subtitle: Text(
                                                  option['product_price']
                                                      .toStringAsFixed(2)),
                                              leading: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Image.network(
                                                    option['product_image']),
                                              ),
                                              onTap: () {
                                                Get.to(() =>
                                                    ProductDetails(option));
                                              },
                                              title:
                                                  Text(option['product_name']),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    fieldViewBuilder: (
                                      BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted,
                                    ) {
                                      return TextField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        onSubmitted: (String value) {
                                          onFieldSubmitted();
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Find A Product',
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.blue,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.only(bottom: 5),
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            size: 25.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.05,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    child: IconButton(
                                      onPressed: () {
                                        Get.to(
                                            () => const NotificationScreen());
                                      },
                                      icon: const Icon(
                                        Icons.notifications_on,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenheight * 0.02,
                            ),
                            CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 1,
                                aspectRatio: 1.8,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                              ),
                              items: imageSliders,
                            ),
                            SizedBox(
                              height: screenheight * 0.01,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              width: screenWidth * 0.9,
                              height: screenheight * 0.15,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: homeScreenControllerInjector
                                        .categoryData.length,
                                    itemBuilder: ((context, index) {
                                      final category =
                                          homeScreenControllerInjector
                                                  .categoryData[index]
                                              ['category_name'];
                                      final String imageData =
                                          homeScreenControllerInjector
                                                  .categoryData[index]
                                              ['category_image'];

                                      final itemWidth =
                                          constraints.maxWidth / 4;
                                      final itemHeight = constraints.maxHeight;

                                      return SizedBox(
                                        width: itemWidth,
                                        height: itemHeight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  () => CategoryScreen(
                                                    category,
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 21.5),
                                                child: SizedBox(
                                                  width: itemWidth * 0.7,
                                                  height: itemHeight * 0.5,
                                                  child: Image.network(
                                                    imageData,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: itemHeight * 0.05,
                                            ),
                                            Text(
                                              category.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade800,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: screenheight * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Products for you',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.grey.shade800),
                                ),
                                PopupMenuButton(
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem(
                                        value: 'lowest_price',
                                        child: Text('Filter by Lowest Price'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'highest_price',
                                        child: Text('Filter by Highest Price'),
                                      ),
                                    ];
                                  },
                                  tooltip: 'Filter our products',
                                  onSelected: (value) {
                                    // Handle the selection of filter options here
                                    switch (value) {
                                      case 'lowest_price':
                                        homeScreenControllerInjector
                                            .lowerPressed();
                                        break;
                                      case 'highest_price':
                                        homeScreenControllerInjector
                                            .higherPressed();
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.filter_list,
                                    color: Colors.blue,
                                    size: 40.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenheight * 0.03,
                            ),
                            GetX<HomeScreenController>(
                              builder: ((controller) {
                                return homeScreenControllerInjector
                                            .changeUi.value ==
                                        false
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.9,
                                            height: screenheight * 0.35,
                                            child: LayoutBuilder(
                                              builder: ((context, constraints) {
                                                return ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      width:
                                                          constraints.maxWidth *
                                                              0.065,
                                                    );
                                                  },
                                                  itemCount:
                                                      homeScreenControllerInjector
                                                          .allProducts.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        box.write(
                                                            'categoryId',
                                                            homeScreenControllerInjector
                                                                        .allProducts[
                                                                    index][
                                                                'category_id']);
                                                        Get.to(
                                                          () => ProductDetails(
                                                            homeScreenControllerInjector
                                                                    .allProducts[
                                                                index],
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 2),
                                                            ),
                                                            width: constraints
                                                                .maxWidth,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              child:
                                                                  Image.network(
                                                                homeScreenControllerInjector
                                                                            .allProducts[
                                                                        index][
                                                                    'product_image'],
                                                                width: double
                                                                    .infinity,
                                                                height: constraints
                                                                        .maxHeight *
                                                                    0.6,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                screenheight *
                                                                    0.02,
                                                          ),
                                                          Text(
                                                            homeScreenControllerInjector
                                                                        .allProducts[
                                                                    index][
                                                                'product_name'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 22),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                screenheight *
                                                                    0.01,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${homeScreenControllerInjector.allProducts[index]['product_price'].toString()} \$',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    screenWidth *
                                                                        0.03,
                                                              ),
                                                              SizedBox(
                                                                  width: 50,
                                                                  height: 50,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/foryou.gif')),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                );
                                              }),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight * 0.01,
                                          ),
                                          Text(
                                            'Best Selling',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.grey.shade800),
                                          ),
                                          SizedBox(
                                            height: screenheight * 0.04,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.9,
                                            height: screenheight * 0.35,
                                            child: LayoutBuilder(
                                              builder: ((context, constraints) {
                                                return ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      width:
                                                          constraints.maxWidth *
                                                              0.065,
                                                    );
                                                  },
                                                  itemCount:
                                                      homeScreenControllerInjector
                                                          .bestSellingProducts
                                                          .length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        box.write(
                                                            'categoryId',
                                                            homeScreenControllerInjector
                                                                        .bestSellingProducts[
                                                                    index][
                                                                'category_id']);
                                                        Get.to(
                                                          () => ProductDetails(
                                                            homeScreenControllerInjector
                                                                    .bestSellingProducts[
                                                                index],
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 2),
                                                            ),
                                                            width: constraints
                                                                .maxWidth,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              child:
                                                                  Image.network(
                                                                homeScreenControllerInjector
                                                                            .bestSellingProducts[
                                                                        index][
                                                                    'product_image'],
                                                                width: double
                                                                    .infinity,
                                                                height: constraints
                                                                        .maxHeight *
                                                                    0.6,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                screenheight *
                                                                    0.02,
                                                          ),
                                                          Text(
                                                            homeScreenControllerInjector
                                                                        .bestSellingProducts[
                                                                    index][
                                                                'product_name'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 22),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                screenheight *
                                                                    0.01,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${homeScreenControllerInjector.bestSellingProducts[index]['product_price'].toString()} \$',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    screenWidth *
                                                                        0.03,
                                                              ),
                                                              const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color:
                                                                    Colors.blue,
                                                                size: 30.0,
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    screenWidth *
                                                                        0.03,
                                                              ),
                                                              const Text(
                                                                '100 % ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                );
                                              }),
                                            ),
                                          ),
                                          Text(
                                            'Offers',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.grey.shade800),
                                          ),
                                          SizedBox(
                                            height: screenheight * 0.04,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.9,
                                            height: screenheight * 0.35,
                                            child: LayoutBuilder(
                                              builder: ((context, constraints) {
                                                return ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      width:
                                                          constraints.maxWidth *
                                                              0.065,
                                                    );
                                                  },
                                                  itemCount:
                                                      homeScreenControllerInjector
                                                          .discountedProducts
                                                          .length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    double originalPrice =
                                                        homeScreenControllerInjector
                                                                .discountedProducts[
                                                            index]['product_price'];
                                                    double discount =
                                                        homeScreenControllerInjector
                                                                        .discountedProducts[
                                                                    index][
                                                                'product_discount'] /
                                                            100;
                                                    double discountedPrice =
                                                        originalPrice -
                                                            (originalPrice *
                                                                discount);

                                                    return GestureDetector(
                                                      onTap: () {
                                                        box.write(
                                                            'categoryId',
                                                            homeScreenControllerInjector
                                                                        .discountedProducts[
                                                                    index][
                                                                'category_id']);
                                                        Get.to(() => ProductDetails(
                                                            homeScreenControllerInjector
                                                                    .discountedProducts[
                                                                index]));
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 2),
                                                            ),
                                                            width: constraints
                                                                .maxWidth,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              child:
                                                                  Image.network(
                                                                homeScreenControllerInjector
                                                                            .discountedProducts[
                                                                        index][
                                                                    'product_image'],
                                                                width: double
                                                                    .infinity,
                                                                height: constraints
                                                                        .maxHeight *
                                                                    0.6,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                screenheight *
                                                                    0.02,
                                                          ),
                                                          Text(
                                                            homeScreenControllerInjector
                                                                        .discountedProducts[
                                                                    index][
                                                                'product_name'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 18),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                screenheight *
                                                                    0.02,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${originalPrice.toStringAsFixed(2)} \$',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              const SizedBox(
                                                                  width: 7),
                                                              const Icon(
                                                                  Icons
                                                                      .local_offer_sharp,
                                                                  color: Colors
                                                                      .red), // Dummy icon for sale
                                                              const SizedBox(
                                                                  width: 7),
                                                              Text(
                                                                '${discountedPrice.toStringAsFixed(2)} \$',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: screenheight * 0.35,
                                        child: GridView.builder(
                                          itemCount: homeScreenControllerInjector
                                                      .whatToUse ==
                                                  'lower'
                                              ? homeScreenControllerInjector
                                                  .lowestToHighest.length
                                              : homeScreenControllerInjector
                                                  .highestToLowest.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  childAspectRatio: 0.9),
                                          itemBuilder: ((context, index) {
                                            final productImage =
                                                homeScreenControllerInjector
                                                            .whatToUse ==
                                                        'lower'
                                                    ? homeScreenControllerInjector
                                                            .lowestToHighest[
                                                        index]['product_image']
                                                    : homeScreenControllerInjector
                                                            .highestToLowest[
                                                        index]['product_image'];

                                            final productName =
                                                homeScreenControllerInjector
                                                            .whatToUse ==
                                                        'lower'
                                                    ? homeScreenControllerInjector
                                                            .lowestToHighest[
                                                        index]['product_name']
                                                    : homeScreenControllerInjector
                                                            .highestToLowest[
                                                        index]['product_name'];
                                            final productPrice =
                                                homeScreenControllerInjector
                                                            .whatToUse ==
                                                        'lower'
                                                    ? homeScreenControllerInjector
                                                            .lowestToHighest[
                                                        index]['product_price']
                                                    : homeScreenControllerInjector
                                                            .highestToLowest[
                                                        index]['product_price'];

                                            final productType =
                                                homeScreenControllerInjector
                                                            .whatToUse ==
                                                        'lower'
                                                    ? homeScreenControllerInjector
                                                        .lowestToHighest[index]
                                                    : homeScreenControllerInjector
                                                        .highestToLowest[index];

                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(() => ProductDetails(
                                                    productType));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shadowColor: blueColor,
                                                child: Column(
                                                  children: [
                                                    Image.network(
                                                      productImage,
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      child: Text(
                                                        productName,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${productPrice.toString()} \$',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child: Image.asset(
                                                            homeScreenControllerInjector
                                                                        .whatToUse ==
                                                                    'lower'
                                                                ? 'assets/images/arrowUp.png'
                                                                : 'assets/images/arrowDown.png',
                                                            color: Colors.blue,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                              }),
                            ),
                            SizedBox(
                              height: screenheight * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      profileInjector.launchFacebook();
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.blue,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      profileInjector.launchWhatsapp();
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      profileInjector.launcheInstagram();
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.instagram,
                                      color: Colors.orange.shade300,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: screenheight * 0.015,
                            ),
                            Text(
                              ' ©2024-CopyRight-ShopeeTeam',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: screenheight * 0.015,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
