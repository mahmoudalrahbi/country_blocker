import 'package:flutter_test/flutter_test.dart';
import 'package:country_blocker/core/utils/country_flags.dart';

void main() {
  group('CountryFlags', () {
    test('converts valid ISO codes to flag emojis', () {
      // Test common countries
      expect(CountryFlags.getFlagEmoji('US'), '🇺🇸');
      expect(CountryFlags.getFlagEmoji('GB'), '🇬🇧');
      expect(CountryFlags.getFlagEmoji('IN'), '🇮🇳');
      expect(CountryFlags.getFlagEmoji('AE'), '🇦🇪');
      expect(CountryFlags.getFlagEmoji('FR'), '🇫🇷');
      expect(CountryFlags.getFlagEmoji('JP'), '🇯🇵');
      expect(CountryFlags.getFlagEmoji('BR'), '🇧🇷');
      expect(CountryFlags.getFlagEmoji('CA'), '🇨🇦');
      expect(CountryFlags.getFlagEmoji('DE'), '🇩🇪');
      expect(CountryFlags.getFlagEmoji('AU'), '🇦🇺');
    });

    test('handles case insensitive ISO codes', () {
      expect(CountryFlags.getFlagEmoji('us'), '🇺🇸');
      expect(CountryFlags.getFlagEmoji('Us'), '🇺🇸');
      expect(CountryFlags.getFlagEmoji('uS'), '🇺🇸');
    });

    test('returns null for invalid ISO codes', () {
      expect(CountryFlags.getFlagEmoji(''), isNull);
      expect(CountryFlags.getFlagEmoji('X'), isNull);
      expect(CountryFlags.getFlagEmoji('ABC'), isNull);
      expect(CountryFlags.getFlagEmoji('12'), isNull);
      expect(CountryFlags.getFlagEmoji(null), isNull);
    });

    test('returns null for UNKNOWN iso code', () {
      expect(CountryFlags.getFlagEmoji('UNKNOWN'), isNull);
    });

    test('getFlagOrDefault returns default symbol for unknown codes', () {
      expect(CountryFlags.getFlagOrDefault(''), '🌐');
      expect(CountryFlags.getFlagOrDefault('UNKNOWN'), '🌐');
      expect(CountryFlags.getFlagOrDefault(null), '🌐');
    });

    test('getFlagOrDefault returns flag for valid codes', () {
      expect(CountryFlags.getFlagOrDefault('US'), '🇺🇸');
      expect(CountryFlags.getFlagOrDefault('GB'), '🇬🇧');
    });

    test('getFlagOrDefault accepts custom default symbol', () {
      expect(CountryFlags.getFlagOrDefault('', defaultSymbol: '❓'), '❓');
      expect(CountryFlags.getFlagOrDefault('UNKNOWN', defaultSymbol: '🏳️'), '🏳️');
    });
  });
}
