import 'package:equatable/equatable.dart';
import 'device_type.dart';

/// 智能设备模型（支持多种设备类型）
class SmartDevice extends Equatable {
  /// 设备ID
  final String id;

  /// 设备名称
  final String name;

  /// 设备类型
  final DeviceType type;

  /// 设备序列号
  final String serialNumber;

  /// 设备IP地址（局域网）
  final String? localIp;

  /// 远程服务器地址
  final String? remoteServer;

  /// 设备型号
  final String model;

  /// 额定功率
  final String ratedPower;

  /// 电池容量
  final String batteryCapacity;

  /// 固件版本
  final String firmwareVersion;

  /// 是否在线
  final bool isOnline;

  /// 当前运行模式
  final DeviceMode mode;

  /// 最后通信时间
  final DateTime lastSeen;

  /// 设备参数数据（动态，根据设备类型不同）
  final Map<String, dynamic> parameters;

  /// 告警列表
  final List<DeviceAlarm> alarms;

  const SmartDevice({
    required this.id,
    required this.name,
    required this.type,
    this.serialNumber = '',
    this.localIp,
    this.remoteServer,
    this.model = '',
    this.ratedPower = '',
    this.batteryCapacity = '',
    this.firmwareVersion = '',
    this.isOnline = false,
    this.mode = DeviceMode.offline,
    required this.lastSeen,
    this.parameters = const {},
    this.alarms = const [],
  });

  factory SmartDevice.fromJson(Map<String, dynamic> json) {
    return SmartDevice(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '未命名设备',
      type: DeviceType.fromCode(json['type'] as String? ?? 'general'),
      serialNumber: json['serial_number'] as String? ?? '',
      localIp: json['local_ip'] as String?,
      remoteServer: json['remote_server'] as String?,
      model: json['model'] as String? ?? '',
      ratedPower: json['rated_power'] as String? ?? '',
      batteryCapacity: json['battery_capacity'] as String? ?? '',
      firmwareVersion: json['firmware_version'] as String? ?? '',
      isOnline: json['is_online'] as bool? ?? false,
      mode: DeviceMode.fromCode(json['mode'] as String? ?? 'offline'),
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : DateTime.now(),
      parameters: (json['parameters'] as Map<String, dynamic>?) ?? {},
      alarms: (json['alarms'] as List<dynamic>?)
              ?.map((a) => DeviceAlarm.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.code,
      'serial_number': serialNumber,
      'local_ip': localIp,
      'remote_server': remoteServer,
      'model': model,
      'rated_power': ratedPower,
      'battery_capacity': batteryCapacity,
      'firmware_version': firmwareVersion,
      'is_online': isOnline,
      'mode': mode.code,
      'last_seen': lastSeen.toIso8601String(),
      'parameters': parameters,
      'alarms': alarms.map((a) => a.toJson()).toList(),
    };
  }

  SmartDevice copyWith({
    String? id,
    String? name,
    DeviceType? type,
    String? serialNumber,
    String? localIp,
    String? remoteServer,
    String? model,
    String? ratedPower,
    String? batteryCapacity,
    String? firmwareVersion,
    bool? isOnline,
    DeviceMode? mode,
    DateTime? lastSeen,
    Map<String, dynamic>? parameters,
    List<DeviceAlarm>? alarms,
  }) {
    return SmartDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      serialNumber: serialNumber ?? this.serialNumber,
      localIp: localIp ?? this.localIp,
      remoteServer: remoteServer ?? this.remoteServer,
      model: model ?? this.model,
      ratedPower: ratedPower ?? this.ratedPower,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      isOnline: isOnline ?? this.isOnline,
      mode: mode ?? this.mode,
      lastSeen: lastSeen ?? this.lastSeen,
      parameters: parameters ?? this.parameters,
      alarms: alarms ?? this.alarms,
    );
  }

  /// 获取主要参数值（用于卡片显示）
  String get mainValue {
    switch (type) {
      case DeviceType.ups:
        return '${parameters['battery'] ?? '--'}%';
      case DeviceType.energyStorage:
        return '${parameters['soc'] ?? '--'}%';
      case DeviceType.bms:
        return '${parameters['voltage'] ?? '--'}V';
      case DeviceType.general:
        return '${parameters['power'] ?? '--'}kW';
      case DeviceType.smartSwitch:
        return parameters['switch_state'] == true ? 'ON' : 'OFF';
      case DeviceType.smartSocket:
        return '${parameters['power'] ?? '--'}W';
      case DeviceType.solar:
        return '${parameters['generation'] ?? '--'}kWh';
      default:
        return '--';
    }
  }

  /// 获取设备状态描述
  String get statusText {
    if (!isOnline) return '离线';
    return mode.displayName;
  }

  @override
  List<Object?> get props => [
        id, name, type, serialNumber, localIp, remoteServer,
        model, ratedPower, batteryCapacity, firmwareVersion,
        isOnline, mode, lastSeen, parameters, alarms,
      ];
}

/// 设备告警
class DeviceAlarm extends Equatable {
  final String id;
  final String message;
  final AlarmLevel level;
  final DateTime timestamp;
  final bool isResolved;

  const DeviceAlarm({
    required this.id,
    required this.message,
    required this.level,
    required this.timestamp,
    this.isResolved = false,
  });

  factory DeviceAlarm.fromJson(Map<String, dynamic> json) {
    return DeviceAlarm(
      id: json['id'] as String? ?? '',
      message: json['message'] as String? ?? '',
      level: AlarmLevel.fromCode(json['level'] as String? ?? 'info'),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isResolved: json['is_resolved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'level': level.code,
      'timestamp': timestamp.toIso8601String(),
      'is_resolved': isResolved,
    };
  }

  @override
  List<Object?> get props => [id, message, level, timestamp, isResolved];
}
