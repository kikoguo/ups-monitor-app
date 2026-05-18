import 'package:equatable/equatable.dart';

/// UPS设备信息模型
class DeviceInfo extends Equatable {
  /// 设备ID
  final String id;

  /// 设备名称
  final String name;

  /// 设备IP地址
  final String ipAddress;

  /// 设备型号
  final String model;

  /// 固件版本
  final String firmware;

  /// ESP8266版本
  final String esp8266Version;

  /// 最后在线时间
  final DateTime lastSeen;

  /// 是否在线
  final bool isOnline;

  const DeviceInfo({
    required this.id,
    required this.name,
    required this.ipAddress,
    this.model = 'Unknown',
    this.firmware = 'Unknown',
    this.esp8266Version = 'Unknown',
    required this.lastSeen,
    this.isOnline = true,
  });

  /// 从JSON创建DeviceInfo
  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'UPS设备',
      ipAddress: json['ip_address'] as String? ?? json['ip'] as String? ?? '',
      model: json['model'] as String? ?? 'Unknown',
      firmware: json['firmware'] as String? ?? json['firmware_version'] as String? ?? 'Unknown',
      esp8266Version: json['esp8266_version'] as String? ?? 'Unknown',
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : DateTime.now(),
      isOnline: json['is_online'] as bool? ?? true,
    );
  }

  /// 从设备信息API响应创建
  factory DeviceInfo.fromApiResponse(Map<String, dynamic> data, String ip) {
    return DeviceInfo(
      id: ip.replaceAll('.', '_'),
      name: 'UPS-${ip}',
      ipAddress: ip,
      model: data['model'] as String? ?? 'Unknown',
      firmware: data['firmware'] as String? ?? 'Unknown',
      esp8266Version: data['esp8266_version'] as String? ?? 'Unknown',
      lastSeen: DateTime.now(),
      isOnline: true,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ip_address': ipAddress,
      'model': model,
      'firmware': firmware,
      'esp8266_version': esp8266Version,
      'last_seen': lastSeen.toIso8601String(),
      'is_online': isOnline,
    };
  }

  /// 复制并更新
  DeviceInfo copyWith({
    String? id,
    String? name,
    String? ipAddress,
    String? model,
    String? firmware,
    String? esp8266Version,
    DateTime? lastSeen,
    bool? isOnline,
  }) {
    return DeviceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      model: model ?? this.model,
      firmware: firmware ?? this.firmware,
      esp8266Version: esp8266Version ?? this.esp8266Version,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  /// 获取完整的API地址
  String get baseUrl => 'http://$ipAddress';

  @override
  List<Object?> get props => [id, name, ipAddress, model, firmware, esp8266Version, lastSeen, isOnline];
}
