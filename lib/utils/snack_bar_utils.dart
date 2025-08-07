import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../domain/enums/snack_bar_type.dart';
import '../config/app_config.dart';

/// Utility class for displaying snack bars
class SnackBarUtils {
  /// Show a snack bar with the specified message and type
  static void showSnackBar(
    BuildContext context,
    String message,
    SnackBarType type,
  ) {
    late Color backgroundColor;
    late IconData icon;

    switch (type) {
      case SnackBarType.error:
        backgroundColor = AppColors.red;
        icon = Icons.error_outline;
        break;
      case SnackBarType.success:
        backgroundColor = AppColors.green;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.info:
        backgroundColor = AppColors.primaryBlue;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(seconds: AppConfig.snackBarDuration),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show a success snack bar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, SnackBarType.success);
  }

  /// Show an error snack bar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, SnackBarType.error);
  }

  /// Show an info snack bar
  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, SnackBarType.info);
  }
}
