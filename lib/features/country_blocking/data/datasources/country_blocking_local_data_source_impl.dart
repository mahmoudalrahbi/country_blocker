import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/blocked_country_model.dart';
import 'country_blocking_local_data_source.dart';

/// Implementation of CountryBlockingLocalDataSource using SharedPreferences
class CountryBlockingLocalDataSourceImpl
    implements CountryBlockingLocalDataSource {
  final SharedPreferences sharedPreferences;

  // SharedPreferences keys
  static const String kBlockedCountriesKey = 'blocked_countries';
  static const String kBlockedCountriesSimpleKey = 'blocked_countries_simple';
  static const String kBlockingEnabledKey = 'blocking_enabled';
  static const String kBlockedCallsCountKey = 'blocked_calls_count';

  CountryBlockingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<BlockedCountryModel>> getCachedBlockedCountries() async {
    try {
      final List<String>? storedList =
          sharedPreferences.getStringList(kBlockedCountriesKey);

      if (storedList == null || storedList.isEmpty) {
        return [];
      }

      return storedList
          .map((item) => BlockedCountryModel.fromJson(item))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached blocked countries: $e');
    }
  }

  @override
  Future<void> cacheBlockedCountries(
    List<BlockedCountryModel> countries,
  ) async {
    try {
      // Save as list of JSON strings for Flutter access
      final List<String> dataList = countries.map((c) => c.toJson()).toList();
      await sharedPreferences.setStringList(kBlockedCountriesKey, dataList);

      // Also save as single JSON string for native platform access
      final String jsonString =
          json.encode(countries.map((c) => c.toMap()).toList());
      await sharedPreferences.setString(kBlockedCountriesSimpleKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache blocked countries: $e');
    }
  }

  @override
  Future<bool> getGlobalBlockingStatus() async {
    try {
      return sharedPreferences.getBool(kBlockingEnabledKey) ?? true;
    } catch (e) {
      throw CacheException('Failed to get global blocking status: $e');
    }
  }

  @override
  Future<void> cacheGlobalBlockingStatus(bool status) async {
    try {
      await sharedPreferences.setBool(kBlockingEnabledKey, status);
    } catch (e) {
      throw CacheException('Failed to cache global blocking status: $e');
    }
  }

  @override
  Future<int> getBlockedCallsCount() async {
    try {
      return sharedPreferences.getInt(kBlockedCallsCountKey) ?? 0;
    } catch (e) {
      throw CacheException('Failed to get blocked calls count: $e');
    }
  }

  @override
  Future<void> cacheBlockedCallsCount(int count) async {
    try {
      await sharedPreferences.setInt(kBlockedCallsCountKey, count);
    } catch (e) {
      throw CacheException('Failed to cache blocked calls count: $e');
    }
  }
}
