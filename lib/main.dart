import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries_app/screens/Popup_Screen.dart';
import 'package:online_groceries_app/screens/home/ShopScreen.dart';
import 'package:online_groceries_app/screens/home/home_screen.dart';
import 'package:online_groceries_app/screens/sign_up_screen.dart';
import 'package:online_groceries_app/screens/starting.dart';
import 'package:online_groceries_app/screens/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Define the custom color here
  static const Color mainColor = Color(0xFFEB5E28); // Your custom color code

  // Define the routes
  final List<GetPage> routes = [
    GetPage(name: '/', page: () => const PopupScreen()),
    GetPage(name: '/starting', page: () => const StartingScreen()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(name: '/sign_in', page: () => const SignInScreen()),
    GetPage(name: '/sign_up', page: () => const SignUpScreen()),
    GetPage(name: '/shop', page: () => ShopScreen()),

  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: routes,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor), // Use the custom colore
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: mainColor, // Set cursor color here
        ),
      ),
    );
  }
}
