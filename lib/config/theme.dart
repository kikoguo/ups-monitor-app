import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ==================== Marsriva 品牌配色 ====================
  
  // 主色调 - Marsriva 青绿色（用于品牌标识）
  static const Color primaryColor = Color(0xFF00B8A9);      // Marsriva青绿
  static const Color primaryLightColor = Color(0xFF00D4C2); // 亮青绿
  static const Color primaryDarkColor = Color(0xFF009688);  // 深青绿
  
  // 辅助色系（用于其他地方，更酷炫）
  static const Color cyanGlow = Color(0xFF00E5FF);          // 青色发光
  static const Color purpleAccent = Color(0xFF9C27B0);      // 紫色强调
  static const Color orangeAccent = Color(0xFFFF9800);      // 橙色强调
  static const Color pinkAccent = Color(0xFFE91E63);        // 粉色强调
  
  // 渐变色方案（酷炫效果）
  static const Color gradientStart = Color(0xFF00B8A9);     // 青绿
  static const Color gradientMid = Color(0xFF00E5FF);       // 青色
  static const Color gradientEnd = Color(0xFF7C4DFF);       // 紫色
  
  // 状态颜色
  static const Color successColor = Color(0xFF00E676);      // 翠绿 - 正常
  static const Color warningColor = Color(0xFFFFAB00);      // 琥珀色 - 警告
  static const Color errorColor = Color(0xFFFF5252);        // 红色 - 错误
  static const Color infoColor = Color(0xFF40C4FF);         // 浅蓝 - 信息
  
  // UPS状态颜色
  static const Color onlineColor = Color(0xFF00E676);       // 在线/正常（翠绿）
  static const Color offlineColor = Color(0xFF78909C);      // 离线
  static const Color batteryColor = Color(0xFF40C4FF);     // 电池供电（浅蓝）
  static const Color alertColor = Color(0xFFFF5252);        // 告警（红色）
  static const Color bypassColor = Color(0xFFCE93D8);       // 旁路模式（浅紫）
  static const Color chargingColor = Color(0xFFFFAB00);     // 充电中（琥珀）
  
  // 背景颜色（深色主题 - 科技感）
  static const Color cardBackground = Color(0xFF1E1E30);    // 深色卡片
  static const Color surfaceColor = Color(0xFF16213E);      // 深色表面
  static const Color backgroundDark = Color(0xFF0D0D1A);    // 深色背景
  static const Color backgroundPurple = Color(0xFF1A0A2E); // 紫色背景
  
  // 文字颜色
  static const Color textPrimary = Color(0xFFFFFFFF);       // 主文字白色
  static const Color textSecondary = Color(0xFFB0BEC5);    // 次要文字
  static const Color textAccent = Color(0xFF00E5FF);        // 强调文字（青色）

  // ==================== 浅色主题 ====================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: cyanGlow,
      tertiary: purpleAccent,
      surface: Colors.white,
      error: errorColor,
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F4F8),
    textTheme: GoogleFonts.notoSansTextTheme(),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: const CardThemeData(
      elevation: 4,
      color: Colors.white,
      shadowColor: Color(0x3300B8A9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF78909C),
      backgroundColor: Colors.white,
      elevation: 8,
    ),
  );

  // ==================== 深色主题（酷炫科技风） ====================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryLightColor,
      secondary: cyanGlow,
      tertiary: purpleAccent,
      surface: surfaceColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: surfaceColor,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: const CardThemeData(
      elevation: 8,
      color: cardBackground,
      shadowColor: Color(0x4D000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryLightColor,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryLightColor,
      unselectedItemColor: Colors.grey[400],
      backgroundColor: surfaceColor,
      elevation: 8,
    ),
  );

  // ==================== Marsriva 品牌渐变（用于Logo和重要元素） ====================
  static LinearGradient get brandGradient => const LinearGradient(
    colors: [primaryLightColor, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== 酷炫渐变（用于背景和装饰） ====================
  static LinearGradient get coolGradient => const LinearGradient(
    colors: [primaryColor, cyanGlow, purpleAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get bluePurpleGradient => const LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF9C27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get greenOrangeGradient => const LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get deepSpaceGradient => const LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== 发光效果颜色 ====================
  static Color getGlowColor(String type) {
    switch (type) {
      case 'success':
        return const Color(0xFF00E676);
      case 'warning':
        return const Color(0xFFFFAB00);
      case 'error':
        return const Color(0xFFFF5252);
      case 'info':
        return const Color(0xFF40C4FF);
      case 'purple':
        return const Color(0xFFE040FB);
      case 'cyan':
        return const Color(0xFF00E5FF);
      default:
        return primaryColor;
    }
  }

  // ==================== 获取状态颜色 ====================
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
      case 'normal':
        return onlineColor;
      case 'offline':
      case 'standby':
        return offlineColor;
      case 'battery':
      case 'discharging':
        return batteryColor;
      case 'charging':
        return chargingColor;
      case 'bypass':
        return bypassColor;
      case 'alert':
      case 'alarm':
      case 'overload':
        return alertColor;
      default:
        return offlineColor;
    }
  }

  // ==================== 获取状态文本 ====================
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return '市电正常';
      case 'offline':
        return '离线';
      case 'battery':
        return '电池供电';
      case 'charging':
        return '充电中';
      case 'bypass':
        return '旁路模式';
      case 'standby':
        return '待机';
      case 'overload':
        return '过载';
      case 'alarm':
        return '告警';
      case 'normal':
        return '正常';
      default:
        return '未知';
    }
  }

  // ==================== 获取状态图标 ====================
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'online':
      case 'normal':
        return Icons.check_circle;
      case 'offline':
      case 'standby':
        return Icons.power_off;
      case 'battery':
      case 'discharging':
        return Icons.battery_alert;
      case 'charging':
        return Icons.battery_charging_full;
      case 'bypass':
        return Icons.electrical_services;
      case 'alert':
      case 'alarm':
      case 'overload':
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }

  // ==================== 获取渐变颜色（用于仪表盘等） ====================
  static LinearGradient getGaugeGradient(double value) {
    if (value >= 80) {
      return const LinearGradient(colors: [Color(0xFF00E676), Color(0xFF69F0AE)]);
    } else if (value >= 50) {
      return const LinearGradient(colors: [Color(0xFF00B8A9), Color(0xFF00E5FF)]);
    } else if (value >= 20) {
      return const LinearGradient(colors: [Color(0xFFFFAB00), Color(0xFFFFD54F)]);
    } else {
      return const LinearGradient(colors: [Color(0xFFFF5252), Color(0xFFFF8A80)]);
    }
  }
}
