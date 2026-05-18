import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 语言状态管理
class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  Locale _locale = const Locale('en');
  bool _initialized = false;

  Locale get locale => _locale;
  bool get initialized => _initialized;

  /// 获取语言名称
  String get languageName {
    switch (_locale.languageCode) {
      case 'zh':
        return '中文';
      case 'es':
        return 'Español';
      case 'ja':
        return '日本語';
      default:
        return 'English';
    }
  }

  /// 初始化语言设置
  Future<void> init() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);
    
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
    
    _initialized = true;
    notifyListeners();
  }

  /// 切换语言
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    
    notifyListeners();
  }

  /// 获取翻译文本
  String t(String key) {
    return AppTranslations.get(key, _locale.languageCode);
  }
}

/// 应用翻译文本
class AppTranslations {
  static final Map<String, Map<String, String>> _translations = {
    // 首页
    'Dashboard': {'en': 'Dashboard', 'zh': '仪表板', 'es': 'Panel', 'ja': 'ダッシュボード'},
    'Events': {'en': 'Events', 'zh': '事件', 'es': 'Eventos', 'ja': 'イベント'},
    'Settings': {'en': 'Settings', 'zh': '设置', 'es': 'Ajustes', 'ja': '設定'},
    'My Devices': {'en': 'My Devices', 'zh': '我的设备', 'es': 'Mis Dispositivos', 'ja': 'マイデバイス'},
    'Device(s) Online': {'en': 'Device(s) Online', 'zh': '设备在线', 'es': 'Dispositivo(s) en línea', 'ja': 'デバイスオンライン'},
    'Battery': {'en': 'Battery', 'zh': '电池', 'es': 'Batería', 'ja': 'バッテリー'},
    'Load': {'en': 'Load', 'zh': '负载', 'es': 'Carga', 'ja': '負荷'},
    'Online': {'en': 'Online', 'zh': '在线', 'es': 'En línea', 'ja': 'オンライン'},
    'Offline': {'en': 'Offline', 'zh': '离线', 'es': 'Sin conexión', 'ja': 'オフライン'},
    'MARSRIVA': {'en': 'MARSRIVA', 'zh': 'MARSRIVA', 'es': 'MARSRIVA', 'ja': 'MARSRIVA'},
    'Keep Life Power On': {'en': 'Keep Life Power On', 'zh': '让生活永不断电', 'es': 'Mantén la Vida Encendida', 'ja': '生活に電力を'},
    'devices': {'en': 'devices', 'zh': '设备', 'es': 'dispositivos', 'ja': 'デバイス'},
    
    // 添加设备
    'Add Device': {'en': 'Add Device', 'zh': '添加设备', 'es': 'Agregar Dispositivo', 'ja': 'デバイスを追加'},
    'Device Name': {'en': 'Device Name', 'zh': '设备名称', 'es': 'Nombre del Dispositivo', 'ja': 'デバイス名'},
    'IP Address': {'en': 'IP Address', 'zh': 'IP地址', 'es': 'Dirección IP', 'ja': 'IPアドレス'},
    'Device Status': {'en': 'Device Status', 'zh': '设备状态', 'es': 'Estado del Dispositivo', 'ja': 'デバイス状態'},
    'Cancel': {'en': 'Cancel', 'zh': '取消', 'es': 'Cancelar', 'ja': 'キャンセル'},
    'Add': {'en': 'Add', 'zh': '添加', 'es': 'Agregar', 'ja': '追加'},
    'Device added successfully': {'en': 'Device added successfully', 'zh': '设备添加成功', 'es': 'Dispositivo agregado exitosamente', 'ja': 'デバイスが正常に追加されました'},
    'Please fill in all fields': {'en': 'Please fill in all fields', 'zh': '请填写所有字段', 'es': 'Por favor complete todos los campos', 'ja': 'すべてのフィールドに入力してください'},
    'Invalid IP address format': {'en': 'Invalid IP address format', 'zh': 'IP地址格式无效', 'es': 'Formato de dirección IP inválido', 'ja': 'IPアドレスの形式が無効です'},
    
    // 设置页面
    'Language': {'en': 'Language', 'zh': '语言', 'es': 'Idioma', 'ja': '言語'},
    'Notifications': {'en': 'Notifications', 'zh': '通知', 'es': 'Notificaciones', 'ja': '通知'},
    'WiFi Settings': {'en': 'WiFi Settings', 'zh': 'WiFi设置', 'es': 'Configuración WiFi', 'ja': 'WiFi設定'},
    'Firmware Update': {'en': 'Firmware Update', 'zh': '固件更新', 'es': 'Actualización de Firmware', 'ja': 'ファームウェア更新'},
    'About': {'en': 'About', 'zh': '关于', 'es': 'Acerca de', 'ja': 'バージョン情報'},
    'Enabled': {'en': 'Enabled', 'zh': '已启用', 'es': 'Activado', 'ja': '有効'},
    'Connected': {'en': 'Connected', 'zh': '已连接', 'es': 'Conectado', 'ja': '接続済み'},
    'Check for updates': {'en': 'Check for updates', 'zh': '检查更新', 'es': 'Buscar actualizaciones', 'ja': '更新を確認'},
    'Version 1.0.0': {'en': 'Version 1.0.0', 'zh': '版本 1.0.0', 'es': 'Versión 1.0.0', 'ja': 'バージョン 1.0.0'},
    'Language changed': {'en': 'Language changed', 'zh': '语言已切换', 'es': 'Idioma cambiado', 'ja': '言語が変更されました'},
    'Language changed to': {'en': 'Language changed to', 'zh': '语言已切换为', 'es': 'Idioma cambiado a', 'ja': '言語が次に変更されました'},
    'Confirm': {'en': 'Confirm', 'zh': '确认', 'es': 'Confirmar', 'ja': '確認'},
    'Close': {'en': 'Close', 'zh': '关闭', 'es': 'Cerrar', 'ja': '閉じる'},
    'Save': {'en': 'Save', 'zh': '保存', 'es': 'Guardar', 'ja': '保存'},
    
    // 通知设置
    'Enable Notifications': {'en': 'Enable Notifications', 'zh': '启用通知', 'es': 'Habilitar Notificaciones', 'ja': '通知を有効にする'},
    'Email Alerts': {'en': 'Email Alerts', 'zh': '邮件提醒', 'es': 'Alertas por Correo', 'ja': 'メールアラート'},
    'Push Notifications': {'en': 'Push Notifications', 'zh': '推送通知', 'es': 'Notificaciones Push', 'ja': 'プッシュ通知'},
    'Notification settings saved': {'en': 'Notification settings saved', 'zh': '通知设置已保存', 'es': 'Configuración de notificaciones guardada', 'ja': '通知設定が保存されました'},
    
    // WiFi设置
    'Signal Strength': {'en': 'Signal Strength', 'zh': '信号强度', 'es': 'Intensidad de Señal', 'ja': '信号強度'},
    'Excellent': {'en': 'Excellent', 'zh': '优秀', 'es': 'Excelente', 'ja': '優秀'},
    'Searching for networks': {'en': 'Searching for networks...', 'zh': '正在搜索网络...', 'es': 'Buscando redes...', 'ja': 'ネットワークを検索中...'},
    'Refresh': {'en': 'Refresh', 'zh': '刷新', 'es': 'Actualizar', 'ja': '更新'},
    
    // 固件更新
    'You are up to date!': {'en': 'You are up to date!', 'zh': '已是最新版本！', 'es': '¡Estás actualizado!', 'ja': '最新の状態です！'},
    'Current version': {'en': 'Current version', 'zh': '当前版本', 'es': 'Versión actual', 'ja': '現在のバージョン'},
    
    // 关于页面
    'UPS Monitor App': {'en': 'UPS Monitor App', 'zh': 'UPS监控应用', 'es': 'App Monitor UPS', 'ja': 'UPSモニターアプリ'},
    'MARSRIVA Technology': {'en': 'MARSRIVA Technology', 'zh': 'MARSRIVA科技', 'es': 'MARSRIVA Tecnología', 'ja': 'MARSRIVAテクノロジー'},
    
    // 事件日志
    'Event Log': {'en': 'Event Log', 'zh': '事件日志', 'es': 'Registro de Eventos', 'ja': 'イベントログ'},
    'Power restored': {'en': 'Power restored', 'zh': '电力恢复', 'es': 'Energía restaurada', 'ja': '電力回復'},
    'Battery test completed': {'en': 'Battery test completed', 'zh': '电池测试完成', 'es': 'Prueba de batería completada', 'ja': 'バッテリー試験完了'},
    'Load exceeded': {'en': 'Load exceeded', 'zh': '负载超出', 'es': 'Carga excedida', 'ja': '負荷超過'},
    'Firmware updated': {'en': 'Firmware updated', 'zh': '固件已更新', 'es': 'Firmware actualizado', 'ja': 'ファームウェア更新済み'},
    'UPS restarted': {'en': 'UPS restarted', 'zh': 'UPS已重启', 'es': 'UPS reiniciado', 'ja': 'UPS再起動済み'},
    
    // 监控页面
    'Quick Actions': {'en': 'Quick Actions', 'zh': '快捷操作', 'es': 'Acciones Rápidas', 'ja': 'クイックアクション'},
    'Self-Test': {'en': 'Self-Test', 'zh': '自检', 'es': 'Autoprueba', 'ja': '自己診断'},
    'Buzzer': {'en': 'Buzzer', 'zh': '蜂鸣器', 'es': 'Zumbador', 'ja': 'ブザー'},
    'Buzzer ON': {'en': 'Buzzer ON', 'zh': '蜂鸣器开', 'es': 'Zumbador Activado', 'ja': 'ブザーオン'},
    'Buzzer OFF': {'en': 'Buzzer OFF', 'zh': '蜂鸣器关', 'es': 'Zumbador Desactivado', 'ja': 'ブザーオフ'},
    'Control Panel': {'en': 'Control Panel', 'zh': '控制面板', 'es': 'Panel de Control', 'ja': 'コントロールパネル'},
    'Testing...': {'en': 'Testing...', 'zh': '测试中...', 'es': 'Probando...', 'ja': 'テスト中...'},
    'Data refreshed': {'en': 'Data refreshed', 'zh': '数据已刷新', 'es': 'Datos actualizados', 'ja': 'データが更新されました'},
    'Self-test started': {'en': 'Self-test started', 'zh': '自检已开始', 'es': 'Autoprueba iniciada', 'ja': '自己診断が開始されました'},
    'Buzzer toggled': {'en': 'Buzzer toggled', 'zh': '蜂鸣器已切换', 'es': 'Zumbador alternado', 'ja': 'ブザーが切り替えられました'},
    'Recent Events': {'en': 'Recent Events', 'zh': '最近事件', 'es': 'Eventos Recientes', 'ja': '最近のイベント'},
    'View All': {'en': 'View All', 'zh': '查看全部', 'es': 'Ver Todo', 'ja': 'すべて表示'},
    'Viewing all events': {'en': 'Viewing all events', 'zh': '查看所有事件', 'es': 'Viendo todos los eventos', 'ja': 'すべてのイベントを表示'},
    'Voltage & Frequency': {'en': 'Voltage & Frequency', 'zh': '电压和频率', 'es': 'Voltaje y Frecuencia', 'ja': '電圧と周波数'},
    'Battery Capacity': {'en': 'Battery Capacity', 'zh': '电池容量', 'es': 'Capacidad de Batería', 'ja': 'バッテリー容量'},
    'Temperature': {'en': 'Temperature', 'zh': '温度', 'es': 'Temperatura', 'ja': '温度'},
    'Load Status': {'en': 'Load Status', 'zh': '负载状态', 'es': 'Estado de Carga', 'ja': '負荷状態'},
    'AC Input': {'en': 'AC Input', 'zh': '交流输入', 'es': 'Entrada AC', 'ja': '交流入力'},
    'Input': {'en': 'Input', 'zh': '输入', 'es': 'Entrada', 'ja': '入力'},
    'Output': {'en': 'Output', 'zh': '输出', 'es': 'Salida', 'ja': '出力'},
    'Backup': {'en': 'Backup', 'zh': '备用时间', 'es': 'Respaldo', 'ja': 'バックアップ'},
    
    // 控制面板
    'Shutdown': {'en': 'Shutdown', 'zh': '关机', 'es': 'Apagar', 'ja': 'シャットダウン'},
    'Restart': {'en': 'Restart', 'zh': '重启', 'es': 'Reiniciar', 'ja': '再起動'},
    'Bypass': {'en': 'Bypass', 'zh': '旁路', 'es': 'Bypass', 'ja': 'バイパス'},
    'Mute': {'en': 'Mute', 'zh': '静音', 'es': 'Silenciar', 'ja': 'ミュート'},
    'Unmute': {'en': 'Unmute', 'zh': '取消静音', 'es': 'Activar sonido', 'ja': 'ミュート解除'},
    'Are you sure you want to': {'en': 'Are you sure you want to', 'zh': '确定要', 'es': '¿Está seguro de que desea', 'ja': '本当に'},
    
    // 成功/错误消息
    'Self-test started successfully': {'en': 'Self-test started successfully', 'zh': '自检启动成功', 'es': 'Autoprueba iniciada exitosamente', 'ja': '自己診断が正常に開始されました'},
    'Self-test failed': {'en': 'Self-test failed', 'zh': '自检失败', 'es': 'Autoprueba fallida', 'ja': '自己診断に失敗しました'},
    'Self-test request failed': {'en': 'Self-test request failed', 'zh': '自检请求失败', 'es': 'Solicitud de autoprueba fallida', 'ja': '自己診断リクエストに失敗しました'},
    'Buzzer enabled': {'en': 'Buzzer enabled', 'zh': '蜂鸣器已开启', 'es': 'Zumbador activado', 'ja': 'ブザーが有効になりました'},
    'Buzzer disabled': {'en': 'Buzzer disabled', 'zh': '蜂鸣器已关闭', 'es': 'Zumbador desactivado', 'ja': 'ブザーが無効になりました'},
    'Failed to toggle buzzer': {'en': 'Failed to toggle buzzer', 'zh': '切换蜂鸣器失败', 'es': 'Error al alternar zumbador', 'ja': 'ブザーの切り替えに失敗しました'},
    'Buzzer toggle failed': {'en': 'Buzzer toggle failed', 'zh': '蜂鸣器切换失败', 'es': 'Error al alternar zumbador', 'ja': 'ブザーの切り替えに失敗しました'},
    'command sent successfully': {'en': 'command sent successfully', 'zh': '命令发送成功', 'es': 'comando enviado exitosamente', 'ja': 'コマンドが正常に送信されました'},
    'command failed': {'en': 'command failed', 'zh': '命令发送失败', 'es': 'comando fallido', 'ja': 'コマンドが失敗しました'},
    'Request failed': {'en': 'Request failed', 'zh': '请求失败', 'es': 'Solicitud fallida', 'ja': 'リクエスト失敗'},
    
    // 控制面板页面
    'Control Panel': {'en': 'Control Panel', 'zh': '控制面板', 'es': 'Panel de Control', 'ja': 'コントロールパネル'},
    'Sending command...': {'en': 'Sending command...', 'zh': '正在发送命令...', 'es': 'Enviando comando...', 'ja': 'コマンド送信中...'},
    'Control Operations': {'en': 'Control Operations', 'zh': '控制操作', 'es': 'Operaciones de Control', 'ja': '制御操作'},
    'Alarm Control': {'en': 'Alarm Control', 'zh': '告警控制', 'es': 'Control de Alarmas', 'ja': 'アラーム制御'},
    'Control command may take a few seconds to take effect, please be patient.': {'en': 'Control command may take a few seconds to take effect, please be patient.', 'zh': '控制命令可能需要几秒钟才能生效，请耐心等待。', 'es': 'El comando de control puede tardar unos segundos en tener efecto, por favor espere.', 'ja': '制御コマンドが有効になるまで数秒かかる場合があります。しばらくお待ちください。'},
    'Confirm shutdown?': {'en': 'Confirm shutdown?', 'zh': '确定要关闭UPS吗？这将使连接的设备断电。', 'es': '¿Está seguro de que desea apagar el UPS? Esto desconectará los dispositivos conectados.', 'ja': 'UPSをシャットダウンしますか？接続されている機器の電源が切れます。'},
    'Confirm restart?': {'en': 'Confirm restart?', 'zh': '确定要重启UPS吗？这将短暂中断供电。', 'es': '¿Está seguro de que desea reiniciar el UPS? Esto interrumpirá brevemente el suministro de energía.', 'ja': 'UPSを再起動しますか？一時的に電力供給が中断されます。'},
    'Confirm self-test?': {'en': 'Confirm self-test?', 'zh': '确定要对UPS进行自检吗？', 'es': '¿Está seguro de que desea realizar una autoprueba del UPS?', 'ja': 'UPSの自己診断を実行しますか？'},
    'Confirm bypass?': {'en': 'Confirm bypass?', 'zh': '确定要切换到旁路模式吗？', 'es': '¿Está seguro de que desea cambiar al modo bypass?', 'ja': 'バイパスモードに切り替えますか？'},
    'Shutdown': {'en': 'Shutdown', 'zh': '关机', 'es': 'Apagar', 'ja': 'シャットダウン'},
    'Shutdown success': {'en': 'Shutdown success', 'zh': '关机成功', 'es': 'Apagado exitoso', 'ja': 'シャットダウン成功'},
    'Shutdown failed': {'en': 'Shutdown failed', 'zh': '关机失败', 'es': 'Apagado fallido', 'ja': 'シャットダウン失敗'},
    'Restart': {'en': 'Restart', 'zh': '重启', 'es': 'Reiniciar', 'ja': '再起動'},
    'Restart success': {'en': 'Restart success', 'zh': '重启成功', 'es': 'Reinicio exitoso', 'ja': '再起動成功'},
    'Restart failed': {'en': 'Restart failed', 'zh': '重启失败', 'es': 'Reinicio fallido', 'ja': '再起動失敗'},
    'Self-Test': {'en': 'Self-Test', 'zh': '自检', 'es': 'Autoprueba', 'ja': '自己診断'},
    'Self-Test success': {'en': 'Self-Test success', 'zh': '自检成功', 'es': 'Autoprueba exitosa', 'ja': '自己診断成功'},
    'Self-Test failed': {'en': 'Self-Test failed', 'zh': '自检失败', 'es': 'Autoprueba fallida', 'ja': '自己診断失敗'},
    'Bypass Mode': {'en': 'Bypass Mode', 'zh': '旁路模式', 'es': 'Modo Bypass', 'ja': 'バイパスモード'},
    'Bypass success': {'en': 'Bypass success', 'zh': '切换旁路成功', 'es': 'Bypass exitoso', 'ja': 'バイパス成功'},
    'Bypass failed': {'en': 'Bypass failed', 'zh': '切换旁路失败', 'es': 'Bypass fallido', 'ja': 'バイパス失敗'},
    'Mute': {'en': 'Mute', 'zh': '静音', 'es': 'Silenciar', 'ja': 'ミュート'},
    'Unmute': {'en': 'Unmute', 'zh': '取消静音', 'es': 'Activar sonido', 'ja': 'ミュート解除'},
    'Mute success': {'en': 'Mute success', 'zh': '静音成功', 'es': 'Silenciar exitoso', 'ja': 'ミュート成功'},
    'Mute failed': {'en': 'Mute failed', 'zh': '静音失败', 'es': 'Silenciar fallido', 'ja': 'ミュート失敗'},
    'Unmute success': {'en': 'Unmute success', 'zh': '取消静音成功', 'es': 'Activar sonido exitoso', 'ja': 'ミュート解除成功'},
    'Unmute failed': {'en': 'Unmute failed', 'zh': '取消静音失败', 'es': 'Activar sonido fallido', 'ja': 'ミュート解除失敗'},
    'Operation failed': {'en': 'Operation failed', 'zh': '操作失败', 'es': 'Operación fallida', 'ja': '操作失敗'},
    'Command sent': {'en': 'Command sent', 'zh': '命令已发送', 'es': 'Comando enviado', 'ja': 'コマンド送信済み'},
    'Cancel': {'en': 'Cancel', 'zh': '取消', 'es': 'Cancelar', 'ja': 'キャンセル'},
    'Confirm': {'en': 'Confirm', 'zh': '确定', 'es': 'Confirmar', 'ja': '確認'},
  };

  static String get(String key, String languageCode) {
    if (_translations.containsKey(key)) {
      return _translations[key]![languageCode] ?? _translations[key]!['en']!;
    }
    return key;
  }
}
