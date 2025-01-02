import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_groceries_app/Widget/BackgroundWidget.dart';
import 'package:online_groceries_app/Widget/custom_elevated_button.dart';
import 'package:online_groceries_app/Widget/custom_text_field.dart';
import 'package:online_groceries_app/controller/auth_controller.dart';
import 'package:online_groceries_app/screens/home/home_screen.dart';
import 'package:online_groceries_app/screens/sign_in_screen.dart';
import 'package:online_groceries_app/themes/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:online_groceries_app/Widget/bottom_message_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false; // To show loading spinner

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

    if (!_isEmailValidSignUp(email)) {
      showBottomMessage(context, 'Incorrect email format!');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final Uri url =
        Uri.parse('https://online-shop-hxhm.onrender.com/api/register');
    final Map<String, String> data = {
      'name': username,
      'fullname': username,
      'email': email,
      'password': password,
      'role': 'user',
      'location': '',
      'phoneNumber': '',
      'profileImage': '',
      'is_reminder': 'true',
    };

    final AuthController _authController = AuthController();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        // Save token using AuthController
        await _authController.saveToken(token);

        if (token != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        showBottomMessage(
          context,
          responseData['message'] ?? 'Email already used',
        );
      }
    } catch (e) {
      showBottomMessage(
          context, 'Failed to connect to the server. Please try again.');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

// Assuming you have this function to validate the email format
  bool _isEmailValidSignUp(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');
    return emailRegex.hasMatch(email);
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
                  CustomTextField(
                    controller: _usernameController,
                    label: 'Username',
                    hint: 'enter your username',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'example@gmail.com',
                    suffixIcon: _isEmailValid
                        ? const Icon(Icons.check, color: MyAppTheme.mainColor)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
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
                    child: CustomElevatedButton(
                      isLoading: _isLoading,
                      onPressed: _isTermsAccepted
                          ? _handleRegister
                          : null, // Disable button if terms not accepted
                      buttonText: 'Sign Up',
                      backgroundColor: MyAppTheme.mainColor,
                      textColor: MyAppTheme.primaryColor,
                      loaderColor: MyAppTheme.primaryColor,
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
                    ],
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
