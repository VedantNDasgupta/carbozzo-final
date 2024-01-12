import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:carbozzo/components/nav_bar.dart';
import 'package:carbozzo/pages/intro_pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      checkFirstSeen();
    });
  }

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenOnboarding') ?? false);

    if (_seen) {
      // If the user has seen the onboarding screen before
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
      );
    } else {
      // If it's the first time, show the onboarding screen
      await prefs.setBool('seenOnboarding', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Image.asset('lib/images/final.png'),
          ),
          SizedBox(height: 1), // Add some spacing between image and text
          Text(
            'Crafted with Love.\nCoded for the Planet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 21,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      nextScreen: const BottomNavBar(),
      splashIconSize: 350,
      duration: 6000,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
