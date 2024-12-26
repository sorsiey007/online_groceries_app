import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_groceries_app/screens/home/home_screen.dart';
import 'package:online_groceries_app/screens/sign_in_screen.dart';
import 'package:online_groceries_app/themes/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:online_groceries_app/themes/bottom_message_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  bool _isEmailValid = false;
  bool _isTermsAccepted = false; // Variable to track checkbox status
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    String email = _emailController.text;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  Future<void> _handleRegister() async {
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showBottomMessage(context, 'Please fill in all fields');
      return;
    }

    if (!_isTermsAccepted) {
      showBottomMessage(
          context, 'You must accept the Terms of Service and Privacy Policy');
      return;
    }

    final Uri url =
        Uri.parse('https://online-shop-hxhm.onrender.com/api/register');
    final Map<String, String> data = {
      'name': username, // Username
      'fullname': username, // Full name (same as username here)
      'email': email, // User's email
      'password': password, // Password
      'role': 'user', // Default role is 'user'
      'location': '', // Optional: Add location if needed
      'phoneNumber': '', // Optional: Add phone number if needed
      'profileImage': '', // Optional: Add profile image if needed
      'is_reminder': 'true', // Optional: Assuming this is required
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        showBottomMessage(context, 'Sign-up successful!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if (response.statusCode == 400) {
        showBottomMessage(
            context, responseData['message'] ?? 'Sign-up failed: Invalid data');
      } else {
        showBottomMessage(context, 'Sign-up failed: Unexpected error');
      }
    } catch (e) {
      showBottomMessage(
          context, 'Failed to connect to the server. Please try again.');
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
          ),
          hintStyle: const TextStyle(
            fontSize: 16,
            color: MyAppTheme.borderColor12,
            fontFamily: 'KantumruyPro',
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
                    'Sign Up',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: MyAppTheme.backgroundColor,
                      fontFamily: 'KantumruyPro',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create a new account',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: MyAppTheme.borderColor12,
                      fontFamily: 'KantumruyPro',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    hint: 'enter your username',
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
                    hint: 'enter your password',
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isTermsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTermsAccepted = value ?? false;
                          });
                        },
                        activeColor: MyAppTheme.mainColor,
                        checkColor: MyAppTheme.primaryColor,
                        side: const BorderSide(color: MyAppTheme.borderColor12),
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              // Navigate to Terms of Service and Privacy Policy screen
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: MyAppTheme.borderColor12,
                                        fontFamily: 'KantumruyPro',
                                        height: 1.5,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text:
                                                'By continuing, you agree to our ',
                                            style: TextStyle(
                                              fontSize: 14,
                                            )),
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: MyAppTheme.mainColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to the Terms of Service page or show a dialog
                                            },
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: MyAppTheme.mainColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to the Privacy Policy page or show a dialog
                                            },
                                        ),
                                        const TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isTermsAccepted
                          ? _handleRegister
                          : null, // Disable button if terms not accepted
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyAppTheme.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: MyAppTheme.primaryColor,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        },
                        child: Text(
                          'Sign In',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void Function() debounce(VoidCallback callback, Duration duration) {
  Timer? timer;
  return () {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(duration, callback);
  };
}
