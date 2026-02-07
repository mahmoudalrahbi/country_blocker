import 'package:equatable/equatable.dart';

/// Domain entity representing a blocked country
/// This is a pure domain model without any framework dependencies
class BlockedCountry extends Equatable {
  final String isoCode; // e.g. "US"
  final String phoneCode; // e.g. "1" or "971"
  final String name;
  final bool isEnabled;

  const BlockedCountry({
    required this.isoCode,
    required this.phoneCode,
    required this.name,
    this.isEnabled = true,
  });

  /// Create a copy of this entity with some fields replaced
  BlockedCountry copyWith({
    String? isoCode,
    String? phoneCode,
    String? name,
    bool? isEnabled,
  }) {
    return BlockedCountry(
      isoCode: isoCode ?? this.isoCode,
      phoneCode: phoneCode ?? this.phoneCode,
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [isoCode, phoneCode, name, isEnabled];

  @override
  bool get stringify => true;
}
