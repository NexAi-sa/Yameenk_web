/// معلومات الجهاز المتصل وحالة الاتصال ونتيجة المزامنة
library;

import 'wearable_reading.dart';

enum DeviceConnectionStatus {
  disconnected,
  scanning,
  connecting,
  connected,
  syncing,
  error,
}

enum DeviceType {
  smartwatch, // ساعة ذكية
  glucoseMonitor, // جهاز سكر (CGM أو BGM)
  bloodPressureCuff, // جهاز ضغط
  pulseOximeter, // جهاز أكسجين
  weightScale, // ميزان
}

class DeviceInfo {
  final String id; // UUID محلي نولّده عند أول إضافة
  final String name; // "Omron M7 Intelli"
  final String? macAddress; // للـ BLE
  final DeviceType type;
  final ReadingSource source; // من أين تأتي بياناته
  final bool isActive;
  final DateTime? lastSyncAt;
  final String? firmwareVersion;

  const DeviceInfo({
    required this.id,
    required this.name,
    this.macAddress,
    required this.type,
    required this.source,
    this.isActive = true,
    this.lastSyncAt,
    this.firmwareVersion,
  });

  DeviceInfo copyWith({
    bool? isActive,
    DateTime? lastSyncAt,
    String? firmwareVersion,
  }) => DeviceInfo(
    id: id,
    name: name,
    macAddress: macAddress,
    type: type,
    source: source,
    isActive: isActive ?? this.isActive,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    firmwareVersion: firmwareVersion ?? this.firmwareVersion,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'mac_address': macAddress,
    'type': type.name,
    'source': source.name,
    'is_active': isActive,
    'last_sync_at': lastSyncAt?.toIso8601String(),
  };

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    macAddress: json['mac_address'] as String?,
    type: DeviceType.values.byName(json['type'] as String),
    source: ReadingSource.values.byName(json['source'] as String),
    isActive: json['is_active'] as bool? ?? true,
    lastSyncAt: json['last_sync_at'] != null
        ? DateTime.parse(json['last_sync_at'] as String)
        : null,
  );
}

/// نتيجة عملية المزامنة
class SyncResult {
  final bool success;
  final int readingsCount;
  final DateTime syncedAt;
  final String? error;
  final String deviceId;

  const SyncResult({
    required this.success,
    required this.readingsCount,
    required this.syncedAt,
    required this.deviceId,
    this.error,
  });
}
