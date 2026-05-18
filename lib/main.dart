import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ups_monitor_app/app.dart';
import 'package:ups_monitor_app/services/network_service.dart';
import 'package:ups_monitor_app/services/storage_service.dart';
import 'package:ups_monitor_app/services/discovery_service.dart';
import 'package:ups_monitor_app/services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化服务
  final storageService = StorageService();
  await storageService.init();
  
  // 初始化语言服务
  final localeService = LocaleService();
  await localeService.init();
  
  final networkService = NetworkService();
  final discoveryService = DiscoveryService();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<NetworkService>.value(value: networkService),
        Provider<DiscoveryService>.value(value: discoveryService),
        ChangeNotifierProvider<LocaleService>.value(value: localeService),
      ],
      child: const UPSMonitorApp(),
    ),
  );
}
