import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/smart_device.dart';
import '../models/device_type.dart';
import '../services/remote_service.dart';
import '../services/storage_service.dart';
import 'device_detail_screen.dart';

/// 设备网格首页 - 类似轻快云风格
class DeviceGridScreen extends StatefulWidget {
  const DeviceGridScreen({super.key});

  @override
  State<DeviceGridScreen> createState() => _DeviceGridScreenState();
}

class _DeviceGridScreenState extends State<DeviceGridScreen> {
  final RemoteService _remoteService = RemoteService();
  List<SmartDevice> _devices = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _isLoading = true);
    // 先从本地存储加载已保存的设备
    final storageService = context.read<StorageService>();
    final savedDevices = await storageService.loadSmartDevices();
    if (mounted) {
      setState(() {
        _devices = savedDevices;
        _isLoading = false;
      });
    }
    // 再尝试从远程获取更新
    try {
      final devices = await _remoteService.getDevices('demo_token');
      if (mounted && devices.isNotEmpty) {
        // 合并远程设备（不覆盖已有的自定义设备）
        final existingIds = _devices.map((d) => d.id).toSet();
        final newDevices = devices.where((d) => !existingIds.contains(d.id)).toList();
        if (newDevices.isNotEmpty) {
          setState(() {
            _devices = [..._devices, ...newDevices];
          });
          await storageService.saveSmartDevices(_devices);
        }
      }
    } catch (_) {
      // 远程加载失败不影响本地数据显示
    }
  }

  List<SmartDevice> get _filteredDevices {
    if (_searchQuery.isEmpty) return _devices;
    return _devices
        .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildDeviceGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  hintText: '设备名称',
                  hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF9E9E9E)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showAddDeviceDialog(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Color(0xFFFFFFFF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceGrid() {
    if (_filteredDevices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.devices_other, size: 64, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 16),
            const Text(
              '暂无设备',
              style: TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 8),
            const Text(
              '点击右上角 + 添加设备',
              style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredDevices.length,
      itemBuilder: (context, index) {
        final device = _filteredDevices[index];
        return _buildDeviceCard(device);
      },
    );
  }

  Widget _buildDeviceCard(SmartDevice device) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDetailScreen(device: device),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: device.type.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      device.type.icon,
                      color: device.type.color,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    device.type.displayName,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        device.mainValue,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: device.type.color,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: device.isOnline ? const Color(0xFF52C41A) : const Color(0xFF9E9E9E),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDeviceDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0x00000000),
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '选择设备类型',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: DeviceType.values.length,
                itemBuilder: (context, index) {
                  final type = DeviceType.values[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showIpInputDialog(type);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: type.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: type.color.withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(type.icon, color: type.color, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            type.displayName,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF1A1A2E)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIpInputDialog(DeviceType type) {
    final ipController = TextEditingController();
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    ConnectionType _connectionType = ConnectionType.wifi;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('添加${type.displayName}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '设备名称',
                    hintText: '例如：我的UPS',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // 连接方式选择
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
                        child: Text('连接方式', style: TextStyle(fontSize: 12, color: Color(0xFF757575))),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<ConnectionType>(
                              title: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.wifi, size: 18),
                                  SizedBox(width: 4),
                                  Text('WiFi', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              value: ConnectionType.wifi,
                              groupValue: _connectionType,
                              onChanged: (value) => setDialogState(() => _connectionType = value!),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<ConnectionType>(
                              title: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bluetooth, size: 18),
                                  SizedBox(width: 4),
                                  Text('蓝牙', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              value: ConnectionType.bluetooth,
                              groupValue: _connectionType,
                              onChanged: (value) => setDialogState(() => _connectionType = value!),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ipController,
                  decoration: InputDecoration(
                    labelText: _connectionType == ConnectionType.wifi ? '设备IP' : '设备MAC地址',
                    hintText: _connectionType == ConnectionType.wifi
                        ? '例如：192.168.1.100'
                        : '例如：AA:BB:CC:DD:EE:FF',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '连接密码（可选）',
                    hintText: '如有密码请输入',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                final ip = ipController.text.trim();
                final name = nameController.text.trim();

                if (ip.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_connectionType == ConnectionType.wifi ? '请输入设备IP' : '请输入设备MAC地址'),
                    ),
                  );
                  return;
                }

                Navigator.pop(ctx);

                final newDevice = SmartDevice(
                  id: 'device_${DateTime.now().millisecondsSinceEpoch}',
                  name: name.isEmpty ? type.displayName : name,
                  type: type,
                  localIp: ip,
                  isOnline: true,
                  lastSeen: DateTime.now(),
                );

                setState(() {
                  _devices.add(newDevice);
                });

                // 持久化保存到本地存储
                final storageService = context.read<StorageService>();
                await storageService.saveSmartDevices(_devices);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${newDevice.name} 添加成功')),
                  );
                }
              },
              child: const Text('添加'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _remoteService.dispose();
    super.dispose();
  }
}
