import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopee_app/Controller/onboarding_controller.dart';
import 'package:shopee_app/Data/onboarding_screen_data.dart';
import 'package:shopee_app/View/Mobile-Files/check_auth_screen.dart';

class MobileMainScreen extends StatefulWidget {
  const MobileMainScreen({super.key});

  @override
  State<MobileMainScreen> createState() => _MobileMainScreenState();
}

class _MobileMainScreenState extends State<MobileMainScreen> {
  OnBoardingScreenData onBoardingScreenDataInstance = OnBoardingScreenData();

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    bool isBoardingScreenShown = box.read('isOnboardScreenShown') ?? false;
    var onBoardingControllerInjector = Get.find<OnBoardingController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return isBoardingScreenShown
        ? const CheckAuth()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.045,
                  ),
                  SizedBox(
                    height: screenHeight * 0.63,
                    child: PageView.builder(
                      controller: onBoardingControllerInjector.pagecontroller,
                      onPageChanged: (pageIndex) {
                        onBoardingControllerInjector.pageUpdate(pageIndex);
                      },
                      itemCount:
                          onBoardingScreenDataInstance.onboardingTitles.length,
                      itemBuilder: ((context, i) {
                        return Column(
                          children: [
                            Text(
                              onBoardingScreenDataInstance.onboardingTitles[i],
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800),
                            ),
                            SizedBox(
                              height: screenHeight * 0.035,
                            ),
                            SizedBox(
                              height: screenHeight * 0.3,
                              child: Image.asset(
                                'assets/images/onboarding${i + 1}.PNG',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),
                            SizedBox(
                              width: screenWidth * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    onBoardingScreenDataInstance
                                        .onBoardingDescriptions[i],
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                  GetBuilder<OnBoardingController>(
                    builder: (OnBoardingController controller) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            onBoardingScreenDataInstance
                                .onboardingTitles.length,
                            (index) => AnimatedContainer(
                              curve: Curves.easeInOut,
                              duration: const Duration(microseconds: 750),
                              margin: const EdgeInsets.only(left: 20),
                              width: onBoardingControllerInjector
                                          .currentPageIndex ==
                                      index
                                  ? screenWidth * 0.12
                                  : 10,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.055,
                  ),
                  Column(
                    children: [
                      GetBuilder<OnBoardingController>(
                        builder: (GetxController controller) {
                          final isEnd =
                              onBoardingControllerInjector.currentPageIndex ==
                                  onBoardingScreenDataInstance
                                          .onboardingTitles.length -
                                      1;
                          return SizedBox(
                            width: screenWidth * 0.5,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isEnd) {
                                  // Handle registration logic
                                  box.write('isOnboardScreenShown', true);
                                  Get.offAll(() => const CheckAuth());
                                } else {
                                  onBoardingControllerInjector.nextPageSlider();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  backgroundColor: isEnd
                                      ? Colors.blue
                                      : Colors.grey.shade300),
                              child: Text(
                                isEnd ? 'Get Started' : 'Next',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                    letterSpacing: 1.5),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.022,
                      ),
                      SizedBox(
                        width: screenWidth * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            box.write('isOnboardScreenShown', true);
                            Get.offAll(() => const CheckAuth());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 1.5),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
