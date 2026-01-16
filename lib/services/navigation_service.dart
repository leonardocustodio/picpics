import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  static Future<T?> to<T>(Widget page) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> off<T>(Widget page) {
    return navigatorKey.currentState!.pushReplacement<T, void>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> offAll<T>(Widget page) {
    return navigatorKey.currentState!.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static void back<T>([T? result]) {
    navigatorKey.currentState!.pop(result);
  }

  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  static Future<T?> dialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => dialog,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }
}