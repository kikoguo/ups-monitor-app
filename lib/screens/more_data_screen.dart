import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/smart_device.dart';
import '../models/device_parameters.dart';

/// 更多数据页 - 显示所有设备参数
class MoreDataScreen extends StatelessWidget {
  final SmartDevice device;

  const MoreDataScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final params = DeviceParameterConfig.getParameters(device.type.code);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A2E)),
        ),
        title: Text(
          '更多数据',
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: params.length,
        itemBuilder: (context, index) {
          final param = params[index];
          final value = device.parameters[param.key] ?? '--';
          return _buildDataCard(param, value.toString());
        },
      ),
    );
  }

  Widget _buildDataCard(DeviceParameter param, String value) {
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
                    fontSize: 22,
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
      case 'voltage':
        iconData = Icons.electrical_services;
        iconColor = const Color(0xFF4A90D9);
        break;
      case 'current':
        iconData = Icons.electric_bolt;
        iconColor = const Color(0xFFFAAD14);
        break;
      case 'power':
        iconData = Icons.offline_bolt;
        iconColor = const Color(0xFFFF4D4F);
        break;
      case 'temperature':
        iconData = Icons.thermostat;
        iconColor = const Color(0xFFFA8C16);
        break;
      case 'solar':
        iconData = Icons.wb_sunny;
        iconColor = const Color(0xFFFADB14);
        break;
      case 'health':
        iconData = Icons.favorite;
        iconColor = const Color(0xFF52C41A);
        break;
      case 'cycle':
        iconData = Icons.sync;
        iconColor = const Color(0xFF722ED1);
        break;
      case 'humidity':
        iconData = Icons.water_drop;
        iconColor = const Color(0xFF1890FF);
        break;
      case 'frequency':
        iconData = Icons.speed;
        iconColor = const Color(0xFF13C2C2);
        break;
      default:
        iconData = Icons.speed;
        iconColor = const Color(0xFF4A90D9);
    }
    return Icon(iconData, color: iconColor, size: 24);
  }
}
