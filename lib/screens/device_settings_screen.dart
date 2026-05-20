import 'package:flutter/material.dart';
import '../models/smart_device.dart';
import '../models/device_type.dart';

/// 设备设置页面 - 根据设备类型显示不同的设置项
class DeviceSettingsScreen extends StatefulWidget {
  final SmartDevice device;

  const DeviceSettingsScreen({super.key, required this.device});

  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  late SmartDevice _device;
  bool _isLoading = false;

  // UPS 设置
  double _outputVoltage = 220;
  double _chargeCurrent = 10;
  bool _bypassEnabled = false;
  bool _ecoMode = false;

  // BMS 设置
  double _maxChargeVoltage = 54.6;
  double _cutoffVoltage = 42;
  double _maxChargeCurrent = 20;
  double _maxDischargeCurrent = 30;

  // 光伏设置
  double _maxPower = 5000;
  bool _gridTieEnabled = true;
  bool _antiIslanding = true;

  // 通用设置
  bool _notifications = true;
  bool _autoReconnect = true;
  int _dataInterval = 5;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_device.name} 设置',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDeviceHeader(),
                const SizedBox(height: 24),
                ..._buildTypeSpecificSettings(),
                const SizedBox(height: 24),
                _buildGeneralSettings(),
                const SizedBox(height: 32),
                _buildSaveButton(),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildDeviceHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _device.type.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _device.type.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _device.type.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_device.type.icon, color: _device.type.color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _device.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 4),
                Text(
                  _device.type.displayName,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
                ),
                const SizedBox(height: 4),
                Text(
                  'IP: ${_device.localIp ?? "未设置"}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTypeSpecificSettings() {
    switch (_device.type) {
      case DeviceType.ups:
        return _buildUpsSettings();
      case DeviceType.bms:
        return _buildBmsSettings();
      case DeviceType.solar:
        return _buildSolarSettings();
      case DeviceType.energyStorage:
        return _buildEnergyStorageSettings();
      case DeviceType.general:
      case DeviceType.smartSwitch:
      case DeviceType.smartSocket:
        return _buildGeneralDeviceSettings();
    }
  }

  List<Widget> _buildUpsSettings() {
    return [
      _buildSectionTitle('UPS 输出设置'),
      _buildSliderSetting(
        '输出电压',
        '$_outputVoltage V',
        200,
        240,
        _outputVoltage,
        (v) => setState(() => _outputVoltage = v),
      ),
      _buildSliderSetting(
        '充电电流',
        '$_chargeCurrent A',
        1,
        30,
        _chargeCurrent,
        (v) => setState(() => _chargeCurrent = v),
      ),
      _buildSwitchSetting('旁路模式', _bypassEnabled, (v) => setState(() => _bypassEnabled = v)),
      _buildSwitchSetting('ECO节能模式', _ecoMode, (v) => setState(() => _ecoMode = v)),
      _buildSectionTitle('UPS 告警设置'),
      _buildSwitchSetting('过载告警', true, (v) {}),
      _buildSwitchSetting('电池低电量告警', true, (v) {}),
      _buildSwitchSetting('输入电压异常告警', true, (v) {}),
    ];
  }

  List<Widget> _buildBmsSettings() {
    return [
      _buildSectionTitle('BMS 电池保护'),
      _buildSliderSetting(
        '最大充电电压',
        '$_maxChargeVoltage V',
        40,
        60,
        _maxChargeVoltage,
        (v) => setState(() => _maxChargeVoltage = v),
      ),
      _buildSliderSetting(
        '截止放电电压',
        '$_cutoffVoltage V',
        30,
        50,
        _cutoffVoltage,
        (v) => setState(() => _cutoffVoltage = v),
      ),
      _buildSliderSetting(
        '最大充电电流',
        '$_maxChargeCurrent A',
        5,
        50,
        _maxChargeCurrent,
        (v) => setState(() => _maxChargeCurrent = v),
      ),
      _buildSliderSetting(
        '最大放电电流',
        '$_maxDischargeCurrent A',
        5,
        100,
        _maxDischargeCurrent,
        (v) => setState(() => _maxDischargeCurrent = v),
      ),
      _buildSectionTitle('BMS 温度保护'),
      _buildSwitchSetting('过温保护', true, (v) {}),
      _buildSwitchSetting('低温充电保护', true, (v) {}),
      _buildSwitchSetting('温度均衡', true, (v) {}),
    ];
  }

  List<Widget> _buildSolarSettings() {
    return [
      _buildSectionTitle('光伏系统设置'),
      _buildSliderSetting(
        '最大输出功率',
        '${_maxPower.toInt()} W',
        1000,
        10000,
        _maxPower,
        (v) => setState(() => _maxPower = v),
      ),
      _buildSwitchSetting('并网模式', _gridTieEnabled, (v) => setState(() => _gridTieEnabled = v)),
      _buildSwitchSetting('防孤岛保护', _antiIslanding, (v) => setState(() => _antiIslanding = v)),
      _buildSectionTitle('光伏告警设置'),
      _buildSwitchSetting('绝缘故障告警', true, (v) {}),
      _buildSwitchSetting('接地故障告警', true, (v) {}),
      _buildSwitchSetting('电弧故障检测', true, (v) {}),
    ];
  }

  List<Widget> _buildEnergyStorageSettings() {
    return [
      _buildSectionTitle('储能系统设置'),
      _buildSliderSetting(
        '最大充电功率',
        '${_maxPower.toInt()} W',
        1000,
        10000,
        _maxPower,
        (v) => setState(() => _maxPower = v),
      ),
      _buildSliderSetting(
        '最大放电功率',
        '${_maxPower.toInt()} W',
        1000,
        10000,
        _maxPower,
        (v) => setState(() => _maxPower = v),
      ),
      _buildSwitchSetting('峰谷套利', true, (v) {}),
      _buildSwitchSetting('备用电源模式', true, (v) {}),
    ];
  }

  List<Widget> _buildGeneralDeviceSettings() {
    return [
      _buildSectionTitle('设备设置'),
      _buildSwitchSetting('设备开关', true, (v) {}),
      _buildSwitchSetting('定时任务', false, (v) {}),
      _buildSwitchSetting('远程控制', true, (v) {}),
    ];
  }

  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('通用设置'),
        _buildSwitchSetting('消息通知', _notifications, (v) => setState(() => _notifications = v)),
        _buildSwitchSetting('自动重连', _autoReconnect, (v) => setState(() => _autoReconnect = v)),
        _buildSliderSetting(
          '数据刷新间隔',
          '$_dataInterval 秒',
          1,
          60,
          _dataInterval.toDouble(),
          (v) => setState(() => _dataInterval = v.toInt()),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF757575)),
      ),
    );
  }

  Widget _buildSliderSetting(
    String label,
    String value,
    double min,
    double max,
    double current,
    ValueChanged<double> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E))),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4A90D9))),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: current,
            min: min,
            max: max,
            divisions: ((max - min) / (max > 100 ? 10 : 1)).toInt(),
            activeColor: const Color(0xFF4A90D9),
            inactiveColor: const Color(0xFF4A90D9).withOpacity(0.2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4A90D9),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90D9),
          foregroundColor: const Color(0xFFFFFFFF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('保存设置', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存'), backgroundColor: Color(0xFF52C41A)),
      );
    }
  }
}
