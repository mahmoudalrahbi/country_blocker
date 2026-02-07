import 'package:equatable/equatable.dart';

/// Enum representing the reason a call was blocked
enum BlockReason {
  spamDatabase,
  ruleMarketing,
  ruleUnknownCaller,
  countryBlocked,
  customRule,
}

/// Domain entity representing a blocked call log entry
/// This is a pure domain model without any framework dependencies
class BlockedCallLog extends Equatable {
  final String phoneNumber;
  final String countryName;
  final String countryCode; // ISO code for flag
  final BlockReason reason;
  final DateTime timestamp;
  final String? customReasonText;

  const BlockedCallLog({
    required this.phoneNumber,
    required this.countryName,
    required this.countryCode,
    required this.reason,
    required this.timestamp,
    this.customReasonText,
  });

  /// Get human-readable reason text
  String get reasonText {
    if (customReasonText != null) return customReasonText!;

    switch (reason) {
      case BlockReason.spamDatabase:
        return 'Spam Database';
      case BlockReason.ruleMarketing:
        return 'Rule: Marketing';
      case BlockReason.ruleUnknownCaller:
        return 'Rule: Unknown Caller';
      case BlockReason.countryBlocked:
        return 'Country Blocked';
      case BlockReason.customRule:
        return 'Custom Rule';
    }
  }

  /// Check if this is a rule-based block reason
  bool get isRuleReason {
    return reason == BlockReason.ruleMarketing ||
        reason == BlockReason.ruleUnknownCaller ||
        reason == BlockReason.customRule;
  }

  @override
  List<Object?> get props => [
        phoneNumber,
        countryName,
        countryCode,
        reason,
        timestamp,
        customReasonText,
      ];

  @override
  bool get stringify => true;
}
