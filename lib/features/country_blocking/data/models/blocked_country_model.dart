import 'dart:convert';
import '../../domain/entities/blocked_country.dart';

/// Data Transfer Object for BlockedCountry
/// Extends the domain entity and adds JSON serialization capabilities
class BlockedCountryModel extends BlockedCountry {
  const BlockedCountryModel({
    required super.isoCode,
    required super.phoneCode,
    required super.name,
    super.isEnabled,
  });

  /// Create model from domain entity
  factory BlockedCountryModel.fromEntity(BlockedCountry entity) {
    return BlockedCountryModel(
      isoCode: entity.isoCode,
      phoneCode: entity.phoneCode,
      name: entity.name,
      isEnabled: entity.isEnabled,
    );
  }

  /// Create model from JSON map
  factory BlockedCountryModel.fromMap(Map<String, dynamic> map) {
    return BlockedCountryModel(
      isoCode: map['isoCode'] as String? ?? '',
      phoneCode: map['phoneCode'] as String? ?? '',
      name: map['name'] as String? ?? '',
      isEnabled: map['isEnabled'] as bool? ?? true,
    );
  }

  /// Create model from JSON string
  factory BlockedCountryModel.fromJson(String source) {
    return BlockedCountryModel.fromMap(
      json.decode(source) as Map<String, dynamic>,
    );
  }

  /// Convert model to JSON map
  Map<String, dynamic> toMap() {
    return {
      'isoCode': isoCode,
      'phoneCode': phoneCode,
      'name': name,
      'isEnabled': isEnabled,
    };
  }

  /// Convert model to JSON string
  String toJson() => json.encode(toMap());

  /// Create a copy with some fields replaced
  @override
  BlockedCountryModel copyWith({
    String? isoCode,
    String? phoneCode,
    String? name,
    bool? isEnabled,
  }) {
    return BlockedCountryModel(
      isoCode: isoCode ?? this.isoCode,
      phoneCode: phoneCode ?? this.phoneCode,
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
