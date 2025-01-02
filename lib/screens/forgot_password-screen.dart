import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:online_groceries_app/Widget/BackgroundWidget.dart';
import 'package:online_groceries_app/Widget/custom_elevated_button.dart';
import 'package:online_groceries_app/Widget/custom_text_field.dart';
import 'package:online_groceries_app/themes/app_theme.dart';
import 'package:online_groceries_app/Widget/bottom_message_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? email;

  const ForgotPasswordScreen({super.key, this.email});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isLoading = false; // To show loading spinner
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;
  final _debounceDuration = const Duration(milliseconds: 300);
  late final VoidCallback _debouncedValidation;

  @override
  void initState() {
    super.initState();
    // Adding the listener for debounce validation
    _emailController.addListener(() {
      _debouncedValidation();
    });
    _debouncedValidation = debounce(_validateEmail, _debounceDuration);
  }

  @override
  void dispose() {
    _emailController.removeListener(_debouncedValidation); // Remove listener
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    String email = _emailController.text;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  // reset password
  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final url =
        Uri.parse('https://online-shop-hxhm.onrender.com/api/forget-password');
    final data = {'email': email};
    if (email.isEmpty) {
      showBottomMessage(context, 'Please enter your email', isSuccess: false);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));
      if (response.statusCode == 200) {
        showBottomMessage(context, 'Reset link sent to email', isSuccess: true);
        Get.offNamed('/sign_in');
      } else {
        showBottomMessage(context, 'This email is not registered',
            isSuccess: false);
        print(response.body);

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      showBottomMessage(context, 'An error occurred: $e', isSuccess: false);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyAppTheme.primaryColor,
      body: Stack(
        children: [
          const BackgroundWidget(
            imagePath: 'assets/images/png/groceries.png',
            imageWidth: 600,
            imageHeight: 600,
            blurSigmaX: 3.0,
            blurSigmaY: 3.0,
            overlayColor: MyAppTheme.primaryColor,
            overlayOpacity: 0.85,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/svg/logo_color.svg',
                    height: screenWidth * 0.2,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Reset Your Password',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: MyAppTheme.backgroundColor,
                    fontFamily: 'KantumruyPro',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.email == null
                      ? 'Please enter your email to reset your password.'
                      : 'Check your email for a password reset link.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: MyAppTheme.borderColor12,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  suffixIcon: _isEmailValid
                      ? const Icon(Icons.check, color: MyAppTheme.mainColor)
                      : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomElevatedButton(
                    isLoading: _isLoading,
                    onPressed: _resetPassword,
                    buttonText: 'Send Reset Link',
                    backgroundColor: MyAppTheme.mainColor,
                    textColor: MyAppTheme.primaryColor,
                    loaderColor: MyAppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Debounce helper function
  VoidCallback debounce(VoidCallback callback, Duration duration) {
    Timer? timer;
    return () {
      if (timer != null) {
        timer?.cancel();
      }
      timer = Timer(duration, callback);
    };
  }
}
