/// 设备参数定义（每种设备类型有不同的参数）
class DeviceParameter {
  final String key;
  final String name;
  final String unit;
  final String icon;
  final bool isMain;

  const DeviceParameter({
    required this.key,
    required this.name,
    required this.unit,
    this.icon = '',
    this.isMain = false,
  });
}

/// 设备参数配置
class DeviceParameterConfig {
  /// UPS 设备参数
  static const List<DeviceParameter> ups = [
    DeviceParameter(key: 'battery', name: '电池电量', unit: '%', icon: 'battery', isMain: true),
    DeviceParameter(key: 'voltage', name: '输出电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'current', name: '输出电流', unit: 'A', icon: 'current'),
    DeviceParameter(key: 'power', name: '输出功率', unit: 'W', icon: 'power', isMain: true),
    DeviceParameter(key: 'input_voltage', name: '输入电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'load_percent', name: '负载率', unit: '%', icon: 'load'),
    DeviceParameter(key: 'temperature', name: '温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 'runtime_remaining', name: '剩余时间', unit: 'min', icon: 'time'),
    DeviceParameter(key: 'frequency', name: '频率', unit: 'Hz', icon: 'frequency'),
  ];

  /// 储能设备参数
  static const List<DeviceParameter> energyStorage = [
    DeviceParameter(key: 'soc', name: 'SOC', unit: '%', icon: 'battery', isMain: true),
    DeviceParameter(key: 'generation', name: '发电量', unit: 'kWh', icon: 'solar', isMain: true),
    DeviceParameter(key: 'storage', name: '储电量', unit: 'kWh', icon: 'battery'),
    DeviceParameter(key: 'power', name: '功率', unit: 'kW', icon: 'power', isMain: true),
    DeviceParameter(key: 'temperature', name: '温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 'voltage', name: '电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'current', name: '电流', unit: 'A', icon: 'current'),
    DeviceParameter(key: 'frequency', name: '频率', unit: 'Hz', icon: 'frequency'),
  ];

  /// BMS 设备参数
  static const List<DeviceParameter> bms = [
    DeviceParameter(key: 'voltage', name: '总电压', unit: 'V', icon: 'voltage', isMain: true),
    DeviceParameter(key: 'current', name: '电流', unit: 'A', icon: 'current'),
    DeviceParameter(key: 'soc', name: 'SOC', unit: '%', icon: 'battery', isMain: true),
    DeviceParameter(key: 'soh', name: '电池健康度', unit: '%', icon: 'health'),
    DeviceParameter(key: 'cycle_count', name: '循环次数', unit: '次', icon: 'cycle'),
    DeviceParameter(key: 'max_voltage', name: '最高电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'min_voltage', name: '最低电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'voltage_diff', name: '压差', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'avg_voltage', name: '平均电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 't1_temp', name: 'T1温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 't2_temp', name: 'T2温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 't3_temp', name: 'T3温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 't4_temp', name: 'T4温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 'humidity', name: '湿度', unit: '%', icon: 'humidity'),
    DeviceParameter(key: 'power', name: '功率', unit: 'W', icon: 'power'),
    DeviceParameter(key: 'frequency', name: '频率', unit: 'Hz', icon: 'frequency'),
  ];

  /// 通用设备参数
  static const List<DeviceParameter> general = [
    DeviceParameter(key: 'power', name: '功率', unit: 'kW', icon: 'power', isMain: true),
    DeviceParameter(key: 'voltage', name: '电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'current', name: '电流', unit: 'A', icon: 'current'),
    DeviceParameter(key: 'temperature', name: '温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 'frequency', name: '频率', unit: 'Hz', icon: 'frequency'),
    DeviceParameter(key: 'energy', name: '电能', unit: 'kWh', icon: 'energy'),
  ];

  /// 智能开关参数
  static const List<DeviceParameter> smartSwitch = [
    DeviceParameter(key: 'switch_state', name: '开关状态', unit: '', icon: 'switch', isMain: true),
    DeviceParameter(key: 'power', name: '功率', unit: 'W', icon: 'power'),
    DeviceParameter(key: 'energy', name: '用电量', unit: 'kWh', icon: 'energy'),
    DeviceParameter(key: 'voltage', name: '电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'current', name: '电流', unit: 'A', icon: 'current'),
  ];

  /// 智能插座参数
  static const List<DeviceParameter> smartSocket = [
    DeviceParameter(key: 'power', name: '功率', unit: 'W', icon: 'power', isMain: true),
    DeviceParameter(key: 'voltage', name: '电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'current', name: '电流', unit: 'A', icon: 'current'),
    DeviceParameter(key: 'energy', name: '用电量', unit: 'kWh', icon: 'energy'),
    DeviceParameter(key: 'switch_state', name: '开关状态', unit: '', icon: 'switch'),
  ];

  /// 光伏设备参数
  static const List<DeviceParameter> solar = [
    DeviceParameter(key: 'generation', name: '发电量', unit: 'kWh', icon: 'solar', isMain: true),
    DeviceParameter(key: 'power', name: '功率', unit: 'kW', icon: 'power', isMain: true),
    DeviceParameter(key: 'irradiance', name: '辐照度', unit: 'W/m²', icon: 'sun'),
    DeviceParameter(key: 'voltage', name: '电压', unit: 'V', icon: 'voltage'),
    DeviceParameter(key: 'current', name: '电流', unit: 'A', icon: 'current'),
    DeviceParameter(key: 'temperature', name: '温度', unit: '°C', icon: 'temperature'),
    DeviceParameter(key: 'efficiency', name: '效率', unit: '%', icon: 'efficiency'),
  ];

  /// 获取设备类型的参数列表
  static List<DeviceParameter> getParameters(String typeCode) {
    switch (typeCode) {
      case 'ups': return ups;
      case 'energy_storage': return energyStorage;
      case 'bms': return bms;
      case 'smart_switch': return smartSwitch;
      case 'smart_socket': return smartSocket;
      case 'solar': return solar;
      default: return general;
    }
  }

  /// 获取主参数（用于卡片显示）
  static List<DeviceParameter> getMainParameters(String typeCode) {
    return getParameters(typeCode).where((p) => p.isMain).toList();
  }
}
