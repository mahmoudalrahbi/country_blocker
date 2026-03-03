import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionsService {
  final platform = const MethodChannel('com.mahmoudalrahbi.countryblocker/channel');

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

  Future<bool> hasRole() async {
    if (Platform.isAndroid) {
      try {
        final bool isHeld = await platform.invokeMethod('checkRole');
        return isHeld;
      } on PlatformException catch (e) {
        // ignore: avoid_print
        print("Failed to check role: '${e.message}'.");
        return false;
      }
    }
    return true;
  }

  Future<bool> requestPhonePermissions() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.phone,
        Permission.contacts,
      ].request();

      // Also request role if not held? No, role request is separate UI flow usually.
      // But we should return false if role is not held?
      // The current flow in PermissionGuardScreen calls requestPhonePermissions then checks again.
      // We should probably rely on hasPhonePermissions to be the ultimate checker.
      
      return statuses[Permission.phone]?.isGranted ?? false;
    }
    return true; // iOS handles checking differently via Call Directory Extension usually
  }

  Future<bool> hasPhonePermissions() async {
    if (Platform.isAndroid) {
      final hasPerm = await Permission.phone.isGranted;
      final hasRoleHeld = await hasRole();
      return hasPerm && hasRoleHeld;
    }
    return true;
  }

  Future<bool> requestIgnoreBatteryOptimizations() async {
    if (Platform.isAndroid) {
      var status = await Permission.ignoreBatteryOptimizations.status;
      if (!status.isGranted) {
        status = await Permission.ignoreBatteryOptimizations.request();
      }
      return status.isGranted;
    }
    return true;
  }

  Future<bool> isIgnoringBatteryOptimizations() async {
      if (Platform.isAndroid) {
      return await Permission.ignoreBatteryOptimizations.isGranted;
    }
    return true;
  }

  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
