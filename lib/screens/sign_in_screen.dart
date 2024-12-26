import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_groceries_app/screens/home/home_screen.dart';
import 'package:online_groceries_app/screens/sign_up_screen.dart';
import 'package:online_groceries_app/themes/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:online_groceries_app/themes/bottom_message_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false; // To show loading spinner
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailValid = false;
  final _debounceDuration = const Duration(milliseconds: 300);
  late final VoidCallback _debouncedValidation;

  @override
  void initState() {
    super.initState();
    _debouncedValidation = debounce(_validateEmail, _debounceDuration);
    _emailController.addListener(_debouncedValidation);
  }

  @override
  void dispose() {
    _emailController.removeListener(_debouncedValidation);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    String email = _emailController.text;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  Future<void> _signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showBottomMessage(context, 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final Uri url =
        Uri.parse('https://online-shop-hxhm.onrender.com/api/login');
    final Map<String, String> data = {'email': email, 'password': password};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        final responseData = json.decode(response.body);
        showBottomMessage(
            context, responseData['message'] ?? 'Invalid email or password');
      }
    } catch (_) {
      showBottomMessage(context, "Failed to connect to the server");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.only(bottom: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
            fontSize: 18,
            fontFamily: 'KantumruyPro',
            color: MyAppTheme.backgroundColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: MyAppTheme.borderColor12,
            fontFamily: 'KantumruyPro',
            fontWeight: FontWeight.w400,
          ),
          hintStyle: const TextStyle(
            fontSize: 16,
            color: MyAppTheme.borderColor12,
            fontFamily: 'KantumruyPro',
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyAppTheme.borderColor12),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyAppTheme.mainColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String assetName,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: MyAppTheme.borderColor12, width: 1),
          ),
        ),
        child: SvgPicture.asset(
          assetName,
          width: 70, // Set the size of the image to be bigger
          height: 70, // Set the size of the image to be bigger
          fit: BoxFit.contain, // Adjust the fit if needed
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/images/png/groceries.png',
              width: 600,
              height: 600,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: MyAppTheme.primaryColor.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
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
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                    'Sign in',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: MyAppTheme.backgroundColor,
                      fontFamily: 'KantumruyPro',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your email and password to log in',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: MyAppTheme.borderColor12,
                      fontFamily: 'KantumruyPro',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'example@gmail.com',
                    suffixIcon: _isEmailValid
                        ? const Icon(Icons.check, color: MyAppTheme.mainColor)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _obscurePassword
                            ? MyAppTheme.borderColor12
                            : MyAppTheme.mainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: MyAppTheme.borderColor12,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyAppTheme.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  MyAppTheme.primaryColor),
                            )
                          : Text(
                              'Sign in',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: MyAppTheme.primaryColor,
                                fontFamily: 'KantumruyPro',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: MyAppTheme.mainColor,
                            fontFamily: 'KantumruyPro',
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: MyAppTheme.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // The 'Or' label with styling
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: MyAppTheme.borderColor12),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or sign in with',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: MyAppTheme.borderColor12,
                            fontFamily: 'KantumruyPro',
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: MyAppTheme.borderColor12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        assetName: 'assets/images/svg/facebook_icon.svg',
                        onPressed: () {
                          // Facebook sign-in logic
                        },
                      ),
                      _buildSocialButton(
                        assetName: 'assets/images/svg/google_icon.svg',
                        onPressed: () {
                          // Google sign-in logic
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}