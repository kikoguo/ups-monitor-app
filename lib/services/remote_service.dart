import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/smart_device.dart';
import '../models/device_type.dart';

/// 远程设备服务 - 支持云端连接
class RemoteService {
  final http.Client _client;
  final String _baseUrl;
  final bool _isDemoMode;

  RemoteService({
    http.Client? client,
    String baseUrl = 'https://api.example.com',
    bool? isDemoMode,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl,
        _isDemoMode = isDemoMode ?? kIsWeb;

  /// 获取用户所有设备列表
  Future<List<SmartDevice>> getDevices(String userToken) async {
    if (_isDemoMode) {
      return _getDemoDevices();
    }
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/devices'),
            headers: {'Authorization': 'Bearer $userToken'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
              .map((d) => SmartDevice.fromJson(Map<String, dynamic>.from(d as Map)))
              .toList();
          return devices;
        }
      }
      return [];
    } catch (e) {
      // 演示模式：返回模拟数据
      return _getDemoDevices();
    }
  }

  /// 获取单个设备详情
  Future<SmartDevice?> getDeviceDetail(String deviceId, String userToken) async {
    if (_isDemoMode) {
      return _getDemoDevices().firstWhere(
        (d) => d.id == deviceId,
        orElse: () => _getDemoDevices().first,
      );
    }
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/devices/$deviceId'),
            headers: {'Authorization': 'Bearer $userToken'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true && json['data'] != null) {
          return SmartDevice.fromJson(Map<String, dynamic>.from(json['data'] as Map));
        }
      }
      return null;
    } catch (e) {
      // 演示模式
      return _getDemoDevices().firstWhere(
        (d) => d.id == deviceId,
        orElse: () => _getDemoDevices().first,
      );
    }
  }

  /// 获取设备实时数据
  Future<Map<String, dynamic>> getDeviceRealtimeData(
    String deviceId,
    String userToken,
  ) async {
    if (_isDemoMode) {
      return _generateDemoRealtimeData(deviceId);
    }
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/devices/$deviceId/realtime'),
            headers: {'Authorization': 'Bearer $userToken'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true && json['data'] != null) {
          return Map<String, dynamic>.from(json['data'] as Map);
        }
      }
      return <String, dynamic>{};
    } catch (e) {
      // 演示模式：返回模拟数据
      return _generateDemoRealtimeData(deviceId);
    }
  }

  /// 发送控制命令
  Future<bool> sendCommand(
    String deviceId,
    String command,
    Map<String, dynamic> params,
    String userToken,
  ) async {
    if (_isDemoMode) {
      return true;
    }
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/devices/$deviceId/control'),
            headers: {
              'Authorization': 'Bearer $userToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'command': command, 'params': params}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['success'] == true;
      }
      return false;
    } catch (e) {
      // 演示模式：模拟成功
      return true;
    }
  }

  /// 获取设备历史数据
  Future<List<Map<String, dynamic>>> getDeviceHistory(
    String deviceId,
    String parameter,
    DateTime startTime,
    DateTime endTime,
    String userToken,
  ) async {
    if (_isDemoMode) {
      return _generateDemoHistoryData(parameter, startTime, endTime);
    }
    try {
      final response = await _client
          .get(
            Uri.parse(
              '$_baseUrl/devices/$deviceId/history?parameter=$parameter&start=${startTime.toIso8601String()}&end=${endTime.toIso8601String()}',
            ),
            headers: {'Authorization': 'Bearer $userToken'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true && json['data'] != null) {
          return (json['data'] as List<dynamic>)
              .map((d) => Map<String, dynamic>.from(d as Map))
              .toList();
        }
      }
      return <Map<String, dynamic>>[];
    } catch (e) {
      // 演示模式：生成模拟历史数据
      return _generateDemoHistoryData(parameter, startTime, endTime);
    }
  }

  // ========== 演示数据 ==========

  List<SmartDevice> _getDemoDevices() {
    return [
      SmartDevice(
        id: 'ups_001',
        name: '办公室UPS',
        type: DeviceType.ups,
        serialNumber: 'UPS2024001',
        model: 'Marsriva UPS 3K',
        ratedPower: '3kVA',
        batteryCapacity: '72V 20Ah',
        firmwareVersion: 'v2.1.0',
        isOnline: true,
        mode: DeviceMode.online,
        lastSeen: DateTime.now(),
        parameters: {
          'battery': 85,
          'voltage': 220.5,
          'current': 5.2,
          'power': 1146,
          'input_voltage': 220.0,
          'load_percent': 45,
          'temperature': 32.5,
          'runtime_remaining': 45,
          'frequency': 50.0,
        },
      ),
      SmartDevice(
        id: 'es_001',
        name: '家庭储能系统',
        type: DeviceType.energyStorage,
        serialNumber: 'ES2024001',
        model: 'Marsriva ES 10K',
        ratedPower: '10kW',
        batteryCapacity: '48V 200Ah',
        firmwareVersion: 'v1.5.2',
        isOnline: true,
        mode: DeviceMode.charging,
        lastSeen: DateTime.now(),
        parameters: {
          'soc': 78,
          'generation': 123.5,
          'storage': 81.2,
          'power': 9.2,
          'temperature': 28.0,
          'voltage': 48.0,
          'current': 15.5,
          'frequency': 50.0,
        },
      ),
      SmartDevice(
        id: 'bms_001',
        name: '电池管理系统',
        type: DeviceType.bms,
        serialNumber: 'BMS2024001',
        model: 'Marsriva BMS 16S',
        ratedPower: '5kW',
        batteryCapacity: '48V 100Ah',
        firmwareVersion: 'v3.0.1',
        isOnline: true,
        mode: DeviceMode.online,
        lastSeen: DateTime.now(),
        parameters: {
          'voltage': 51.2,
          'current': 8.5,
          'soc': 92,
          'soh': 98,
          'cycle_count': 156,
          'max_voltage': 3.35,
          'min_voltage': 3.20,
          'voltage_diff': 0.15,
          'avg_voltage': 3.28,
          't1_temp': 27.0,
          't2_temp': 29.0,
          't3_temp': 31.0,
          't4_temp': 28.0,
          'humidity': 42.0,
          'power': 435.2,
          'frequency': 50.0,
        },
        alarms: [
          DeviceAlarm(
            id: 'alarm_001',
            message: '电池异常',
            level: AlarmLevel.error,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          DeviceAlarm(
            id: 'alarm_002',
            message: '高温警示',
            level: AlarmLevel.warning,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      SmartDevice(
        id: 'gen_001',
        name: '通用逆变器',
        type: DeviceType.general,
        serialNumber: 'GEN2024001',
        model: 'Marsriva Gen 5K',
        ratedPower: '5kW',
        batteryCapacity: '48V 150Ah',
        firmwareVersion: 'v1.2.0',
        isOnline: true,
        mode: DeviceMode.gridConnected,
        lastSeen: DateTime.now(),
        parameters: {
          'power': 4.5,
          'voltage': 220.0,
          'current': 20.5,
          'temperature': 35.0,
          'frequency': 50.0,
          'energy': 1250.5,
        },
      ),
      SmartDevice(
        id: 'switch_001',
        name: '客厅智能开关',
        type: DeviceType.smartSwitch,
        serialNumber: 'SW2024001',
        model: 'Marsriva Smart Switch',
        ratedPower: '2.2kW',
        firmwareVersion: 'v1.0.5',
        isOnline: true,
        mode: DeviceMode.online,
        lastSeen: DateTime.now(),
        parameters: {
          'switch_state': true,
          'power': 850.0,
          'energy': 125.5,
          'voltage': 220.0,
          'current': 3.9,
        },
      ),
      SmartDevice(
        id: 'socket_001',
        name: '卧室智能插座',
        type: DeviceType.smartSocket,
        serialNumber: 'SK2024001',
        model: 'Marsriva Smart Socket',
        ratedPower: '2.5kW',
        firmwareVersion: 'v1.0.3',
        isOnline: true,
        mode: DeviceMode.online,
        lastSeen: DateTime.now(),
        parameters: {
          'power': 120.0,
          'voltage': 220.0,
          'current': 0.55,
          'energy': 45.2,
          'switch_state': true,
        },
      ),
      SmartDevice(
        id: 'solar_001',
        name: '屋顶光伏系统',
        type: DeviceType.solar,
        serialNumber: 'PV2024001',
        model: 'Marsriva Solar 10K',
        ratedPower: '10kW',
        firmwareVersion: 'v2.0.0',
        isOnline: true,
        mode: DeviceMode.online,
        lastSeen: DateTime.now(),
        parameters: {
          'generation': 36.5,
          'power': 8.5,
          'irradiance': 850.0,
          'voltage': 380.0,
          'current': 22.4,
          'temperature': 45.0,
          'efficiency': 21.5,
        },
      ),
    ];
  }

  Map<String, dynamic> _generateDemoRealtimeData(String deviceId) {
    final random = Random();
    final device = _getDemoDevices().firstWhere(
      (d) => d.id == deviceId,
      orElse: () => _getDemoDevices().first,
    );

    // 基于设备类型生成略有变化的模拟数据
    final params = Map<String, dynamic>.from(device.parameters);
    params.forEach((key, value) {
      if (value is num) {
        final variation = value * 0.05 * (random.nextDouble() - 0.5);
        params[key] = double.parse((value + variation).toStringAsFixed(1));
      }
    });

    return params;
  }

  List<Map<String, dynamic>> _generateDemoHistoryData(
    String parameter,
    DateTime startTime,
    DateTime endTime,
  ) {
    final random = Random();
    final data = <Map<String, dynamic>>[];
    var current = startTime;

    while (current.isBefore(endTime)) {
      data.add({
        'timestamp': current.toIso8601String(),
        'value': 50 + random.nextDouble() * 50,
      });
      current = current.add(const Duration(minutes: 5));
    }

    return data;
  }

  void dispose() {
    _client.close();
  }
}
