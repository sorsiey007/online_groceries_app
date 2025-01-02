import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_groceries_app/Widget/BackgroundWidget.dart';
import 'package:online_groceries_app/Widget/custom_elevated_button.dart';
import 'package:online_groceries_app/Widget/custom_text_field.dart';
import 'package:online_groceries_app/controller/auth_controller.dart';
import 'package:online_groceries_app/screens/forgot_password-screen.dart';
import 'package:online_groceries_app/screens/home/home_screen.dart';
import 'package:online_groceries_app/screens/sign_up_screen.dart';
import 'package:online_groceries_app/themes/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:online_groceries_app/Widget/bottom_message_widget.dart';

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
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showBottomMessage(context, 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://online-shop-hxhm.onrender.com/api/login');
    final data = {'email': email, 'password': password};

    final AuthController _authController = AuthController();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        // Save token using AuthController
        await _authController.saveToken(token);
        print("token: $token");

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        final responseData = json.decode(response.body);
        final message = responseData['message'] ?? 'Invalid email or password';
        showBottomMessage(context, message, isSuccess: false);
      }
    } catch (e) {
      showBottomMessage(context, "Failed to connect to the server: $e", isSuccess: false);
    } finally {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(
                                email: _emailController.text),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: MyAppTheme.borderColor12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomElevatedButton(
                      isLoading: _isLoading,
                      onPressed: _signIn,
                      buttonText: 'Sign in',
                      backgroundColor: MyAppTheme.mainColor,
                      textColor: MyAppTheme.primaryColor,
                      loaderColor: MyAppTheme.primaryColor,
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
                    ],
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
