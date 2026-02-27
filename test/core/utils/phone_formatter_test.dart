import 'package:flutter_test/flutter_test.dart';
import 'package:country_blocker/core/utils/phone_formatter.dart';

void main() {
  group('PhoneFormatter', () {
    test('formatWithPlusAndSpacing parses genuine formats globally', () {
      // Test Oman (Country code 968 + 4 + 4)
      expect(PhoneFormatter.formatWithPlusAndSpacing('96812345678'), '+968 1234 5678');
      
      // Test USA (+1 + 3 + 3 + 4)
      expect(PhoneFormatter.formatWithPlusAndSpacing('+15551234567'), '+1 555-123-4567');
      
      // Test UK
      expect(PhoneFormatter.formatWithPlusAndSpacing('447700900000'), '+44 7700 900000');
    });

    test('formatWithPlusAndSpacing fixes existing bad spacing', () {
      expect(PhoneFormatter.formatWithPlusAndSpacing('+1   555 123 4567'), '+1 555-123-4567');
      expect(PhoneFormatter.formatWithPlusAndSpacing('  968 1234 5678   '), '+968 1234 5678');
    });

    test('formatWithPlusAndSpacing handles short/invalid numbers safely as fallbacks', () {
      expect(PhoneFormatter.formatWithPlusAndSpacing('12'), '+12');
      expect(PhoneFormatter.formatWithPlusAndSpacing('+12'), '+12');
      // Number not globally recognized but validly appended +
      expect(PhoneFormatter.formatWithPlusAndSpacing('123'), '+1 23');
    });
    
    test('formatWithPlusAndSpacing handles empty strings appropriately', () {
      expect(PhoneFormatter.formatWithPlusAndSpacing(''), '');
    });
  });
}
