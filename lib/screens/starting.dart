import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:online_groceries_app/screens/sign_in_screen.dart';
import 'package:online_groceries_app/themes/app_theme.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with responsive scaling
          Positioned.fill(
            child: Image.asset(
              'assets/images/png/background.jpg',
              fit: BoxFit.cover,
              alignment: Alignment
                  .topCenter, // Ensures the background aligns to the top
            ),
          ),
          // Gradient overlay for better readability
          Positioned.fill(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(
                        0.5), // Darkens bottom for text readability
                  ],
                ),
              ),
            ),
          ),
          // Column to hold the content, aligned at the bottom
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight *
                    0.15), // Adjusting padding for better position
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Logo with responsive size
                Center(
                  child: SvgPicture.asset(
                    'assets/images/svg/main_logo.svg',
                    height:
                        screenWidth * 0.25, // Larger logo for better visibility
                  ),
                ),
                // Text below the logo with responsive font size
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      Text(
                        'Welcome \nto our store',
                        style: TextStyle(
                          fontFamily:
                              'KantumruyPro', // Applying KantumruyPro font here
                          fontSize: screenWidth *
                              0.09, // Font size adapted for readability
                          color: MyAppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.02), // Added space for better layout
                      Text(
                        'Get your groceries as fast as one hour',
                        style: TextStyle(
                          fontFamily:
                              'KantumruyPro', // Applying KantumruyPro font here
                          fontSize: screenWidth *
                              0.04, // Adjusted for better readability
                          color: MyAppTheme.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height:
                              screenHeight * 0.04), // Spacing for the button
                      // Custom button with modern design
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              MyAppTheme.mainColor, // Button background color
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                0.3, // Adjust button width responsively
                            vertical: screenHeight *
                                0.02, // Adjust button height responsively
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // More rounded corners
                          ),
                          elevation:
                              12, // Enhanced shadow for better visibility
                          textStyle: TextStyle(
                            color: MyAppTheme
                                .primaryColor, // Text color for the button
                            fontSize: screenWidth *
                                0.045, // Adjusted text size for better legibility
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const SignInScreen());
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontFamily:
                                'KantumruyPro', // Applying KantumruyPro font here
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: MyAppTheme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              screenHeight * 0.1), // More responsive spacing
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
