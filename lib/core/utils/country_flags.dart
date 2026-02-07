/// Utility class to convert ISO country codes to flag emojis
class CountryFlags {
  /// Converts an ISO country code to its corresponding flag emoji
  /// Returns null if the country code is not found
  static String? getFlagEmoji(String? isoCode) {
    if (isoCode == null || isoCode.isEmpty) {
      return null;
    }
    
    final code = isoCode.toUpperCase();
    
    // Convert ISO code to flag emoji using regional indicator symbols
    // Each letter is converted to its regional indicator symbol
    // A = 🇦 (U+1F1E6), B = 🇧 (U+1F1E7), etc.
    if (code.length == 2 && RegExp(r'^[A-Z]{2}$').hasMatch(code)) {
      final firstChar = code.codeUnitAt(0);
      final secondChar = code.codeUnitAt(1);
      
      // Regional Indicator Symbol Letter A starts at U+1F1E6 (127462)
      // 'A' is 65, so we add (char - 65) to 127462
      final firstRegional = 127462 + (firstChar - 65);
      final secondRegional = 127462 + (secondChar - 65);
      
      return String.fromCharCodes([firstRegional, secondRegional]);
    }
    
    return null;
  }
  
  /// Gets a flag emoji or returns a default icon indicator
  /// This is useful for UI display where we always want to show something
  static String getFlagOrDefault(String? isoCode, {String defaultSymbol = '🌐'}) {
    return getFlagEmoji(isoCode) ?? defaultSymbol;
  }
}
