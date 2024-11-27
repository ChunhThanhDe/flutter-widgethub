import 'package:flutter/foundation.dart';

class LogHelper {
  static void d(String tag, String message) {
    if (kDebugMode) {
      print("WIDGETHUB DEBUG: [$tag] $message");
    }
  }

  static void e(String tag, String message) {
    if (kDebugMode) {
      print("WIDGETHUB ERROR: [$tag] $message");
    }
  }
}
