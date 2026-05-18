/// 应用配置文件
class AppConfig {
  /// 状态刷新间隔（毫秒）
  static const int statusRefreshInterval = 3000;

  /// 自动发现超时（秒）
  static const int discoveryTimeout = 10;

  /// 连接超时（秒）
  static const int connectionTimeout = 10;

  /// 默认低电量阈值
  static const int lowBatteryThreshold = 20;

  /// 默认严重低电量阈值
  static const int criticalBatteryThreshold = 10;

  /// 历史记录保留数量
  static const int maxHistoryRecords = 100;

  /// 设备在线检测间隔（秒）
  static const int onlineCheckInterval = 30;
}
