import 'package:flutter/material.dart';
import 'package:online_groceries_app/themes/app_theme.dart';

class BottomMessageWidget extends StatelessWidget {
  final String message;

  const BottomMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Adjust position above keyboard
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: MyAppTheme.errorColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: MyAppTheme.primaryColor,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: MyAppTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showBottomMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => BottomMessageWidget(message: message),
  );

  overlay.insert(entry);

  Future.delayed(Duration(seconds: 3), () {
    entry.remove();
  });
}
