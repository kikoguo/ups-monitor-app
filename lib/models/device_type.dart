import 'package:flutter/material.dart';

/// 设备类型枚举
enum DeviceType {
  ups('ups', 'UPS设备', Icons.battery_charging_full, Color(0xFF4A90D9)),
  energyStorage('energy_storage', '储能设备', Icons.energy_savings_leaf, Color(0xFF52C41A)),
  bms('bms', 'BMS设备', Icons.memory, Color(0xFFFA8C16)),
  general('general', '通用设备', Icons.devices_other, Color(0xFF722ED1)),
  smartSwitch('smart_switch', '智能开关', Icons.toggle_on, Color(0xFF13C2C2)),
  smartSocket('smart_socket', '智能插座', Icons.electrical_services, Color(0xFFEB2F96)),
  solar('solar', '光伏设备', Icons.wb_sunny, Color(0xFFFADB14));

  final String code;
  final String displayName;
  final IconData icon;
  final Color color;

  const DeviceType(this.code, this.displayName, this.icon, this.color);

  factory DeviceType.fromCode(String code) {
    return DeviceType.values.firstWhere(
      (t) => t.code == code,
      orElse: () => DeviceType.general,
    );
  }
}

/// 设备运行模式
enum DeviceMode {
  standby('standby', '待机', Icons.power_off, Color(0xFF9E9E9E)),
  charging('charging', '充电', Icons.battery_charging_full, Color(0xFF52C41A)),
  discharging('discharging', '放电', Icons.battery_alert, Color(0xFFFA8C16)),
  gridConnected('grid_connected', '并网', Icons.electrical_services, Color(0xFF4A90D9)),
  offGrid('off_grid', '离网', Icons.offline_bolt, Color(0xFF722ED1)),
  online('online', '在线', Icons.check_circle, Color(0xFF52C41A)),
  offline('offline', '离线', Icons.error_outline, Color(0xFFF44336));

  final String code;
  final String displayName;
  final IconData icon;
  final Color color;

  const DeviceMode(this.code, this.displayName, this.icon, this.color);

  factory DeviceMode.fromCode(String code) {
    return DeviceMode.values.firstWhere(
      (m) => m.code == code,
      orElse: () => DeviceMode.offline,
    );
  }
}

/// 告警级别
enum AlarmLevel {
  info('info', '提示', Icons.info, Color(0xFF1890FF)),
  warning('warning', '警告', Icons.warning, Color(0xFFFAAD14)),
  error('error', '异常', Icons.error, Color(0xFFFF4D4F)),
  critical('critical', '严重', Icons.dangerous, Color(0xFFCF1322));

  final String code;
  final String displayName;
  final IconData icon;
  final Color color;

  const AlarmLevel(this.code, this.displayName, this.icon, this.color);

  factory AlarmLevel.fromCode(String code) {
    return AlarmLevel.values.firstWhere(
      (a) => a.code == code,
      orElse: () => AlarmLevel.info,
    );
  }
}
