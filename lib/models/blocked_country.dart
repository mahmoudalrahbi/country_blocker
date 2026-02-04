import 'dart:convert';

class BlockedCountry {
  final String isoCode; // e.g. "US"
  final String phoneCode; // e.g. "1" or "971"
  final String name;

  BlockedCountry({
    required this.isoCode,
    required this.phoneCode,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'isoCode': isoCode,
      'phoneCode': phoneCode,
      'name': name,
    };
  }

  factory BlockedCountry.fromMap(Map<String, dynamic> map) {
    return BlockedCountry(
      isoCode: map['isoCode'] ?? '',
      phoneCode: map['phoneCode'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedCountry.fromJson(String source) =>
      BlockedCountry.fromMap(json.decode(source));
}
