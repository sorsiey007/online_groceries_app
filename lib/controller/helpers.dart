// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:online_groceries_app/themes/app_theme.dart';

// bool validateEmail(String email) {
//   final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');
//   return emailRegex.hasMatch(email);
// }

// bool validatePassword(String password) {
//   return password.length >= 6;
// }

// Future<http.Response> signInRequest(String email, String password) {
//   final Uri url = Uri.parse('https://online-shop-hxhm.onrender.com/api/login');
//   final Map<String, String> data = {'email': email, 'password': password};

//   return http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode(data),
//   );
// }

// Widget buildTextField(
//   TextEditingController controller,
//   String label,
//   String hint,
//   bool obscureText,
//   Function(String)? onChanged,
//   String? validationMessage,
// ) {
//   return AnimatedContainer(
//     duration: const Duration(milliseconds: 300),
//     curve: Curves.easeInOut,
//     padding: const EdgeInsets.only(bottom: 5),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: controller,
//           obscureText: obscureText,
//           style: const TextStyle(fontSize: 18, color: MyAppTheme.backgroundColor),
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             labelText: label,
//             hintText: hint,
//             labelStyle: const TextStyle(fontSize: 16),
//             hintStyle: const TextStyle(fontSize: 16),
//             enabledBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: MyAppTheme.borderColor12),
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: MyAppTheme.primaryColor),
//             ),
//           ),
//         ),
//         if (validationMessage != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 5),
//             child: Text(validationMessage, style: const TextStyle(color: Colors.red, fontSize: 12)),
//           ),
//       ],
//     ),
//   );
// }

// Widget buildSocialButton(String assetName, VoidCallback onPressed) {
//   return SizedBox(
//     width: 50,
//     height: 50,
//     child: TextButton(
//       onPressed: onPressed,
//       style: TextButton.styleFrom(
//         backgroundColor: MyAppTheme.primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//           side: const BorderSide(color: Colors.grey, width: 1),
//         ),
//       ),
//       child: SvgPicture.asset(assetName, width: 45, height: 45),
//     ),
//   );
// }

// void showToast(String msg) {
//   Fluttertoast.showToast(
//     msg: msg,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     backgroundColor: Colors.red,
//     textColor: Colors.white,
//   );
// }

// Widget buildBackground() {
//   return Stack(
//     children: [
//       Positioned.fill(
//         child: Align(
//           alignment: Alignment.topRight,
//           child: Image.asset('assets/images/png/groceries.png', width: 600, height: 600, fit: BoxFit.contain),
//         ),
//       ),
//       Positioned.fill(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//           child: Container(color: MyAppTheme.primaryColor.withOpacity(0.85)),
//         ),
//       ),
//     ],
//   );
// }
