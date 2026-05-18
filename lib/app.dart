import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/config/theme.dart';
import 'package:ups_monitor_app/screens/home_screen.dart';
import 'package:ups_monitor_app/services/locale_service.dart';

class UPSMonitorApp extends StatelessWidget {
  const UPSMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 设置状态栏样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        return MaterialApp(
          title: 'Marsriva UPS - Keep Life Power On',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          locale: localeService.locale,
          home: const HomeScreen(),
        );
      },
    );
  }
}
