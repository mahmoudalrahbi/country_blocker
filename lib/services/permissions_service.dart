import 'package:flutter/services.dart';
import 'dart:io';

class PermissionsService {
  static const platform = MethodChannel('com.example.country_blocker/channel');

  static Future<void> requestRole() async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('requestRole');
      } on PlatformException catch (e) {
        // ignore: avoid_print
        print("Failed to request role: '${e.message}'.");
      }
    }
  }
}
