import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  
  // 模拟设备列表
  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'UPS Device 1',
      'ip': '192.168.1.100',
      'status': 'Online',
      'battery': 85,
      'load': 45,
    },
    {
      'name': 'UPS Device 2',
      'ip': '192.168.1.101',
      'status': 'Online',
      'battery': 92,
      'load': 30,
    },
    {
      'name': 'UPS Device 3',
      'ip': '192.168.1.102',
      'status': 'Offline',
      'battery': 0,
      'load': 0,
    },
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
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
              ? FloatingActionButton(
                  onPressed: () {
                    _showAddDeviceDialog(context, localeService);
                  },
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.add),
                )
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
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: isSelected ? AppTheme.primaryColor : Colors.white54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== 设备列表页面 ==========
  Widget _buildDeviceListPage(LocaleService localeService) {
    final t = localeService.t;
    return CustomScrollView(
      slivers: [
        // 顶部品牌栏
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: AppTheme.surfaceColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.deepSpaceGradient,
              ),
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
                            decoration: BoxDecoration(
                              gradient: AppTheme.brandGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.bolt, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MARSRIVA',
                                style: GoogleFonts.orbitron(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryLightColor,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                t('Keep Life Power On'),
                                style: GoogleFonts.rajdhani(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 在线设备数量
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                            const SizedBox(width: 8),
                            Text(
                              '${_devices.where((d) => d['status'] == 'Online').length} ${t('Device(s) Online')}',
                              style: GoogleFonts.notoSans(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
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
        
        // 设备列表标题
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Text(
                  t('My Devices'),
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_devices.length} ${t('devices')}',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // 设备列表
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final device = _devices[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildDeviceCard(device, localeService),
                );
              },
              childCount: _devices.length,
            ),
          ),
        ),
        
        // 底部留白
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device, LocaleService localeService) {
    final t = localeService.t;
    final isOnline = device['status'] == 'Online';
    final statusColor = isOnline ? AppTheme.onlineColor : AppTheme.offlineColor;
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MonitorScreen(
              deviceName: device['name'],
              ipAddress: device['ip'],
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
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // 状态指示
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.electric_bolt,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                
                // 设备信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            device['name'],
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              t(device['status']),
                              style: GoogleFonts.notoSans(
                                fontSize: 10,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device['ip'],
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 箭头
                Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                ),
              ],
            ),
            
            if (isOnline) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 16),
              
              // 电池和负载
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStat(
                      t('Battery'),
                      '${device['battery']}%',
                      Icons.battery_full,
                      AppTheme.successColor,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white12,
                  ),
                  Expanded(
                    child: _buildMiniStat(
                      t('Load'),
                      '${device['load']}%',
                      Icons.electric_bolt,
                      AppTheme.orangeAccent,
                    ),
                  ),
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
            Text(
              value,
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 10,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== 事件日志页面 ==========
  Widget _buildEventLogPage(LocaleService localeService) {
    final t = localeService.t;
    final events = [
      {'time': '19:00', 'date': '2026-05-12', 'event': 'Power restored', 'type': 'success'},
      {'time': '14:30', 'date': '2026-05-12', 'event': 'Battery test completed', 'type': 'info'},
      {'time': '10:15', 'date': '2026-05-12', 'event': 'Load exceeded 80%', 'type': 'warning'},
      {'time': '09:30', 'date': '2026-05-11', 'event': 'Firmware updated', 'type': 'info'},
      {'time': '08:00', 'date': '2026-05-11', 'event': 'UPS restarted', 'type': 'info'},
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.surfaceColor,
          title: Text(
            t('Event Log'),
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final event = events[index];
                return _buildEventCard(event, localeService);
              },
              childCount: events.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, LocaleService localeService) {
    final t = localeService.t;
    Color typeColor;
    IconData typeIcon;
    
    switch (event['type']) {
      case 'success':
        typeColor = AppTheme.successColor;
        typeIcon = Icons.check_circle;
        break;
      case 'warning':
        typeColor = AppTheme.warningColor;
        typeIcon = Icons.warning;
        break;
      case 'error':
        typeColor = AppTheme.errorColor;
        typeIcon = Icons.error;
        break;
      default:
        typeColor = AppTheme.infoColor;
        typeIcon = Icons.info;
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
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(typeIcon, color: typeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(event['event']),
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${event['date']} ${event['time']}',
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

  // ========== 设置页面 ==========
  Widget _buildSettingsPage(LocaleService localeService) {
    final t = localeService.t;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.surfaceColor,
          title: Text(
            t('Settings'),
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSettingsItem(Icons.language, t('Language'), localeService.languageName, () => _showLanguageDialog(context, localeService)),
                _buildSettingsItem(Icons.notifications, t('Notifications'), t('Enabled'), () => _showNotificationsDialog(context, localeService)),
                _buildSettingsItem(Icons.wifi, t('WiFi Settings'), t('Connected'), () => _showWifiDialog(context, localeService)),
                _buildSettingsItem(Icons.system_update, t('Firmware Update'), t('Check for updates'), () => _checkFirmwareUpdate(context, localeService)),
                _buildSettingsItem(Icons.info, t('About'), t('Version 1.0.0'), () => _showAboutDialog(context, localeService)),
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
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(
          title,
          style: GoogleFonts.notoSans(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.notoSans(fontSize: 12, color: Colors.white54),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: onTap,
      ),
    );
  }

  /// 语言选择对话框
  void _showLanguageDialog(BuildContext context, LocaleService localeService) {
    final t = localeService.t;
    String selectedLanguage = localeService.locale.languageCode;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            t('Language'),
            style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageTile('English', 'en', selectedLanguage, (code) {
                setDialogState(() => selectedLanguage = code);
              }),
              _buildLanguageTile('中文', 'zh', selectedLanguage, (code) {
                setDialogState(() => selectedLanguage = code);
              }),
              _buildLanguageTile('Español', 'es', selectedLanguage, (code) {
                setDialogState(() => selectedLanguage = code);
              }),
              _buildLanguageTile('日本語', 'ja', selectedLanguage, (code) {
                setDialogState(() => selectedLanguage = code);
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t('Cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await localeService.setLocale(Locale(selectedLanguage));
              },
              child: Text(t('Confirm')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String language, String code, String selectedCode, Function(String) onSelect) {
    final isSelected = selectedCode == code;
    return ListTile(
      title: Text(language, style: GoogleFonts.notoSans(color: Colors.white)),
      trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryColor) : null,
      onTap: () => onSelect(code),
    );
  }

  /// 通知设置对话框
  void _showNotificationsDialog(BuildContext context, LocaleService localeService) {
    final t = localeService.t;
    bool notificationsEnabled = true;
    bool emailAlerts = true;
    bool pushNotifications = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            t('Notifications'),
            style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(t('Enable Notifications'), style: GoogleFonts.notoSans(color: Colors.white)),
                value: notificationsEnabled,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setDialogState(() => notificationsEnabled = value);
                },
              ),
              SwitchListTile(
                title: Text(t('Email Alerts'), style: GoogleFonts.notoSans(color: Colors.white)),
                value: emailAlerts,
                activeColor: AppTheme.primaryColor,
                onChanged: notificationsEnabled ? (value) {
                  setDialogState(() => emailAlerts = value);
                } : null,
              ),
              SwitchListTile(
                title: Text(t('Push Notifications'), style: GoogleFonts.notoSans(color: Colors.white)),
                value: pushNotifications,
                activeColor: AppTheme.primaryColor,
                onChanged: notificationsEnabled ? (value) {
                  setDialogState(() => pushNotifications = value);
                } : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t('Cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(t('Notification settings saved')),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: Text(t('Save')),
            ),
          ],
        ),
      ),
    );
  }

  /// WiFi设置对话框
  void _showWifiDialog(BuildContext context, LocaleService localeService) {
    final t = localeService.t;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          t('WiFi Settings'),
          style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.wifi, color: AppTheme.successColor),
              title: Text(t('Connected'), style: GoogleFonts.notoSans(color: Colors.white)),
              subtitle: Text('Network: Home_WiFi_5G', style: GoogleFonts.notoSans(color: Colors.white54)),
            ),
            const Divider(color: Colors.white24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${t('Signal Strength')}:', style: GoogleFonts.notoSans(color: Colors.white54)),
                      Text(t('Excellent'), style: GoogleFonts.notoSans(color: AppTheme.successColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${t('IP Address')}:', style: GoogleFonts.notoSans(color: Colors.white54)),
                      Text('192.168.1.50', style: GoogleFonts.notoSans(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t('Close')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text(t('Searching for networks')),
                  backgroundColor: AppTheme.infoColor,
                ),
              );
            },
            child: Text(t('Refresh')),
          ),
        ],
      ),
    );
  }

  /// 检查固件更新
  void _checkFirmwareUpdate(BuildContext context, LocaleService localeService) {
    final t = localeService.t;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.system_update, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(t('Firmware Update'), style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successColor, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    t('You are up to date!'),
                    style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${t('Current version')}: 1.0.0',
                    style: GoogleFonts.notoSans(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t('Close')),
          ),
        ],
      ),
    );
  }

  /// 关于对话框
  void _showAboutDialog(BuildContext context, LocaleService localeService) {
    final t = localeService.t;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.brandGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text('MARSRIVA', style: GoogleFonts.orbitron(color: AppTheme.primaryLightColor, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('UPS Monitor App'),
              style: GoogleFonts.notoSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(t('Version 1.0.0'), style: GoogleFonts.notoSans(color: Colors.white54)),
            const SizedBox(height: 16),
            Text(
              t('Keep Life Power On'),
              style: GoogleFonts.rajdhani(color: Colors.white70, fontSize: 14),
            ),
            const Divider(color: Colors.white24, height: 24),
            Text('© 2026 ${t('MARSRIVA Technology')}', style: GoogleFonts.notoSans(color: Colors.white54, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t('Close')),
          ),
        ],
      ),
    );
  }

  // ========== 添加设备对话框 ==========
  void _showAddDeviceDialog(BuildContext context, LocaleService localeService) {
    final t = localeService.t;
    final nameController = TextEditingController();
    final ipController = TextEditingController();
    String selectedStatus = 'Online';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            t('Add Device'),
            style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: t('Device Name'),
                    labelStyle: const TextStyle(color: Colors.white54),
                    hintText: 'e.g., UPS Office',
                    hintStyle: TextStyle(color: Colors.white24),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ipController,
                  decoration: InputDecoration(
                    labelText: t('IP Address'),
                    labelStyle: const TextStyle(color: Colors.white54),
                    hintText: 'e.g., 192.168.1.100',
                    hintStyle: TextStyle(color: Colors.white24),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                Text(
                  t('Device Status'),
                  style: GoogleFonts.notoSans(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusChip(t('Online'), selectedStatus == 'Online', () {
                        setDialogState(() => selectedStatus = 'Online');
                      }, AppTheme.onlineColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusChip(t('Offline'), selectedStatus == 'Offline', () {
                        setDialogState(() => selectedStatus = 'Offline');
                      }, AppTheme.offlineColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t('Cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final ip = ipController.text.trim();

                if (name.isEmpty || ip.isEmpty) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(t('Please fill in all fields')),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }

                // 验证IP格式
                final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                if (!ipRegex.hasMatch(ip)) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(t('Invalid IP address format')),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }

                setState(() {
                  _devices.add({
                    'name': name,
                    'ip': ip,
                    'status': selectedStatus,
                    'battery': selectedStatus == 'Online' ? 85 : 0,
                    'load': selectedStatus == 'Online' ? 45 : 0,
                  });
                });

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text('${t('Device added successfully')}: $name'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: Text(t('Add')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isSelected, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.notoSans(
              color: isSelected ? color : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
