import 'package:flutter/material.dart';
import '../models/smart_device.dart';
import '../models/device_type.dart';
import '../models/device_parameters.dart';
import '../services/remote_service.dart';
import 'more_data_screen.dart';

class DeviceDetailScreen extends StatefulWidget {
  final SmartDevice device;
  const DeviceDetailScreen({super.key, required this.device});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

enum ConnectionType { wifi, bluetooth }

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final RemoteService _remoteService = RemoteService();
  late SmartDevice _device;
  Map<String, dynamic> _realtimeData = {};
  bool _isLoading = true;
  bool _isConnecting = false;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _loadRealtimeData();
  }

  Future<void> _loadRealtimeData() async {
    setState(() => _isLoading = true);
    final data = await _remoteService.getDeviceRealtimeData(_device.id, 'demo_token');
    if (mounted) {
      setState(() {
        _realtimeData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _connectDevice(ConnectionType type) async {
    setState(() {
      _isConnecting = true;
      _connectionError = null;
    });

    // 模拟连接过程
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isConnecting = false;
        // 假设连接成功
        _device = SmartDevice(
          id: _device.id,
          name: _device.name,
          type: _device.type,
          localIp: _device.localIp,
          isOnline: true,
          lastSeen: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(type == ConnectionType.wifi ? 'WiFi连接成功' : '蓝牙连接成功'),
          backgroundColor: const Color(0xFF52C41A),
        ),
      );
    }
  }

  void _showConnectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '连接设备',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 8),
            Text(
              '请选择连接方式：${_device.localIp}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _connectDevice(ConnectionType.wifi);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF4A90D9).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.wifi, color: const Color(0xFF4A90D9), size: 40),
                          const SizedBox(height: 12),
                          const Text(
                            'WiFi 连接',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4A90D9)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _device.localIp ?? '未设置',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _connectDevice(ConnectionType.bluetooth);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF722ED1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF722ED1).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.bluetooth, color: const Color(0xFF722ED1), size: 40),
                          const SizedBox(height: 12),
                          const Text(
                            '蓝牙连接',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF722ED1)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '搜索中...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionBanner() {
    if (_isConnecting) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: const Color(0xFF4A90D9).withOpacity(0.1),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF4A90D9)),
            ),
            SizedBox(width: 12),
            Text('正在连接...', style: TextStyle(fontSize: 14, color: Color(0xFF4A90D9))),
          ],
        ),
      );
    }

    if (!_device.isOnline) {
      return GestureDetector(
        onTap: _showConnectionDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: const Color(0xFFFF4D4F).withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Color(0xFFFF4D4F), size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '设备未连接，点击连接',
                  style: TextStyle(fontSize: 14, color: Color(0xFFFF4D4F)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4D4F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '连接',
                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFF52C41A).withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.wifi, color: Color(0xFF52C41A), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '已连接 ${_device.localIp}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF52C41A)),
            ),
          ),
          GestureDetector(
            onTap: _showConnectionDialog,
            child: const Text(
              '切换',
              style: TextStyle(fontSize: 14, color: Color(0xFF4A90D9), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final params = DeviceParameterConfig.getParameters(_device.type.code);
    final mainParams = params.where((p) => p.isMain).toList();
    final otherParams = params.where((p) => !p.isMain).take(6).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  _buildConnectionBanner(),
                  _buildAppBar(),
                  _buildDeviceInfoCard(),
                  _buildModeSelector(),
                  _buildMainParameters(mainParams),
                  _buildMoreDataButton(),
                  _buildOtherParameters(otherParams),
                  if (_device.alarms.isNotEmpty) _buildAlarmSection(),
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildInfoItem('序列号', _device.serialNumber.isEmpty ? '--' : _device.serialNumber)),
                Expanded(child: _buildInfoItem('设备类型', _device.model.isEmpty ? _device.type.displayName : _device.model)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInfoItem('额定功率', _device.ratedPower.isEmpty ? '--' : _device.ratedPower)),
                Expanded(child: _buildInfoItem('电池容量', _device.batteryCapacity.isEmpty ? '--' : _device.batteryCapacity)),
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
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1A1A2E))),
      ],
    );
  }

  Widget _buildModeSelector() {
    final modes = [DeviceMode.standby, DeviceMode.charging, DeviceMode.discharging, DeviceMode.offGrid, DeviceMode.gridConnected];
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('运行模式', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
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
                        color: isActive ? mode.color.withOpacity(0.15) : Colors.grey[100],
                        shape: BoxShape.circle,
                        border: isActive ? Border.all(color: mode.color, width: 2) : null,
                      ),
                      child: Icon(mode.icon, color: isActive ? mode.color : Colors.grey, size: 24),
                    ),
                    const SizedBox(height: 6),
                    Text(mode.displayName, style: TextStyle(fontSize: 11, color: isActive ? mode.color : Colors.grey)),
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
            crossAxisCount: 2, childAspectRatio: 1.4, crossAxisSpacing: 12, mainAxisSpacing: 12,
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A90D9)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(param.name, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _getParamIcon(String iconType) {
    IconData iconData;
    Color iconColor;
    switch (iconType) {
      case 'battery': iconData = Icons.battery_full; iconColor = const Color(0xFF52C41A); break;
      case 'power': iconData = Icons.electric_bolt; iconColor = const Color(0xFFFAAD14); break;
      case 'voltage': iconData = Icons.electrical_services; iconColor = const Color(0xFF4A90D9); break;
      case 'solar': iconData = Icons.wb_sunny; iconColor = const Color(0xFFFADB14); break;
      default: iconData = Icons.speed; iconColor = const Color(0xFF4A90D9);
    }
    return Icon(iconData, color: iconColor, size: 24);
  }

  Widget _buildMoreDataButton() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MoreDataScreen(device: _device))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('查看更多', style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Colors.grey, size: 20),
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
            crossAxisCount: 2, childAspectRatio: 2.2, crossAxisSpacing: 12, mainAxisSpacing: 12,
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _getParamIcon(param.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$value ${param.unit}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 2),
                Text(param.name, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
            const Text('告警状态', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: const Color(0xFFFF4D4F).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('2', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF4D4F)))),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildAlarmCard(_device.alarms[0])),
                const SizedBox(width: 12),
                if (_device.alarms.length > 1) Expanded(child: _buildAlarmCard(_device.alarms[1])),
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
          Text(alarm.message, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: alarm.level.color)),
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
            Expanded(child: _buildControlButton('开关', Icons.power_settings_new, _device.parameters['switch_state'] == true ? const Color(0xFFFF4D4F) : Colors.grey, () {})),
            const SizedBox(width: 12),
            Expanded(child: _buildControlButton('充电', Icons.battery_charging_full, _device.mode == DeviceMode.charging ? const Color(0xFF52C41A) : Colors.grey, () {})),
            const SizedBox(width: 12),
            Expanded(child: _buildControlButton('频率', Icons.speed, const Color(0xFF4A90D9), () {})),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E))),
          ],
        ),
      ),
    );
  }

  void _showSettings() {}

  @override
  void dispose() {
    _remoteService.dispose();
    super.dispose();
  }
}
