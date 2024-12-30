import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PopupScreen extends StatefulWidget {
  const PopupScreen({super.key});

  @override
  _PopupScreenState createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _scaleController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define animations
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );

    _pulseAnimation = Tween<double>(begin: 1.4, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);

    // Navigate after a delay
    Timer(const Duration(seconds: 3), checkLogin);
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    _fadeController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> checkLogin() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      Get.offNamed('/home');
      print('User is logged in');
    } else {
      Get.offNamed('/starting');
      print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      backgroundColor: const Color(0xFFEB5E28), // Custom background color
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo with pulse effect
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: SvgPicture.asset(
                        'assets/images/svg/logo.svg',
                        height: 60,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Subtitle logo
                SvgPicture.asset(
                  'assets/images/svg/subtitle_logo.svg',
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
