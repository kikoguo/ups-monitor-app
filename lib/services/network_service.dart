import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ups_monitor_app/models/ups_status.dart';
import 'package:ups_monitor_app/models/device_info.dart';

/// 网络请求服务
class NetworkService {
  /// HTTP客户端
  final http.Client _client;

  /// 连接超时时间（秒）
  static const int connectionTimeout = 10;

  /// 读取超时时间（秒）
  static const int readTimeout = 10;

  NetworkService({http.Client? client}) : _client = client ?? http.Client();

  /// 获取UPS状态
  Future<UPSStatus> getUPSStatus(String ipAddress) async {
    try {
      final response = await _client
          .get(Uri.parse('http://$ipAddress/status'))
          .timeout(Duration(seconds: connectionTimeout));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true && json['data'] != null) {
          return UPSStatus.fromJson(json['data'] as Map<String, dynamic>);
        }
      }
      
      throw NetworkException('获取状态失败: ${response.statusCode}');
    } on TimeoutException {
      throw NetworkException('连接超时');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('网络错误: $e');
    }
  }

  /// 获取设备信息
  Future<DeviceInfo> getDeviceInfo(String ipAddress) async {
    try {
      final response = await _client
          .get(Uri.parse('http://$ipAddress/info'))
          .timeout(Duration(seconds: connectionTimeout));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true && json['data'] != null) {
          return DeviceInfo.fromApiResponse(
            json['data'] as Map<String, dynamic>,
            ipAddress,
          );
        }
      }
      
      throw NetworkException('获取设备信息失败: ${response.statusCode}');
    } on TimeoutException {
      throw NetworkException('连接超时');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('网络错误: $e');
    }
  }

  /// 健康检查
  Future<bool> healthCheck(String ipAddress) async {
    try {
      final response = await _client
          .get(Uri.parse('http://$ipAddress/health'))
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 发送控制命令
  Future<bool> sendControlCommand(String ipAddress, String command) async {
    try {
      final response = await _client
          .post(
            Uri.parse('http://$ipAddress/control'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'command': command}),
          )
          .timeout(Duration(seconds: connectionTimeout));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['success'] == true;
      }
      
      return false;
    } on TimeoutException {
      throw NetworkException('连接超时');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('网络错误: $e');
    }
  }

  /// 关闭UPS
  Future<bool> shutdown(String ipAddress) async {
    return sendControlCommand(ipAddress, 'shutdown');
  }

  /// 重启UPS
  Future<bool> restart(String ipAddress) async {
    return sendControlCommand(ipAddress, 'restart');
  }

  /// 自检
  Future<bool> test(String ipAddress) async {
    return sendControlCommand(ipAddress, 'test');
  }

  /// 切换旁路模式
  Future<bool> bypass(String ipAddress) async {
    return sendControlCommand(ipAddress, 'bypass');
  }

  /// 关闭蜂鸣器
  Future<bool> mute(String ipAddress) async {
    return sendControlCommand(ipAddress, 'beep_off');
  }

  /// 开启蜂鸣器
  Future<bool> unmute(String ipAddress) async {
    return sendControlCommand(ipAddress, 'beep_on');
  }

  /// 释放资源
  void dispose() {
    _client.close();
  }
}

/// 网络异常
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}
