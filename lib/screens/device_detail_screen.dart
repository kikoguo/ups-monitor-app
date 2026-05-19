import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/smart_device.dart';
import '../models/device_type.dart';
import '../models/device_parameters.dart';
import '../services/remote_service.dart';
import 'more_data_screen.dart';

/// 设备详情页 - 显示设备详细参数和控制
class DeviceDetailScreen extends StatefulWidget {
  final SmartDevice device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final RemoteService _remoteService = RemoteService();
  late SmartDevice _device;
  Map<String, dynamic> _realtimeData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _loadRealtimeData();
  }

  Future<void> _loadRealtimeData() async {
    setState(() => _isLoading = true);
    final data = await _remoteService.getDeviceRealtimeData(
      _device.id,
      'demo_token',
    );
    setState(() {
      _realtimeData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final params = DeviceParameterConfig.getParameters(_device.type.code);
    final mainParams = params.where((p) => p.isMain).toList();
    final otherParams = params.where((p) => !p.isMain).take(6).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // 顶部导航栏
                  _buildAppBar(),
                  // 设备信息卡片
                  _buildDeviceInfoCard(),
                  // 运行模式
                  _buildModeSelector(),
                  // 主要参数
                  _buildMainParameters(mainParams),
                  // 查看更多
                  _buildMoreDataButton(),
                  // 其他参数
                  _buildOtherParameters(otherParams),
                  // 告警状态
                  if (_device.alarms.isNotEmpty) _buildAlarmSection(),
                  // 控制按钮
                  _buildControlButtons(),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(width: 12),
            Icon(Icons.wifi, color: _device.isOnline ? const Color(0xFF52C41A) : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _device.name,
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => _showSettings(),
              child: const Icon(Icons.settings_outlined, color: Color(0xFF1A1A2E)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('序列号', _device.serialNumber.isEmpty ? '--' : _device.serialNumber),
                ),
                Expanded(
                  child: _buildInfoItem('设备类型', _device.model.isEmpty ? _device.type.displayName : _device.model),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('额定功率', _device.ratedPower.isEmpty ? '--' : _device.ratedPower),
                ),
                Expanded(
                  child: _buildInfoItem('电池容量', _device.batteryCapacity.isEmpty ? '--' : _device.batteryCapacity),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSans(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    final modes = [
      DeviceMode.standby,
      DeviceMode.charging,
      DeviceMode.discharging,
      DeviceMode.offGrid,
      DeviceMode.gridConnected,
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '运行模式',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: modes.map((mode) {
                final isActive = _device.mode == mode;
                return Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isActive
                            ? mode.color.withOpacity(0.15)
                            : Colors.grey[100],
                        shape: BoxShape.circle,
                        border: isActive
                            ? Border.all(color: mode.color, width: 2)
                            : null,
                      ),
                      child: Icon(
                        mode.icon,
                        color: isActive ? mode.color : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      mode.displayName,
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: isActive ? mode.color : Colors.grey,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainParameters(List<DeviceParameter> mainParams) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: mainParams.length,
          itemBuilder: (context, index) {
            final param = mainParams[index];
            final value = _realtimeData[param.key] ?? _device.parameters[param.key] ?? '--';
            return _buildParamCard(param, value.toString());
          },
        ),
      ),
    );
  }

  Widget _buildParamCard(DeviceParameter param, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getParamIcon(param.icon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$value ${param.unit}',
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A90D9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            param.name,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getParamIcon(String iconType) {
    IconData iconData;
    Color iconColor;
    switch (iconType) {
      case 'battery':
        iconData = Icons.battery_full;
        iconColor = const Color(0xFF52C41A);
        break;
      case 'power':
        iconData = Icons.electric_bolt;
        iconColor = const Color(0xFFFAAD14);
        break;
      case 'voltage':
        iconData = Icons.electrical_services;
        iconColor = const Color(0xFF4A90D9);
        break;
      case 'solar':
        iconData = Icons.wb_sunny;
        iconColor = const Color(0xFFFADB14);
        break;
      default:
        iconData = Icons.speed;
        iconColor = const Color(0xFF4A90D9);
    }
    return Icon(iconData, color: iconColor, size: 24);
  }

  Widget _buildMoreDataButton() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoreDataScreen(device: _device),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '查看更多',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherParameters(List<DeviceParameter> otherParams) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: otherParams.length,
          itemBuilder: (context, index) {
            final param = otherParams[index];
            final value = _realtimeData[param.key] ?? _device.parameters[param.key] ?? '--';
            return _buildSmallParamCard(param, value.toString());
          },
        ),
      ),
    );
  }

  Widget _buildSmallParamCard(DeviceParameter param, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _getParamIcon(param.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$value ${param.unit}',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  param.name,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '告警状态',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D4F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF4D4F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAlarmCard(_device.alarms[0]),
                ),
                const SizedBox(width: 12),
                if (_device.alarms.length > 1)
                  Expanded(
                    child: _buildAlarmCard(_device.alarms[1]),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmCard(DeviceAlarm alarm) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alarm.level.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alarm.level.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(alarm.level.icon, color: alarm.level.color, size: 20),
          const SizedBox(height: 8),
          Text(
            alarm.message,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: alarm.level.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildControlButton(
                '开关',
                Icons.power_settings_new,
                _device.parameters['switch_state'] == true
                    ? const Color(0xFFFF4D4F)
                    : Colors.grey,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildControlButton(
                '充电',
                Icons.battery_charging_full,
                _device.mode == DeviceMode.charging
                    ? const Color(0xFF52C41A)
                    : Colors.grey,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildControlButton(
                '频率',
                Icons.speed,
                const Color(0xFF4A90D9),
                () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    // TODO: 实现设置页面
  }

  @override
  void dispose() {
    _remoteService.dispose();
    super.dispose();
  }
}
