import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/blocked_country.dart';

class BlockedProvider with ChangeNotifier {
  List<BlockedCountry> _blockedList = [];
  bool _isLoading = true;
  int _blockedCallsCount = 0;
  bool _isBlockingActive = true;

  List<BlockedCountry> get blockedList => _blockedList;
  bool get isLoading => _isLoading;
  int get blockedCallsCount => _blockedCallsCount;
  bool get isBlockingActive => _isBlockingActive;

  BlockedProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedList = prefs.getStringList('blocked_countries');
    
    if (storedList != null) {
      _blockedList = storedList
          .map((item) => BlockedCountry.fromJson(item))
          .toList();
    }
    
    // Load blocked calls count
    _blockedCallsCount = prefs.getInt('blocked_calls_count') ?? 0;
    
    // Load global blocking state
    _isBlockingActive = prefs.getBool('blocking_enabled') ?? true;
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCountry(BlockedCountry country) async {
    // Avoid duplicates
    if (_blockedList.any((c) => c.phoneCode == country.phoneCode)) {
      return; 
    }
    
    // Default to enabled is handled by model constructor
    _blockedList.add(country);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> removeCountry(String phoneCode) async {
    _blockedList.removeWhere((c) => c.phoneCode == phoneCode);
    await _saveToPrefs();
    notifyListeners();
  }
  
  Future<void> toggleCountry(String phoneCode, bool isEnabled) async {
    final index = _blockedList.indexWhere((c) => c.phoneCode == phoneCode);
    if (index != -1) {
      final old = _blockedList[index];
      _blockedList[index] = BlockedCountry(
        isoCode: old.isoCode,
        phoneCode: old.phoneCode,
        name: old.name,
        isEnabled: isEnabled,
      );
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> toggleGlobalBlocking() async {
    _isBlockingActive = !_isBlockingActive;
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dataList =
        _blockedList.map((c) => c.toJson()).toList();
    await prefs.setStringList('blocked_countries', dataList);
    
    // Persist global blocking state for UI
    await prefs.setBool('blocking_enabled', _isBlockingActive);
    
    // Save as a single JSON string for easier Native access
    // Native key will be "flutter.blocked_countries_simple"
    // Also store the global blocking state for native access
    final String jsonString = json.encode(_blockedList.map((c) => c.toMap()).toList());
    await prefs.setString('blocked_countries_simple', jsonString);
    await prefs.setBool('blocking_enabled', _isBlockingActive); // Same key used by native if using FlutterSharedPreferences
  }

  /// Increment the blocked calls counter
  Future<void> incrementBlockedCalls() async {
    _blockedCallsCount++;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('blocked_calls_count', _blockedCallsCount);
  }
}
