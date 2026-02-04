import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/blocked_country.dart';

class BlockedProvider with ChangeNotifier {
  List<BlockedCountry> _blockedList = [];
  bool _isLoading = true;

  List<BlockedCountry> get blockedList => _blockedList;
  bool get isLoading => _isLoading;

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
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCountry(BlockedCountry country) async {
    // Avoid duplicates
    if (_blockedList.any((c) => c.phoneCode == country.phoneCode)) {
      return; 
    }
    
    _blockedList.add(country);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> removeCountry(String phoneCode) async {
    _blockedList.removeWhere((c) => c.phoneCode == phoneCode);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dataList =
        _blockedList.map((c) => c.toJson()).toList();
    await prefs.setStringList('blocked_countries', dataList);
    
    // Save as a single JSON string for easier Native access
    // Native key will be "flutter.blocked_countries_simple"
    final String jsonString = json.encode(_blockedList.map((c) => c.toMap()).toList());
    await prefs.setString('blocked_countries_simple', jsonString);
  }
}
