import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/config/theme.dart';
import 'package:ups_monitor_app/services/locale_service.dart';

class MonitorScreen extends StatefulWidget {
  final String deviceName;
  final String ipAddress;
  
  const MonitorScreen({super.key, this.deviceName = 'UPS Device', this.ipAddress = '192.168.1.100'});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
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
  };

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
                Text(widget.deviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(widget.ipAddress, style: const TextStyle(fontSize: 12, color: Colors.white54)),
              ],
            ),
            actions: [
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
                      width: 8, height: 8,
                      decoration: BoxDecoration(color: AppTheme.onlineColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppTheme.onlineColor.withOpacity(0.5), blurRadius: 4)]),
                    ),
                    const SizedBox(width: 6),
                    Text(t('Online'), style: const TextStyle(fontSize: 12, color: AppTheme.onlineColor, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) setState(() {
                _upsData['loadPercent'] = 40 + (DateTime.now().second % 20);
                _upsData['batteryPercent'] = 80 + (DateTime.now().minute % 20);
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainDataCard(localeService),
                  const SizedBox(height: 16),
                  _buildVoltageCard(localeService),
                  const SizedBox(height: 16),
                  _buildBatteryTempCard(localeService),
                  const SizedBox(height: 16),
                  _buildLoadCard(localeService),
                  const SizedBox(height: 16),
                  _buildQuickActions(localeService),
                  const SizedBox(height: 16),
                  _buildEventLog(localeService),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainDataCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
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
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('${t('AC Input')}: ${_upsData['inputVoltage']} / ${_upsData['inputFreq']}', style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
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
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildVoltageCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.electrical_services, color: AppTheme.cyanGlow, size: 20),
              const SizedBox(width: 8),
              Text(t('Voltage & Frequency'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildVoltageItem(t('Input'), _upsData['inputVoltage'], _upsData['inputFreq'], AppTheme.cyanGlow)),
              Container(width: 1, height: 50, color: Colors.white24),
              Expanded(child: _buildVoltageItem(t('Output'), _upsData['outputVoltage'], _upsData['outputFreq'], AppTheme.purpleAccent)),
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
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(voltage, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(width: 8),
              Text(freq, style: const TextStyle(fontSize: 14, color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryTempCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Row(
        children: [
          Expanded(child: _buildInfoItem(t('Battery Capacity'), '${_upsData['batteryPercent']}%', Icons.battery_charging_full, AppTheme.successColor)),
          Container(width: 1, height: 60, color: Colors.white24),
          Expanded(child: _buildInfoItem(t('Temperature'), '${_upsData['temperature']}°C', Icons.thermostat, _upsData['temperature'] > 40 ? AppTheme.warningColor : AppTheme.cyanGlow)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
      ],
    );
  }

  Widget _buildLoadCard(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.electric_bolt, color: AppTheme.orangeAccent, size: 20),
              const SizedBox(width: 8),
              Text(t('Load Status'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const Spacer(),
              Text('${_upsData['loadPercent']}%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getLoadColor(_upsData['loadPercent']))),
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
            children: const [
              Text('0%', style: TextStyle(fontSize: 10, color: Colors.white38)),
              Text('50%', style: TextStyle(fontSize: 10, color: Colors.white38)),
              Text('100%', style: TextStyle(fontSize: 10, color: Colors.white38)),
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

  Widget _buildQuickActions(LocaleService localeService) {
    final t = localeService.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(t('Quick Actions'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Row(
          children: [
            Expanded(child: _buildActionButton(t('Self-Test'), Icons.play_arrow, AppTheme.cyanGlow, () {})),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton(t('Buzzer'), Icons.volume_up, AppTheme.purpleAccent, () {})),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton(t('Refresh'), Icons.refresh, AppTheme.orangeAccent, () {
              setState(() => _upsData['loadPercent'] = 40 + (DateTime.now().second % 20));
            })),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
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
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventLog(LocaleService localeService) {
    final t = localeService.t;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: AppTheme.primaryLightColor, size: 20),
              const SizedBox(width: 8),
              Text(t('Recent Events'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          _buildEventItem(t('Power restored'), '2026-05-12 19:00', Icons.power, AppTheme.successColor),
          _buildEventItem(t('Battery test completed'), '2026-05-12 14:30', Icons.battery_charging_full, AppTheme.infoColor),
          _buildEventItem('${t('Load exceeded')} 80%', '2026-05-12 10:15', Icons.warning, AppTheme.warningColor),
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
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event, style: const TextStyle(fontSize: 14, color: Colors.white)),
                Text(time, style: const TextStyle(fontSize: 11, color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
