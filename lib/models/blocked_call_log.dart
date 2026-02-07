import 'dart:convert';

enum BlockReason {
  spamDatabase,
  ruleMarketing,
  ruleUnknownCaller,
  countryBlocked,
  customRule,
}

class BlockedCallLog {
  final String phoneNumber;
  final String countryName;
  final String countryCode; // ISO code for flag
  final BlockReason reason;
  final DateTime timestamp;
  final String? customReasonText;

  BlockedCallLog({
    required this.phoneNumber,
    required this.countryName,
    required this.countryCode,
    required this.reason,
    required this.timestamp,
    this.customReasonText,
  });

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

  bool get isRuleReason {
    return reason == BlockReason.ruleMarketing ||
           reason == BlockReason.ruleUnknownCaller ||
           reason == BlockReason.customRule;
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'countryName': countryName,
      'countryCode': countryCode,
      'reason': reason.index,
      'timestamp': timestamp.toIso8601String(),
      'customReasonText': customReasonText,
    };
  }

  factory BlockedCallLog.fromMap(Map<String, dynamic> map) {
    return BlockedCallLog(
      phoneNumber: map['phoneNumber'] ?? '',
      countryName: map['countryName'] ?? '',
      countryCode: map['countryCode'] ?? '',
      reason: BlockReason.values[map['reason'] ?? 0],
      timestamp: DateTime.parse(map['timestamp']),
      customReasonText: map['customReasonText'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedCallLog.fromJson(String source) =>
      BlockedCallLog.fromMap(json.decode(source));
}
