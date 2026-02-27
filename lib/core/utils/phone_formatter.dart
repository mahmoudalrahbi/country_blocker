import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneFormatter {
  /// Formats a raw phone number string by:
  /// 1. Ensuring it has exactly one leading '+' (assuming international format).
  /// 2. Parsing it globally using accurate country-specific rules.
  static String formatWithPlusAndSpacing(String phoneNumber) {
    if (phoneNumber.isEmpty) return phoneNumber;

    // 1. Clean the string first (trim, remove any existing spaces to avoid double spacing).
    var cleanedNumber = phoneNumber.trim().replaceAll(' ', '');
    
    // 2. Add prefix if missing.
    if (!cleanedNumber.startsWith('+')) {
      cleanedNumber = '+$cleanedNumber';
    }

    if (cleanedNumber.length < 4) {
      return cleanedNumber;
    }

    try {
      // 3. Parse and format using the robust global parser
      final phone = PhoneNumber.parse(cleanedNumber);
      
      // If it parsed successfully, return the true international format (with accurate spacing)
      final nsnFormatted = phone.formatNsn(format: NsnFormat.international);
      return '+${phone.countryCode} $nsnFormatted';
    } catch (e) {
      // If parsing fails for any reason (e.g. invalid format), returning the valid string is safest
      return cleanedNumber;
    }
  }
}
