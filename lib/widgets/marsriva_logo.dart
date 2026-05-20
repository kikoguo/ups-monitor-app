import 'package:flutter/material.dart';
import 'package:ups_monitor_app/config/theme.dart';

class MarsrivaLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showTagline;

  const MarsrivaLogo({
    super.key,
    this.size = 60,
    this.showText = true,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(size / 5),
            boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Center(
            child: Icon(Icons.bolt, size: size * 0.6, color: const Color(0xFFFFFFFF)),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'MARSRIVA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryLightColor,
              letterSpacing: 3,
            ),
          ),
        ],
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            'Keep Life Power On',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB0BEC5),
              letterSpacing: 1,
            ),
          ),
        ],
      ],
    );
  }
}

class MarsrivaSplash extends StatelessWidget {
  const MarsrivaSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.deepSpaceGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MarsrivaLogo(size: 100, showText: true, showTagline: true),
              const SizedBox(height: 24),
              const Text('UPS 智能监控系统', style: TextStyle(fontSize: 16, color: Color(0xFFB0BEC5))),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: const Color(0xFF3D3D3D),
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryLightColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlowButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const GlowButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: const Color(0xFFFFFFFF),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
