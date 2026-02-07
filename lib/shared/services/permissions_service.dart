import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionsService {
  final platform = const MethodChannel('com.example.country_blocker/channel');

  Future<void> requestRole() async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('requestRole');
      } on PlatformException catch (e) {
        // ignore: avoid_print
        print("Failed to request role: '${e.message}'.");
      }
    }
  }

  Future<bool> requestPhonePermissions() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.phone,
        Permission.contacts,
      ].request();

      return statuses[Permission.phone]?.isGranted ?? false;
    }
    return true; // iOS handles checking differently via Call Directory Extension usually
  }

  Future<bool> hasPhonePermissions() async {
    if (Platform.isAndroid) {
      return await Permission.phone.isGranted;
    }
    return true;
  }

  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
