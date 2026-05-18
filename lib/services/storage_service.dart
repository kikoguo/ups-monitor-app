import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ups_monitor_app/models/device_info.dart';
import 'package:ups_monitor_app/models/ups_status.dart';

/// 本地存储服务
class StorageService {
  /// SharedPreferences实例
  SharedPreferences? _prefs;

  /// 存储键
  static const String _devicesKey = 'devices';
  static const String _settingsKey = 'settings';
  static const String _historyKey = 'history';

  /// 初始化
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 保存设备列表
  Future<bool> saveDevices(List<DeviceInfo> devices) async {
    if (_prefs == null) await init();

    final jsonList = devices.map((d) => d.toJson()).toList();
    return await _prefs!.setString(_devicesKey, jsonEncode(jsonList));
  }

  /// 加载设备列表
  Future<List<DeviceInfo>> loadDevices() async {
    if (_prefs == null) await init();

    final jsonString = _prefs!.getString(_devicesKey);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => DeviceInfo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 添加设备
  Future<bool> addDevice(DeviceInfo device) async {
    final devices = await loadDevices();
    
    // 检查是否已存在
    if (devices.any((d) => d.ipAddress == device.ipAddress)) {
      return false;
    }

    devices.add(device);
    return await saveDevices(devices);
  }

  /// 删除设备
  Future<bool> removeDevice(String deviceId) async {
    final devices = await loadDevices();
    devices.removeWhere((d) => d.id == deviceId);
    return await saveDevices(devices);
  }

  /// 更新设备
  Future<bool> updateDevice(DeviceInfo device) async {
    final devices = await loadDevices();
    final index = devices.indexWhere((d) => d.id == device.id);
    
    if (index == -1) return false;

    devices[index] = device;
    return await saveDevices(devices);
  }

  /// 保存设置
  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(_settingsKey, jsonEncode(settings));
  }

  /// 加载设置
  Future<Map<String, dynamic>> loadSettings() async {
    if (_prefs == null) await init();

    final jsonString = _prefs!.getString(_settingsKey);
    if (jsonString == null) return _defaultSettings;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return _defaultSettings;
    }
  }

  /// 获取设置项
  Future<T?> getSetting<T>(String key) async {
    final settings = await loadSettings();
    return settings[key] as T?;
  }

  /// 设置设置项
  Future<bool> setSetting<T>(String key, T value) async {
    final settings = await loadSettings();
    settings[key] = value;
    return await saveSettings(settings);
  }

  /// 保存历史记录
  Future<bool> saveHistory(String deviceId, List<UPSStatus> history) async {
    if (_prefs == null) await init();

    final key = '${_historyKey}_$deviceId';
    final jsonList = history.map((s) => s.toJson()).toList();
    return await _prefs!.setString(key, jsonEncode(jsonList));
  }

  /// 加载历史记录
  Future<List<UPSStatus>> loadHistory(String deviceId) async {
    if (_prefs == null) await init();

    final key = '${_historyKey}_$deviceId';
    final jsonString = _prefs!.getString(key);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => UPSStatus.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 清空历史记录
  Future<bool> clearHistory(String deviceId) async {
    if (_prefs == null) await init();

    final key = '${_historyKey}_$deviceId';
    return await _prefs!.remove(key);
  }

  /// 清空所有数据
  Future<bool> clearAll() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  /// 默认设置
  Map<String, dynamic> get _defaultSettings => {
        'refresh_interval': 3000, // 毫秒
        'auto_discovery': true,
        'notifications_enabled': true,
        'low_battery_threshold': 20,
        'critical_battery_threshold': 10,
        'theme_mode': 'system', // light, dark, system
      };
}
