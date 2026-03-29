import 'package:flutter/material.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/ordersummary.dart';
import 'package:flutter_application_1/screen1.dart';
import 'package:flutter_application_1/screen2.dart';
import 'package:flutter_application_1/screen3.dart';
import 'package:flutter_application_1/screen4.dart';
import 'package:flutter_application_1/profile.dart';
import 'package:flutter_application_1/indiancuisine.dart';
import 'package:flutter_application_1/chickenrice.dart';
import 'package:flutter_application_1/nasipadang.dart';
import 'package:flutter_application_1/beverages.dart';
import 'package:flutter_application_1/time.dart';
import 'package:flutter_application_1/qrcode.dart';
import 'package:flutter_application_1/favourites.dart';

import 'package:flutter_application_1/globals.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),

          
          initialRoute: '/screen1',

          routes: {
            '/screen1': (context) => const Screen1(),
            '/screen2': (context) => const Screen2(),
            '/screen3': (context) => const Screen3(),
            '/screen4': (context) => Screen4(),
            '/profile': (context) => const Profile(),
            '/indian': (context) => const Indiancuisine(),
            '/chicken': (context) => const Chickenrice(),
            '/nasipadang': (context) => const Nasipadang(),
            '/beverages': (context) => const Beverages(),
            '/time': (context) => const PickupTimePage(),
            '/cart': (context) => const CartPage(),
            '/ordersummary': (context) => const OrderSummaryPage(),
            '/paynow': (context) => const PaymentPage(),
            '/favourites': (context) => const FavoritesPage(),
            
          },
        );
      },
    );
  }
}