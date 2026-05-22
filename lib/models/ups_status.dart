import 'package:equatable/equatable.dart';

/// UPS状态数据模型
class UPSStatus extends Equatable {
  /// 输出电压 (V)
  final double voltage;

  /// 输出电流 (A)
  final double current;

  /// 输出功率 (W)
  final int power;

  /// 电池电量 (%)
  final int battery;

  /// 输入电压 (V)
  final double inputVoltage;

  /// 输出状态
  final String outputStatus;

  /// UPS模式
  final String upsMode;

  /// 负载百分比 (%)
  final int loadPercent;

  /// 温度 (℃)
  final double temperature;

  /// 剩余运行时间 (秒)
  final int runtimeRemaining;

  /// 时间戳
  final DateTime timestamp;

  const UPSStatus({
    required this.voltage,
    required this.current,
    required this.power,
    required this.battery,
    required this.inputVoltage,
    required this.outputStatus,
    required this.upsMode,
    required this.loadPercent,
    required this.temperature,
    required this.runtimeRemaining,
    required this.timestamp,
  });

  /// 从JSON创建UPSStatus
  factory UPSStatus.fromJson(Map<String, dynamic> json) {
    return UPSStatus(
      voltage: (json['voltage'] as num?)?.toDouble() ?? 0.0,
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
      power: (json['power'] as num?)?.toInt() ?? 0,
      battery: (json['battery'] as num?)?.toInt() ?? 0,
      inputVoltage: (json['input_voltage'] as num?)?.toDouble() ?? 0.0,
      outputStatus: json['output_status'] as String? ?? 'unknown',
      upsMode: json['ups_mode'] as String? ?? 'unknown',
      loadPercent: (json['load_percent'] as num?)?.toInt() ?? 0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      runtimeRemaining: (json['runtime_remaining'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch((json['timestamp'] as num).toInt() * 1000)
          : DateTime.now(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'voltage': voltage,
      'current': current,
      'power': power,
      'battery': battery,
      'input_voltage': inputVoltage,
      'output_status': outputStatus,
      'ups_mode': upsMode,
      'load_percent': loadPercent,
      'temperature': temperature,
      'runtime_remaining': runtimeRemaining,
      'timestamp': timestamp.millisecondsSinceEpoch ~/ 1000,
    };
  }

  /// 获取格式化的时间
  String get formattedRuntime {
    final hours = runtimeRemaining ~/ 3600;
    final minutes = (runtimeRemaining % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}小时${minutes}分钟';
    }
    return '${minutes}分钟';
  }

  /// 是否为电池供电
  bool get isOnBattery => upsMode.toLowerCase() == 'battery';

  /// 是否正常状态
  bool get isNormal => outputStatus.toLowerCase() == 'normal' && upsMode.toLowerCase() == 'online';

  /// 电池电量等级
  String get batteryLevel {
    if (battery >= 80) return 'high';
    if (battery >= 50) return 'medium';
    if (battery >= 20) return 'low';
    return 'critical';
  }

  /// 获取负载状态描述
  String get loadStatus {
    if (loadPercent < 30) return '轻载';
    if (loadPercent < 70) return '正常';
    if (loadPercent < 90) return '较重';
    return '过载';
  }

  /// 创建空状态
  factory UPSStatus.empty() {
    return UPSStatus(
      voltage: 0,
      current: 0,
      power: 0,
      battery: 0,
      inputVoltage: 0,
      outputStatus: 'unknown',
      upsMode: 'unknown',
      loadPercent: 0,
      temperature: 0,
      runtimeRemaining: 0,
      timestamp: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        voltage,
        current,
        power,
        battery,
        inputVoltage,
        outputStatus,
        upsMode,
        loadPercent,
        temperature,
        runtimeRemaining,
        timestamp,
      ];
}
