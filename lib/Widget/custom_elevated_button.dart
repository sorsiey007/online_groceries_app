import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed; // Allow null to disable the button
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final Color loaderColor;

  const CustomElevatedButton({
    Key? key,
    required this.isLoading,
    this.onPressed,
    required this.buttonText,
    required this.backgroundColor,
    required this.textColor,
    required this.loaderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? backgroundColor.withOpacity(0.5) // Dim color when disabled
              : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
              )
            : Text(
                buttonText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: textColor,
                    ),
              ),
      ),
    );
  }
}
