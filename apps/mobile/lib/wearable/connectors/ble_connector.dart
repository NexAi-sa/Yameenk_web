/// Connector للبلوتوث المباشر — أجهزة Omron، A&D، Contec
/// يستخدم flutter_blue_plus
///
/// pubspec.yaml:
///   flutter_blue_plus: ^1.32.12
library;

import '../abstractions/wearable_connector.dart';
import '../models/device_info.dart';
import '../models/wearable_reading.dart';

// import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // ← أضف عند الاستخدام

class BleWearableConnector implements WearableConnector {
  final DeviceInfo deviceInfo;

  BleWearableConnector({required this.deviceInfo});

  @override
  String get connectorName => 'BLE Direct — ${deviceInfo.name}';

  @override
  Future<bool> isAvailable() async {
    // return await FlutterBluePlus.isAvailable;
    return false; // ← غيّر عند إضافة flutter_blue_plus
  }

  @override
  Future<bool> requestPermissions(List<WearableReadingType> types) async {
    // يحتاج: permission_handler package
    // await Permission.bluetooth.request();
    // await Permission.bluetoothScan.request();
    // await Permission.bluetoothConnect.request();
    // await Permission.location.request(); // مطلوب لـ BLE scan على Android
    throw UnimplementedError(
      'أضف flutter_blue_plus و permission_handler للـ pubspec.yaml',
    );
  }

  @override
  Future<bool> hasPermissions(List<WearableReadingType> types) async {
    // return await Permission.bluetooth.isGranted;
    return false;
  }

  @override
  Future<List<WearableReading>> fetchReadings({
    required String patientId,
    required List<WearableReadingType> types,
    required DateTime from,
    DateTime? to,
  }) async {
    // البيانات تأتي عبر liveStream للـ BLE
    // هذا يُستخدم لجلب القراءات المحفوظة من الذاكرة الداخلية للجهاز
    return [];
  }

  @override
  Future<SyncResult> sync({
    required String patientId,
    required List<WearableReadingType> types,
  }) async {
    // TODO: connect → discover services → read characteristics → disconnect
    return SyncResult(
      success: false,
      readingsCount: 0,
      syncedAt: DateTime.now(),
      deviceId: deviceInfo.id,
      error: 'BLE connector not yet implemented',
    );
  }

  @override
  Stream<WearableReading>? get liveStream {
    // TODO:
    // return FlutterBluePlus.scanResults
    //   .where((r) => r.any((d) => d.device.remoteId.str == deviceInfo.macAddress))
    //   .asyncExpand((results) => _parseGattData(results));
    return null;
  }

  @override
  Future<void> disconnect() async {
    // TODO: await _connectedDevice?.disconnect();
  }
}
