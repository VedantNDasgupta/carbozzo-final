import 'package:carbozzo/components/firebase_api.dart';
import 'package:carbozzo/components/internet_provider.dart';
import 'package:carbozzo/components/signin_provider.dart';
import 'package:carbozzo/pages/intro_pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart'; // Import Provider

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Flame.device.fullScreen();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  // Initialize Hive
  await Hive.initFlutter();

  // Open a box
  await Hive.openBox("Habit_Database");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => SignInProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => InternetProvider()),
        ),
      ],
      child: Carbozzo(),
    ),
  );
}

class Carbozzo extends StatelessWidget {
  const Carbozzo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
