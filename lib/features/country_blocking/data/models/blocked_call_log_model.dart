import 'dart:convert';
import '../../domain/entities/blocked_call_log.dart';

/// Data Transfer Object for BlockedCallLog
/// Extends the domain entity and adds JSON serialization capabilities
class BlockedCallLogModel extends BlockedCallLog {
  const BlockedCallLogModel({
    required super.phoneNumber,
    required super.countryName,
    required super.countryCode,
    required super.reason,
    required super.timestamp,
    super.customReasonText,
  });

  /// Create model from domain entity
  factory BlockedCallLogModel.fromEntity(BlockedCallLog entity) {
    return BlockedCallLogModel(
      phoneNumber: entity.phoneNumber,
      countryName: entity.countryName,
      countryCode: entity.countryCode,
      reason: entity.reason,
      timestamp: entity.timestamp,
      customReasonText: entity.customReasonText,
    );
  }

  /// Create model from JSON map
  factory BlockedCallLogModel.fromMap(Map<String, dynamic> map) {
    return BlockedCallLogModel(
      phoneNumber: map['phoneNumber'] as String? ?? '',
      countryName: map['countryName'] as String? ?? '',
      countryCode: map['countryCode'] as String? ?? '',
      reason: BlockReason.values[map['reason'] as int? ?? 0],
      timestamp: DateTime.parse(map['timestamp'] as String),
      customReasonText: map['customReasonText'] as String?,
    );
  }

  /// Create model from JSON string
  factory BlockedCallLogModel.fromJson(String source) {
    return BlockedCallLogModel.fromMap(
      json.decode(source) as Map<String, dynamic>,
    );
  }

  /// Convert model to JSON map
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

  /// Convert model to JSON string
  String toJson() => json.encode(toMap());
}
