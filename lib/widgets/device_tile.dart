import 'package:flutter/material.dart';
import 'package:ups_monitor_app/models/device_info.dart';
import 'package:ups_monitor_app/models/ups_status.dart';
import 'package:ups_monitor_app/config/theme.dart';

/// 设备列表项组件
class DeviceTile extends StatelessWidget {
  final DeviceInfo device;
  final UPSStatus? status;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DeviceTile({
    super.key,
    required this.device,
    this.status,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  // 设备图标
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.power,
                      color: _getStatusColor(),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 设备信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getStatusColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getStatusText(),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStatusColor(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.wifi,
                              size: 14,
                              color: const Color(0xFFBDBDBD),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              device.ipAddress,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // 箭头
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFBDBDBD),
                  ),
                ],
              ),
              
              // 如果有状态数据，显示摘要信息
              if (status != null) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                
                // 状态摘要
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusItem(
                      icon: Icons.electric_bolt,
                      label: '电压',
                      value: '${status!.voltage.toStringAsFixed(1)}V',
                    ),
                    _buildStatusItem(
                      icon: Icons.battery_charging_full,
                      label: '电量',
                      value: '${status!.battery}%',
                      color: _getBatteryColor(status!.battery),
                    ),
                    _buildStatusItem(
                      icon: Icons.trending_up,
                      label: '负载',
                      value: '${status!.loadPercent}%',
                      color: _getLoadColor(status!.loadPercent),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color ?? AppTheme.primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    if (status == null) return const Color(0xFF757575);
    return AppTheme.getStatusColor(status!.upsMode);
  }

  String _getStatusText() {
    if (status == null) return '离线';
    return AppTheme.getStatusText(status!.upsMode);
  }

  Color _getBatteryColor(int battery) {
    if (battery >= 50) return AppTheme.successColor;
    if (battery >= 20) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  Color _getLoadColor(int load) {
    if (load < 70) return AppTheme.successColor;
    if (load < 90) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}
