import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/config/theme.dart';
import 'package:ups_monitor_app/models/device_type.dart';
import 'package:ups_monitor_app/models/smart_device.dart';
import 'package:ups_monitor_app/screens/device_list_screen.dart';
import 'package:ups_monitor_app/services/locale_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 模拟用户绑定的设备数据
  final List<SmartDevice> _userDevices = [
    SmartDevice(
      id: 'ups_001',
      name: '办公室UPS',
      type: DeviceType.ups,
      serialNumber: 'UPS2024001',
      model: 'Marsriva UPS 3K',
      ratedPower: '3kVA',
      batteryCapacity: '72V 20Ah',
      isOnline: true,
      mode: DeviceMode.online,
      lastSeen: DateTime.now(),
      parameters: {'battery': 86.5, 'load': 45.8, 'output_voltage': 225.7, 'output_current': 5.2, 'input_voltage': 216.4, 'output_power': 1160.1},
    ),
    SmartDevice(
      id: 'ups_002',
      name: '机房UPS',
      type: DeviceType.ups,
      serialNumber: 'UPS2024002',
      model: 'Marsriva UPS 5K',
      ratedPower: '5kVA',
      batteryCapacity: '96V 30Ah',
      isOnline: true,
      mode: DeviceMode.charging,
      lastSeen: DateTime.now(),
      parameters: {'battery': 92.0, 'load': 30.0, 'output_voltage': 220.0, 'output_current': 3.8, 'input_voltage': 218.0, 'output_power': 836.0},
    ),
    SmartDevice(
      id: 'bms_001',
      name: '储能电池组A',
      type: DeviceType.bms,
      serialNumber: 'BMS2024001',
      model: 'Marsriva BMS 100',
      ratedPower: '5kW',
      batteryCapacity: '48V 200Ah',
      isOnline: true,
      mode: DeviceMode.online,
      lastSeen: DateTime.now(),
      parameters: {'voltage': 48.2, 'current': 25.5, 'soc': 78.0, 'temperature': 32.0},
    ),
    SmartDevice(
      id: 'solar_001',
      name: '屋顶光伏',
      type: DeviceType.solar,
      serialNumber: 'SOL2024001',
      model: 'Marsriva Solar 10K',
      ratedPower: '10kW',
      batteryCapacity: 'N/A',
      isOnline: false,
      mode: DeviceMode.offline,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      parameters: {'generation': 45.2, 'today_generation': 28.5, 'efficiency': 18.2},
    ),
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
              _buildCategoryPage(localeService),
              _buildEventLogPage(localeService),
              _buildSettingsPage(localeService),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [BoxShadow(color: const Color(0xFF000000).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home, t('Home')),
                    _buildNavItem(1, Icons.history, t('Events')),
                    _buildNavItem(2, Icons.settings, t('Settings')),
                  ],
                ),
              ),
            ),
          ),
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
            Icon(icon, color: isSelected ? AppTheme.primaryColor : const Color(0xFFBDBDBD), size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: isSelected ? AppTheme.primaryColor : const Color(0xFFBDBDBD), fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  // 首页 - 设备分类
  Widget _buildCategoryPage(LocaleService localeService) {
    final t = localeService.t;
    
    // 按设备类型分组统计
    final Map<DeviceType, List<SmartDevice>> groupedDevices = {};
    for (final device in _userDevices) {
      groupedDevices.putIfAbsent(device.type, () => []).add(device);
    }

    // 在线设备数
    final onlineCount = _userDevices.where((d) => d.isOnline).length;

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
                            child: const Icon(Icons.bolt, color: Color(0xFFFFFFFF), size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('MARSRIVA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryLightColor, letterSpacing: 2)),
                              Text(t('Keep Life Power On'), style: const TextStyle(fontSize: 12, color: Color(0xFFB0BEC5))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFFFFFFF).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(color: AppTheme.onlineColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppTheme.onlineColor.withOpacity(0.5), blurRadius: 4)]),
                            ),
                            const SizedBox(width: 8),
                            Text('$onlineCount/${_userDevices.length} ${t('Device(s) Online')}', style: const TextStyle(fontSize: 12, color: Color(0xFFFFFFFF))),
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
                Text(t('Device Categories'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                const Spacer(),
                Text('${groupedDevices.length} ${t('categories')}', style: const TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final type = groupedDevices.keys.elementAt(index);
                final devices = groupedDevices[type]!;
                final onlineDevices = devices.where((d) => d.isOnline).length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryCard(type, devices.length, onlineDevices, localeService),
                );
              },
              childCount: groupedDevices.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildCategoryCard(DeviceType type, int totalCount, int onlineCount, LocaleService localeService) {
    return InkWell(
      onTap: () {
        // 进入该分类的设备列表页
        final devices = _userDevices.where((d) => d.type == type).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceListScreen(
              categoryName: type.displayName,
              devices: devices,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: type.color.withOpacity(0.3), width: 1),
          boxShadow: [BoxShadow(color: type.color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: type.color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
              child: Icon(type.icon, color: type.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                  const SizedBox(height: 4),
                  Text('$totalCount ${localeService.t('devices')}', style: const TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.onlineColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.onlineColor, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('$onlineCount', style: const TextStyle(fontSize: 12, color: AppTheme.onlineColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.chevron_right, color: Color(0xFF616161)),
              ],
            ),
          ],
        ),
      ),
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
          title: Text(localeService.t('Event Log'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
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
                Text(localeService.t(event['event']), style: const TextStyle(fontSize: 14, color: Color(0xFFFFFFFF))),
                const SizedBox(height: 4),
                Text('${event['date']} ${event['time']}', style: const TextStyle(fontSize: 11, color: Color(0xFF616161))),
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
          title: Text(t('Settings'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
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
        title: Text(title, style: const TextStyle(color: Color(0xFFFFFFFF))),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF616161)),
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
        title: Text(localeService.t('Language'), style: const TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('English', style: TextStyle(color: Color(0xFFFFFFFF))), onTap: () => Navigator.pop(dialogContext)),
            ListTile(title: const Text('中文', style: TextStyle(color: Color(0xFFFFFFFF))), onTap: () => Navigator.pop(dialogContext)),
          ],
        ),
      ),
    );
  }
}
