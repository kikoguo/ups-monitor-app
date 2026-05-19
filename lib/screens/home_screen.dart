import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/config/theme.dart';
import 'package:ups_monitor_app/screens/monitor_screen.dart';
import 'package:ups_monitor_app/services/locale_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Map<String, dynamic>> _devices = [
    {'name': 'UPS Device 1', 'ip': '192.168.1.100', 'status': 'Online', 'battery': 85, 'load': 45},
    {'name': 'UPS Device 2', 'ip': '192.168.1.101', 'status': 'Online', 'battery': 92, 'load': 30},
    {'name': 'UPS Device 3', 'ip': '192.168.1.102', 'status': 'Offline', 'battery': 0, 'load': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        final t = localeService.t;
        return Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildDeviceListPage(localeService),
              _buildEventLogPage(localeService),
              _buildSettingsPage(localeService),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.dashboard, t('Dashboard')),
                    _buildNavItem(1, Icons.history, t('Events')),
                    _buildNavItem(2, Icons.settings, t('Settings')),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(onPressed: () => _showAddDeviceDialog(context, localeService), backgroundColor: AppTheme.primaryColor, child: const Icon(Icons.add))
              : null,
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.white54, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: isSelected ? AppTheme.primaryColor : Colors.white54, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceListPage(LocaleService localeService) {
    final t = localeService.t;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: AppTheme.surfaceColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(gradient: AppTheme.deepSpaceGradient),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(gradient: AppTheme.brandGradient, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.bolt, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('MARSRIVA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryLightColor, letterSpacing: 2)),
                              Text(t('Keep Life Power On'), style: const TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(color: AppTheme.onlineColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppTheme.onlineColor.withOpacity(0.5), blurRadius: 4)]),
                            ),
                            const SizedBox(width: 8),
                            Text('${_devices.where((d) => d['status'] == 'Online').length} ${t('Device(s) Online')}', style: const TextStyle(fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Text(t('My Devices'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const Spacer(),
                Text('${_devices.length} ${t('devices')}', style: const TextStyle(fontSize: 12, color: Colors.white54)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final device = _devices[index];
                return Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildDeviceCard(device, localeService));
              },
              childCount: _devices.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device, LocaleService localeService) {
    final t = localeService.t;
    final isOnline = device['status'] == 'Online';
    final statusColor = isOnline ? AppTheme.onlineColor : AppTheme.offlineColor;
    
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MonitorScreen(deviceName: device['name'], ipAddress: device['ip']))),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
          boxShadow: [BoxShadow(color: statusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.electric_bolt, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(device['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                            child: Text(t(device['status']), style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(device['ip'], style: const TextStyle(fontSize: 12, color: Colors.white54)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white38),
              ],
            ),
            if (isOnline) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildMiniStat(t('Battery'), '${device['battery']}%', Icons.battery_full, AppTheme.successColor)),
                  Container(width: 1, height: 30, color: Colors.white12),
                  Expanded(child: _buildMiniStat(t('Load'), '${device['load']}%', Icons.electric_bolt, AppTheme.orangeAccent)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          ],
        ),
      ],
    );
  }

  Widget _buildEventLogPage(LocaleService localeService) {
    final events = [
      {'time': '19:00', 'date': '2026-05-12', 'event': 'Power restored', 'type': 'success'},
      {'time': '14:30', 'date': '2026-05-12', 'event': 'Battery test completed', 'type': 'info'},
      {'time': '10:15', 'date': '2026-05-12', 'event': 'Load exceeded 80%', 'type': 'warning'},
      {'time': '09:30', 'date': '2026-05-11', 'event': 'Firmware updated', 'type': 'info'},
    ];
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.surfaceColor,
          title: Text(localeService.t('Event Log'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildEventCard(events[index], localeService),
              childCount: events.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, LocaleService localeService) {
    Color typeColor;
    IconData typeIcon;
    switch (event['type']) {
      case 'success': typeColor = AppTheme.successColor; typeIcon = Icons.check_circle; break;
      case 'warning': typeColor = AppTheme.warningColor; typeIcon = Icons.warning; break;
      case 'error': typeColor = AppTheme.errorColor; typeIcon = Icons.error; break;
      default: typeColor = AppTheme.infoColor; typeIcon = Icons.info;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: typeColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: typeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(typeIcon, color: typeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localeService.t(event['event']), style: const TextStyle(fontSize: 14, color: Colors.white)),
                const SizedBox(height: 4),
                Text('${event['date']} ${event['time']}', style: const TextStyle(fontSize: 11, color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage(LocaleService localeService) {
    final t = localeService.t;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.surfaceColor,
          title: Text(t('Settings'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSettingsItem(Icons.language, t('Language'), localeService.languageName, () => _showLanguageDialog(context, localeService)),
                _buildSettingsItem(Icons.notifications, t('Notifications'), t('Enabled'), () {}),
                _buildSettingsItem(Icons.info, t('About'), t('Version 1.0.0'), () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleService localeService) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(localeService.t('Language'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('English', style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(dialogContext)),
            ListTile(title: const Text('中文', style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(dialogContext)),
          ],
        ),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context, LocaleService localeService) {
    final nameController = TextEditingController();
    final ipController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(localeService.t('Add Device'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Device Name', labelStyle: TextStyle(color: Colors.white54))),
            const SizedBox(height: 16),
            TextField(controller: ipController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'IP Address', labelStyle: TextStyle(color: Colors.white54))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(localeService.t('Cancel'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text(localeService.t('Add')),
          ),
        ],
      ),
    );
  }
}
