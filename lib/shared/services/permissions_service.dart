import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../core/telemetry/analytics_service.dart';

class PermissionsService {
  final _channel = const MethodChannel('com.mahmoudalrahbi.countryblocker/channel');
  final AnalyticsService _analytics;

  PermissionsService({AnalyticsService? analytics})
      : _analytics = analytics ?? NoOpAnalyticsService();

  // ---- Overridable platform seams (for testing) ----

  @visibleForTesting
  Future<bool> platformCheckRole() async {
    if (Platform.isAndroid) {
      try {
        return await _channel.invokeMethod('checkRole') as bool;
      } on PlatformException {
        return false;
      }
    }
    return true;
  }

  @visibleForTesting
  Future<bool> platformRequestPhonePermissions() async {
    if (Platform.isAndroid) {
      final statuses = await [Permission.phone, Permission.contacts].request();
      return statuses[Permission.phone]?.isGranted ?? false;
    }
    return true;
  }

  // ---- Public API ----

  Future<void> requestRole() async {
    await _analytics.logEvent('permission_role_requested');
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('requestRole');
      } on PlatformException catch (e) {
        // ignore: avoid_print
        print("Failed to request role: '${e.message}'.");
      }
    }
  }

  Future<bool> hasRole() async {
    final result = await platformCheckRole();
    await _analytics.logEvent(
      result ? 'permission_role_granted' : 'permission_role_denied',
    );
    return result;
  }

  Future<bool> requestPhonePermissions() async {
    final result = await platformRequestPhonePermissions();
    await _analytics.logEvent(
      result ? 'permission_phone_granted' : 'permission_phone_denied',
    );
    return result;
  }

  Future<bool> hasPhonePermissions() async {
    if (Platform.isAndroid) {
      final hasPerm = await Permission.phone.isGranted;
      final hasRoleHeld = await platformCheckRole();
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
