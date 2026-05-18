import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/config/theme.dart';
import 'package:ups_monitor_app/services/locale_service.dart';

class MonitorScreen extends StatefulWidget {
  final String deviceName;
  final String ipAddress;
  
  const MonitorScreen({
    super.key,
    this.deviceName = 'UPS Device',
    this.ipAddress = '192.168.1.100',
  });

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  // UPS实时数据（模拟）
  Map<String, dynamic> _upsData = {
    'status': 'Online',
    'inputVoltage': '220V',
    'outputVoltage': '220V',
    'inputFreq': '50Hz',
    'outputFreq': '50Hz',
    'loadPercent': 45,
    'batteryPercent': 85,
    'temperature': 35,
    'estimatedBackup': '15 min',
    'lastEvent': 'Power restored',
    'eventTime': '2026-05-12 19:00',
  };

  // 控制状态
  bool _isBuzzerOn = true;
  bool _isLoading = false;
  bool _isSelfTestRunning = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        final t = localeService.t;
        return Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          appBar: AppBar(
            backgroundColor: AppTheme.surfaceColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.deviceName,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.ipAddress,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            actions: [
              // 控制面板按钮
              IconButton(
                icon: const Icon(Icons.settings_remote, color: Colors.white70),
                tooltip: t('Control Panel'),
                onPressed: () => _showControlPanelSheet(context, localeService),
              ),
              // 连接状态指示
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.onlineColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.onlineColor, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.onlineColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.onlineColor.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      t('Online'),
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppTheme.onlineColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // 模拟刷新数据
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) {
                setState(() {
                  _upsData['loadPercent'] = 40 + (DateTime.now().second % 20);
                  _upsData['batteryPercent'] = 80 + (DateTime.now().minute % 20);
                });
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========== 主要数据卡片 ==========
                  _buildMainDataCard(localeService),
                  const SizedBox(height: 16),
                  
                  // ========== 输入输出数据 ==========
                  _buildVoltageCard(localeService),
                  const SizedBox(height: 16),
                  
                  // ========== 电池与温度 ==========
                  _buildBatteryTempCard(localeService),
                  const SizedBox(height: 16),
                  
                  // ========== 负载状态 ==========
                  _buildLoadCard(localeService),
                  const SizedBox(height: 16),
                  
                  // ========== 快捷操作按钮 ==========
                  _buildQuickActions(localeService),
                  const SizedBox(height: 16),
                  
                  // ========== 最近事件 ==========
                  _buildEventLog(localeService),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ========== 主要数据卡片 ==========
  Widget _buildMainDataCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMainStat(t('Battery'), '${_upsData['batteryPercent']}%', Icons.battery_full),
              _buildMainStat(t('Load'), '${_upsData['loadPercent']}%', Icons.electric_bolt),
              _buildMainStat(t('Backup'), _upsData['estimatedBackup'], Icons.timer),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${t('AC Input')}: ${_upsData['inputVoltage']} / ${_upsData['inputFreq']}',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // ========== 输入输出电压卡片 ==========
  Widget _buildVoltageCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.electrical_services, color: AppTheme.cyanGlow, size: 20),
              const SizedBox(width: 8),
              Text(
                t('Voltage & Frequency'),
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildVoltageItem(
                  t('Input'),
                  _upsData['inputVoltage'],
                  _upsData['inputFreq'],
                  AppTheme.cyanGlow,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white24,
              ),
              Expanded(
                child: _buildVoltageItem(
                  t('Output'),
                  _upsData['outputVoltage'],
                  _upsData['outputFreq'],
                  AppTheme.purpleAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoltageItem(String label, String voltage, String freq, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                voltage,
                style: GoogleFonts.orbitron(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                freq,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== 电池与温度卡片 ==========
  Widget _buildBatteryTempCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              t('Battery Capacity'),
              '${_upsData['batteryPercent']}%',
              Icons.battery_charging_full,
              AppTheme.successColor,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.white24,
          ),
          Expanded(
            child: _buildInfoItem(
              t('Temperature'),
              '${_upsData['temperature']}°C',
              Icons.thermostat,
              _upsData['temperature'] > 40 ? AppTheme.warningColor : AppTheme.cyanGlow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 11,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  // ========== 负载状态卡片 ==========
  Widget _buildLoadCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.electric_bolt, color: AppTheme.orangeAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                t('Load Status'),
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${_upsData['loadPercent']}%',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getLoadColor(_upsData['loadPercent']),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _upsData['loadPercent'] / 100,
              minHeight: 12,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(_getLoadColor(_upsData['loadPercent'])),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%',
                style: GoogleFonts.notoSans(fontSize: 10, color: Colors.white38),
              ),
              Text(
                '50%',
                style: GoogleFonts.notoSans(fontSize: 10, color: Colors.white38),
              ),
              Text(
                '100%',
                style: GoogleFonts.notoSans(fontSize: 10, color: Colors.white38),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLoadColor(int load) {
    if (load >= 80) return AppTheme.errorColor;
    if (load >= 50) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  // ========== 快捷操作按钮 ==========
  Widget _buildQuickActions(LocaleService localeService) {
    final t = localeService.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            t('Quick Actions'),
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                _isSelfTestRunning ? t('Testing...') : t('Self-Test'),
                Icons.play_arrow,
                AppTheme.cyanGlow,
                _isSelfTestRunning ? null : () => _performSelfTest(localeService),
                isLoading: _isSelfTestRunning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                _isBuzzerOn ? t('Buzzer ON') : t('Buzzer OFF'),
                _isBuzzerOn ? Icons.volume_up : Icons.volume_off,
                AppTheme.purpleAccent,
                _isLoading ? null : () => _toggleBuzzer(localeService),
                isLoading: _isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                t('Refresh'),
                Icons.refresh,
                AppTheme.orangeAccent,
                () {
                  setState(() {
                    _upsData['loadPercent'] = 40 + (DateTime.now().second % 20);
                  });
                  _showSnackBar(t('Data refreshed'), localeService);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 执行自检
  Future<void> _performSelfTest(LocaleService localeService) async {
    final t = localeService.t;
    setState(() => _isSelfTestRunning = true);

    try {
      final response = await http.post(
        Uri.parse('http://${widget.ipAddress}/control'),
        headers: {'Content-Type': 'application/json'},
        body: '{"command": "test"}',
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _showSuccessSnackBar(t('Self-test started successfully'), localeService);
        // 模拟自检状态更新
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() {
            _upsData['lastEvent'] = t('Self-Test');
            _upsData['eventTime'] = _formatDateTime(DateTime.now());
          });
        }
      } else {
        _showErrorSnackBar(t('Self-test failed'), localeService);
      }
    } catch (e) {
      _showErrorSnackBar('${t('Self-test request failed')}: $e', localeService);
    } finally {
      if (mounted) {
        setState(() => _isSelfTestRunning = false);
      }
    }
  }

  /// 切换蜂鸣器
  Future<void> _toggleBuzzer(LocaleService localeService) async {
    final t = localeService.t;
    setState(() => _isLoading = true);

    try {
      final command = _isBuzzerOn ? 'beep_off' : 'beep_on';
      final response = await http.post(
        Uri.parse('http://${widget.ipAddress}/control'),
        headers: {'Content-Type': 'application/json'},
        body: '{"command": "$command"}',
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() => _isBuzzerOn = !_isBuzzerOn);
        _showSuccessSnackBar(_isBuzzerOn ? t('Buzzer enabled') : t('Buzzer disabled'), localeService);
      } else {
        _showErrorSnackBar(t('Failed to toggle buzzer'), localeService);
      }
    } catch (e) {
      _showErrorSnackBar('${t('Buzzer toggle failed')}: $e', localeService);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// 显示控制面板底部弹窗
  void _showControlPanelSheet(BuildContext context, LocaleService localeService) {
    final t = localeService.t;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Row(
              children: [
                Icon(Icons.settings_remote, color: AppTheme.primaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  t('Control Panel'),
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.deviceName,
              style: GoogleFonts.notoSans(color: Colors.white54),
            ),
            const Divider(color: Colors.white24, height: 32),

            // 控制按钮网格
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildControlSheetButton(
                  icon: Icons.power_settings_new,
                  label: t('Shutdown'),
                  color: Colors.red,
                  onTap: () => _sendControlCommand('shutdown', t('Shutdown'), localeService),
                ),
                _buildControlSheetButton(
                  icon: Icons.refresh,
                  label: t('Restart'),
                  color: Colors.orange,
                  onTap: () => _sendControlCommand('restart', t('Restart'), localeService),
                ),
                _buildControlSheetButton(
                  icon: Icons.health_and_safety,
                  label: t('Self-Test'),
                  color: AppTheme.cyanGlow,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _performSelfTest(localeService);
                  },
                ),
                _buildControlSheetButton(
                  icon: Icons.electrical_services,
                  label: t('Bypass'),
                  color: Colors.purple,
                  onTap: () => _sendControlCommand('bypass', t('Bypass'), localeService),
                ),
                _buildControlSheetButton(
                  icon: Icons.volume_off,
                  label: t('Mute'),
                  color: Colors.grey,
                  onTap: () => _sendControlCommand('beep_off', t('Mute'), localeService),
                ),
                _buildControlSheetButton(
                  icon: Icons.volume_up,
                  label: t('Unmute'),
                  color: Colors.teal,
                  onTap: () => _sendControlCommand('beep_on', t('Unmute'), localeService),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: Text(t('Close')),
            ),
          ],
        ),
      ),
    );
  }

  /// 发送控制命令
  Future<void> _sendControlCommand(String command, String name, LocaleService localeService) async {
    final t = localeService.t;
    Navigator.pop(context); // 关闭底部弹窗

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text('${t('Confirm')} $name', style: GoogleFonts.notoSans(color: Colors.white)),
        content: Text('${t('Are you sure you want to')} $name?', style: GoogleFonts.notoSans(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('Cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('Confirm')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await http.post(
        Uri.parse('http://${widget.ipAddress}/control'),
        headers: {'Content-Type': 'application/json'},
        body: '{"command": "$command"}',
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _showSuccessSnackBar('$name ${t('command sent successfully')}', localeService);
      } else {
        _showErrorSnackBar('$name ${t('command failed')}', localeService);
      }
    } catch (e) {
      _showErrorSnackBar('${t('Request failed')}: $e', localeService);
    }
  }

  Widget _buildControlSheetButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback? onTap, {bool isLoading = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== 最近事件 ==========
  Widget _buildEventLog(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: AppTheme.primaryLightColor, size: 20),
              const SizedBox(width: 8),
              Text(
                t('Recent Events'),
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // 返回主页并切换到事件日志Tab
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t('Viewing all events')),
                      backgroundColor: AppTheme.infoColor,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  t('View All'),
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppTheme.primaryLightColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEventItem(
            t('Power restored'),
            '2026-05-12 19:00',
            Icons.power,
            AppTheme.successColor,
          ),
          _buildEventItem(
            t('Battery test completed'),
            '2026-05-12 14:30',
            Icons.battery_charging_full,
            AppTheme.infoColor,
          ),
          _buildEventItem(
            '${t('Load exceeded')} 80%',
            '2026-05-12 10:15',
            Icons.warning,
            AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String event, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, LocaleService localeService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackBar(String message, LocaleService localeService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message, LocaleService localeService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
