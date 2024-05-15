import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  late PageController pagecontroller;
  int currentPageIndex = 0;
  pageUpdate(int index) {
    currentPageIndex = index;
    update();
  }

  nextPageSlider() {
    currentPageIndex++;
    pagecontroller.animateToPage(
      currentPageIndex,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onInit() {
    pagecontroller = PageController();
    super.onInit();
  }
}
