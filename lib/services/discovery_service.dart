import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ups_monitor_app/models/device_info.dart';
import 'package:ups_monitor_app/services/network_service.dart';

/// 设备发现服务
class DiscoveryService {
  /// 网络服务
  final NetworkService _networkService;

  /// 发现超时时间（秒）
  static const int discoveryTimeout = 5;

  /// 扫描的IP范围
  static const String subnet = '192.168.1'; // 可根据需要修改

  DiscoveryService({NetworkService? networkService})
      : _networkService = networkService ?? NetworkService();

  /// 扫描局域网内的UPS设备
  Future<List<DeviceInfo>> scanDevices() async {
    final List<DeviceInfo> devices = [];
    final List<Future<DeviceInfo?>> futures = [];

    // 扫描IP段 1-254
    for (int i = 1; i <= 254; i++) {
      final ip = '$subnet.$i';
      futures.add(_checkDevice(ip));
    }

    // 并发检查所有IP
    final results = await Future.wait(futures);

    // 收集发现的设备
    for (final device in results) {
      if (device != null) {
        devices.add(device);
      }
    }

    return devices;
  }

  /// 检查单个IP是否为UPS设备
  Future<DeviceInfo?> _checkDevice(String ip) async {
    try {
      // 使用health接口快速检查
      final response = await http
          .get(Uri.parse('http://$ip/health'))
          .timeout(Duration(seconds: discoveryTimeout));

      if (response.statusCode == 200) {
        // 设备在线，尝试获取设备信息
        try {
          final deviceInfo = await _networkService.getDeviceInfo(ip);
          return deviceInfo;
        } catch (e) {
          // 如果获取设备信息失败，返回基本信息
          return DeviceInfo(
            id: ip.replaceAll('.', '_'),
            name: 'UPS-$ip',
            ipAddress: ip,
            lastSeen: DateTime.now(),
            isOnline: true,
          );
        }
      }
    } catch (e) {
      // 忽略超时和其他错误
    }
    return null;
  }

  /// 检查指定IP的设备
  Future<DeviceInfo?> checkDevice(String ip) async {
    return _checkDevice(ip);
  }

  /// 验证设备是否在线
  Future<bool> isDeviceOnline(String ip) async {
    return _networkService.healthCheck(ip);
  }

  /// 手动添加设备
  Future<DeviceInfo?> addDeviceManually(String ip) async {
    if (!_isValidIp(ip)) {
      return null;
    }

    try {
      final deviceInfo = await _networkService.getDeviceInfo(ip);
      return deviceInfo;
    } catch (e) {
      // 如果获取失败，返回基本信息
      if (await isDeviceOnline(ip)) {
        return DeviceInfo(
          id: ip.replaceAll('.', '_'),
          name: 'UPS-$ip',
          ipAddress: ip,
          lastSeen: DateTime.now(),
          isOnline: true,
        );
      }
      return null;
    }
  }

  /// 验证IP地址格式
  bool _isValidIp(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
    }

    return true;
  }

  /// 释放资源
  void dispose() {
    _networkService.dispose();
  }
}
