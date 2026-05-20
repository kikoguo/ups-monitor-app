import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/models/device_info.dart';
import 'package:ups_monitor_app/services/network_service.dart';
import 'package:ups_monitor_app/services/locale_service.dart';
import 'package:ups_monitor_app/config/theme.dart';

/// 控制面板页面
class ControlScreen extends StatefulWidget {
  final DeviceInfo device;

  const ControlScreen({super.key, required this.device});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool _isLoading = false;
  String? _message;

  /// 发送控制命令
  Future<void> _sendCommand(String command, String nameKey) async {
    final t = context.read<LocaleService>().t;
    
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final networkService = context.read<NetworkService>();
      final success = await networkService.sendControlCommand(
        widget.device.ipAddress,
        command,
      );

      final successKey = '$nameKey success';
      final failedKey = '$nameKey failed';
      
      setState(() {
        _isLoading = false;
        _message = success ? t(successKey) : t(failedKey);
      });

      if (success) {
        _showSuccess(t('Command sent'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '${t('Operation failed')}: $e';
      });
      _showError('${t('Operation failed')}: $e');
    }
  }

  /// 关机
  void _shutdown() {
    final t = context.read<LocaleService>().t;
    _confirmAction(
      t('Shutdown'),
      t('Confirm shutdown?'),
      () => _sendCommand('shutdown', 'Shutdown'),
    );
  }

  /// 重启
  void _restart() {
    final t = context.read<LocaleService>().t;
    _confirmAction(
      t('Restart'),
      t('Confirm restart?'),
      () => _sendCommand('restart', 'Restart'),
    );
  }

  /// 自检
  void _test() {
    final t = context.read<LocaleService>().t;
    _confirmAction(
      t('Self-Test'),
      t('Confirm self-test?'),
      () => _sendCommand('test', 'Self-Test'),
    );
  }

  /// 旁路
  void _bypass() {
    final t = context.read<LocaleService>().t;
    _confirmAction(
      t('Bypass Mode'),
      t('Confirm bypass?'),
      () => _sendCommand('bypass', 'Bypass'),
    );
  }

  /// 静音
  void _mute() {
    _sendCommand('beep_off', 'Mute');
  }

  /// 取消静音
  void _unmute() {
    _sendCommand('beep_on', 'Unmute');
  }

  /// 确认操作
  Future<void> _confirmAction(String title, String message, VoidCallback onConfirm) async {
    final t = context.read<LocaleService>().t;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t('Confirm')),
          ),
        ],
      ),
    );

    if (result == true) {
      onConfirm();
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF44336),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LocaleService>().t;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Control Panel')),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(t('Sending command...')),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 设备信息
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.power,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.device.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.device.ipAddress,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 控制按钮区域
                  Text(
                    t('Control Operations'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 主要控制按钮
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildControlButton(
                        icon: Icons.power_settings_new,
                        label: t('Shutdown'),
                        color: const Color(0xFFF44336),
                        onPressed: _shutdown,
                      ),
                      _buildControlButton(
                        icon: Icons.refresh,
                        label: t('Restart'),
                        color: const Color(0xFFFF9800),
                        onPressed: _restart,
                      ),
                      _buildControlButton(
                        icon: Icons.health_and_safety,
                        label: t('Self-Test'),
                        color: const Color(0xFF2196F3),
                        onPressed: _test,
                      ),
                      _buildControlButton(
                        icon: Icons.electrical_services,
                        label: t('Bypass Mode'),
                        color: const Color(0xFF9C27B0),
                        onPressed: _bypass,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 告警控制
                  Text(
                    t('Alarm Control'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildControlButton(
                          icon: Icons.volume_off,
                          label: t('Mute'),
                          color: const Color(0xFF9E9E9E),
                          onPressed: _mute,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildControlButton(
                          icon: Icons.volume_up,
                          label: t('Unmute'),
                          color: const Color(0xFF009688),
                          onPressed: _unmute,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 提示信息
                  Card(
                    color: const Color(0xFFFFF8E1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFFFFA000),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              t('Control command may take a few seconds to take effect, please be patient.'),
                              style: TextStyle(
                                color: const Color(0xFFFF6F00),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
