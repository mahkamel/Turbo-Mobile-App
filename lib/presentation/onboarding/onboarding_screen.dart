import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/widgets/default_buttons.dart';

import '../../core/routing/routes.dart';
import '../../core/services/local/cache_helper.dart';
import '../../core/theming/colors.dart';
import '../../core/theming/fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  void _next() async {
    if (_currentIndex == 3) {
      CacheHelper.setData(key: "isFirstTime", value: false);
      context.pushNamedAndRemoveUntil(Routes.layoutScreen,
          predicate: (Route<dynamic> route) {
        return false;
      });
    } else {
      setState(() {
        _currentIndex = _currentIndex + 1;
      });
    }
  }

  void _onSelectIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<OnboardingData> onboardingData = [
      OnboardingData(
        "Welcome to DS Rent, your ultimate car rental experience!",
        "Let’s hit the road! Find the perfect ride for every journey.",
        'assets/images/onboarding-1.png',
      ),
      OnboardingData(
        "Booking made simple. Reserve your car in just a few taps.",
        "Safe and secure payments at your fingertips.",
        'assets/images/onboarding-2.png',
      ),
      OnboardingData(
        "Track your rental status and stay updated on the go.",
        "Need help? Our support team is just a tap away.",
        'assets/images/onboarding-3.png',
      ),
      OnboardingData(
        "You're all set! Ready to embark on your next adventure?",
        "Start your journey now!",
        'assets/images/onboarding-4.png',
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        width: AppConstants.screenWidth(context),
        height: AppConstants.screenHeight(context),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              AppColors.lightBlack,
              AppColors.onboardingBrown,
            ])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Image.asset(
              onboardingData[_currentIndex].image,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20.0,
                end: 20.0,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                onboardingData[_currentIndex].title,
                style: AppFonts.ibm24White600,
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20.0,
                end: 20.0,
              ),
              child: Text(
                onboardingData[_currentIndex].subtitle,
                textAlign: TextAlign.left,
                style: AppFonts.ibm16White400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                bottom: 20.0,
              ),
              child: Center(
                child: DotsIndicator(
                  dotsCount: 4,
                  position: _currentIndex,
                  onTap: (index) {
                    _onSelectIndex(index);
                  },
                  decorator: DotsDecorator(
                    color: AppColors.white,
                    activeColor: AppColors.primaryBlue,
                    size: const Size.square(10.0),
                    spacing: const EdgeInsets.only(right: 6),
                    activeSize: const Size(10.0, 10.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
            ),
            if (_currentIndex != 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          CacheHelper.setData(key: "isFirstTime", value: false);
                          context.pushNamedAndRemoveUntil(Routes.layoutScreen,
                              predicate: (Route<dynamic> route) {
                            return false;
                          });
                        },
                        child: Text(
                          "Skip",
                          style: AppFonts.ibm18White600.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                      fixedSize:
                          WidgetStateProperty.all<Size>(const Size(47, 47)),
                      shape: WidgetStateProperty.all(const CircleBorder()),
                    ),
                    onPressed: _next,
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            if (_currentIndex == 3)
              DefaultButton(
                function: () {
                  CacheHelper.setData(key: "isFirstTime", value: false);
                  context.pushNamedAndRemoveUntil(Routes.layoutScreen,
                      predicate: (Route<dynamic> route) {
                    return false;
                  });
                },
                height: 42,
                marginRight: 16,
                marginLeft: 16,
                marginBottom: 4,
                borderRadius: 20,
                color: AppColors.white,
                text: "Get Started",
                textColor: AppColors.primaryBlue,
                // marginTop: 4,
              ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;

  OnboardingData(this.title, this.subtitle, this.image);
}
