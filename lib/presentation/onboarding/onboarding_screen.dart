import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../core/routing/routes.dart';
import '../../core/services/local/cache_helper.dart';
import '../../core/theming/colors.dart';
import '../../core/theming/fonts.dart';
import '../../core/theming/locale_keys.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  void _next() async {
    if (_currentIndex == 2) {
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
        Loc.welcomeTo.getLocale(),
        Loc.welcomeToSubText.getLocale(),
        'assets/images/onboarding-1.png',
      ),
      OnboardingData(
        Loc.easyBooking.getLocale(),
        Loc.easyBookingSubText.getLocale(),
        'assets/images/onboarding-2.png',
      ),
      OnboardingData(
        Loc.enjoyTheRide.getLocale(),
        Loc.enjoyTheRideSubText.getLocale(),
        'assets/images/onboarding-3.png',
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              onboardingData[_currentIndex].image,
              height: AppConstants.screenHeight(context) * .65,
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
                "${onboardingData[_currentIndex].title} Turbo",
                style: AppFonts.inter28White600,
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
                style: AppFonts.inter18SubTextGrey400,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                DotsIndicator(
                  dotsCount: 3,
                  position: _currentIndex,
                  onTap: (index) {
                    _onSelectIndex(index);
                  },
                  decorator: DotsDecorator(
                    activeColor: AppColors.primaryGreen,
                    size: const Size.square(10.0),
                    activeSize: const Size(32.0, 10.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStateProperty.all(const Size(140, 50)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: _next,
                  child: Text(
                    _currentIndex == 2 ? Loc.getStarted : Loc.continueButton,
                    style: AppFonts.inter18SubTextGrey400.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.primaryRed),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
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
