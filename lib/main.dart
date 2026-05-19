import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/app.dart';
import 'package:ups_monitor_app/services/storage_service.dart';
import 'package:ups_monitor_app/services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化语言服务（不阻塞）
  final localeService = LocaleService();
  await localeService.init();
  
  // 初始化存储服务（不阻塞主线程）
  final storageService = StorageService();
  // 在后台初始化
  () async {
    await storageService.init();
  }();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<LocaleService>.value(value: localeService),
      ],
      child: const UPSMonitorApp(),
    ),
  );
}
