/**
 * UPS WiFi Server - BL602 (Ai-WB2-12F) 固件
 * 功能：读取UPS数据并通过HTTP接口提供
 * 作者：Auto Generated
 * 版本：2.0.0 (BL602版本)
 * 
 * 适配模块：安信可 Ai-WB2-12F
 * 芯片：BL602 (RISC-V架构)
 */

#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>

// ==================== WiFi配置 ====================
// 修改这里为你的WiFi信息
const char* ssid = "你的WiFi名称";
const char* password = "你的WiFi密码";

// ==================== BL602引脚定义 ====================
// BL602引脚映射
// 注意：不同开发板引脚定义可能不同，请根据实际情况修改
// GPIO编号（不是物理引脚号）

// 板载LED (通常是GPIO22，但可能不同)
#ifndef LED_BUILTIN
#define LED_BUILTIN 22
#endif

// 自定义GPIO引脚定义
const int LED_BLUE = LED_BUILTIN;   // 蓝色LED（板载）
const int LED_GREEN = 21;           // 绿色LED
const int LED_RED = 23;            // 红色LED

// 串口引脚（UART0默认使用GPIO1/GPIO0，用于USB通信）
// 如需SoftwareSerial，使用以下引脚
const int UPS_RX_PIN = 10;          // 连接UPS的TX
const int UPS_TX_PIN = 11;         // 连接UPS的RX

// ==================== 全局变量 ====================
WebServer server(80);

// UPS状态结构
struct UPSStatus {
  float voltage;           // 输出电压 (V)
  float current;           // 输出电流 (A)
  int power;               // 输出功率 (W)
  int battery;             // 电池电量 (%)
  float inputVoltage;      // 输入电压 (V)
  String outputStatus;     // 输出状态
  String upsMode;          // UPS模式
  int loadPercent;         // 负载百分比 (%)
  float temperature;        // 温度 (℃)
  int runtimeRemaining;    // 剩余运行时间 (秒)
  unsigned long timestamp; // 时间戳
};

// 当前UPS状态
UPSStatus currentStatus = {
  220.0, 0.0, 0, 100,
  220.0, "normal", "online",
  0, 25.0, 0, 0
};

// 启动时间
unsigned long startTime;

// WiFi连接状态
bool wifiConnected = false;

// ==================== 函数声明 ====================
void handleStatus();
void handleControl();
void handleInfo();
void handleHealth();
void handleLED();
void handleNotFound();
void readUPSData();
void sendUPSCommand(String command);
void updateLED();
String getStatusString();
void initHardware();
void blinkLED(int pin, int times, int delayMs);

// ==================== 初始化 ====================
void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.println("=================================");
  Serial.println("  UPS WiFi Server - BL602 v2.0");
  Serial.println("  适配模块: Ai-WB2-12F");
  Serial.println("=================================");
  
  // 初始化硬件
  initHardware();
  
  // 连接WiFi
  connectWiFi();
  
  // 配置HTTP路由
  server.on("/status", HTTP_GET, handleStatus);
  server.on("/control", HTTP_POST, handleControl);
  server.on("/info", HTTP_GET, handleInfo);
  server.on("/health", HTTP_GET, handleHealth);
  server.on("/led", HTTP_GET, handleLED);
  server.onNotFound(handleNotFound);
  
  server.begin();
  Serial.println("HTTP服务器已启动");
  Serial.println("=================================");
  
  // 记录启动时间
  startTime = millis();
  
  // 初始化时读取一次UPS数据
  readUPSData();
  
  // 启动成功指示
  blinkLED(LED_GREEN, 3, 200);
}

// ==================== 硬件初始化 ====================
void initHardware() {
  Serial.println("初始化硬件...");
  
  // 初始化LED引脚
  pinMode(LED_BLUE, OUTPUT);
  pinMode(LED_GREEN, OUTPUT);
  pinMode(LED_RED, OUTPUT);
  
  // 关闭所有LED
  digitalWrite(LED_BLUE, HIGH);
  digitalWrite(LED_GREEN, HIGH);
  digitalWrite(LED_RED, HIGH);
  
  // 初始化串口（用于调试）
  Serial.println("硬件初始化完成");
  
  // 蓝色LED闪烁表示正在启动
  blinkLED(LED_BLUE, 5, 100);
}

// ==================== WiFi连接 ====================
void connectWiFi() {
  Serial.println();
  Serial.print("正在连接WiFi: ");
  Serial.println(ssid);
  
  // 显示连接过程
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  
  // 等待连接
  int attempts = 0;
  int maxAttempts = 30;
  
  while (WiFi.status() != WL_CONNECTED && attempts < maxAttempts) {
    delay(500);
    Serial.print(".");
    
    // 蓝色LED闪烁表示正在连接
    digitalWrite(LED_BLUE, !digitalRead(LED_BLUE));
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    wifiConnected = true;
    Serial.println();
    Serial.println("=================================");
    Serial.println("WiFi已连接!");
    Serial.print("IP地址: ");
    Serial.println(WiFi.localIP());
    Serial.print("信号强度: ");
    Serial.print(WiFi.RSSI());
    Serial.println(" dBm");
    Serial.println("=================================");
    
    // 绿色LED亮起表示连接成功
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_BLUE, HIGH);
  } else {
    wifiConnected = false;
    Serial.println();
    Serial.println("WiFi连接失败!请检查SSID和密码");
    
    // 红色LED亮起表示连接失败
    digitalWrite(LED_RED, LOW);
    
    // 尝试重启WiFi模块
    Serial.println("尝试重新连接...");
    WiFi.disconnect();
    delay(1000);
    WiFi.begin(ssid, password);
  }
}

// ==================== 主循环 ====================
void loop() {
  server.handleClient();
  
  // 每5秒读取一次UPS数据
  static unsigned long lastRead = 0;
  if (millis() - lastRead > 5000) {
    readUPSData();
    lastRead = millis();
  }
  
  // 检查WiFi连接状态
  static unsigned long lastWifiCheck = 0;
  if (millis() - lastWifiCheck > 10000) {
    if (WiFi.status() != WL_CONNECTED) {
      Serial.println("WiFi连接丢失，尝试重新连接...");
      wifiConnected = false;
      digitalWrite(LED_GREEN, HIGH);
      digitalWrite(LED_BLUE, LOW);
      connectWiFi();
    }
    lastWifiCheck = millis();
  }
  
  // LED状态更新
  updateLED();
}

// ==================== HTTP处理器 ====================

// 获取UPS状态
void handleStatus() {
  StaticJsonDocument<512> doc;
  
  doc["success"] = true;
  doc["data"]["voltage"] = currentStatus.voltage;
  doc["data"]["current"] = currentStatus.current;
  doc["data"]["power"] = currentStatus.power;
  doc["data"]["battery"] = currentStatus.battery;
  doc["data"]["input_voltage"] = currentStatus.inputVoltage;
  doc["data"]["output_status"] = currentStatus.outputStatus;
  doc["data"]["ups_mode"] = currentStatus.upsMode;
  doc["data"]["load_percent"] = currentStatus.loadPercent;
  doc["data"]["temperature"] = currentStatus.temperature;
  doc["data"]["runtime_remaining"] = currentStatus.runtimeRemaining;
  doc["data"]["timestamp"] = currentStatus.timestamp;
  
  String response;
  serializeJson(doc, response);
  
  server.send(200, "application/json", response);
  Serial.println("[API] 状态请求已处理");
}

// 控制UPS
void handleControl() {
  if (!server.hasArg("plain")) {
    server.send(400, "application/json", "{\"success\":false,\"error\":\"无效的请求\"}");
    return;
  }
  
  StaticJsonDocument<256> doc;
  DeserializationError error = deserializeJson(doc, server.arg("plain"));
  
  if (error) {
    server.send(400, "application/json", "{\"success\":false,\"error\":\"JSON解析失败\"}");
    return;
  }
  
  String command = doc["command"].as<String>();
  
  Serial.print("[API] 收到控制命令: ");
  Serial.println(command);
  
  // 闪烁LED表示收到命令
  blinkLED(LED_GREEN, 2, 100);
  
  // 向UPS发送命令
  sendUPSCommand(command);
  
  // 响应
  StaticJsonDocument<256> response;
  response["success"] = true;
  response["message"] = "命令已发送";
  response["command"] = command;
  
  String jsonResponse;
  serializeJson(response, jsonResponse);
  
  server.send(200, "application/json", jsonResponse);
}

// 获取设备信息
void handleInfo() {
  StaticJsonDocument<512> doc;
  
  doc["success"] = true;
  doc["data"]["model"] = "UPS-WiFi-BL602";
  doc["data"]["firmware"] = "2.0.0";
  doc["data"]["module"] = "Ai-WB2-12F";
  doc["data"]["chip"] = "BL602";
  doc["data"]["wifi_rssi"] = WiFi.RSSI();
  doc["data"]["wifi_ssid"] = WiFi.SSID();
  doc["data"]["ip_address"] = WiFi.localIP().toString();
  
  // BL602芯片信息
  doc["data"]["cpu_freq"] = 120;  // BL602默认120MHz
  doc["data"]["chip_id"] = 0;     // BL602获取方式不同，如需可添加
  
  unsigned long uptime = (millis() - startTime) / 1000;
  doc["data"]["uptime_seconds"] = uptime;
  
  // 计算运行时间字符串
  int hours = uptime / 3600;
  int minutes = (uptime % 3600) / 60;
  int seconds = uptime % 60;
  char uptimeStr[20];
  sprintf(uptimeStr, "%02d:%02d:%02d", hours, minutes, seconds);
  doc["data"]["uptime_string"] = uptimeStr;
  
  String response;
  serializeJson(doc, response);
  
  server.send(200, "application/json", response);
}

// 健康检查
void handleHealth() {
  StaticJsonDocument<256> doc;
  
  unsigned long uptime = (millis() - startTime) / 1000;
  
  doc["success"] = true;
  doc["uptime"] = uptime;
  doc["wifi_rssi"] = WiFi.RSSI();
  doc["wifi_quality"] = WiFi.status() == WL_CONNECTED ? "good" : "disconnected";
  doc["cpu_freq"] = 120;
  doc["uptime"] = uptime;
  
  String response;
  serializeJson(doc, response);
  
  server.send(200, "application/json", response);
}

// LED控制
void handleLED() {
  if (server.hasArg("color") && server.hasArg("state")) {
    String color = server.arg("color");
    String state = server.arg("state");
    bool on = (state == "on");
    
    int pin = 0;
    if (color == "blue") {
      pin = LED_BLUE;
    } else if (color == "green") {
      pin = LED_GREEN;
    } else if (color == "red") {
      pin = LED_RED;
    }
    
    if (pin > 0) {
      digitalWrite(pin, on ? LOW : HIGH);
      server.send(200, "application/json", "{\"success\":true}");
    } else {
      server.send(400, "application/json", "{\"success\":false,\"error\":\"无效的颜色\"}");
    }
  } else {
    server.send(400, "application/json", "{\"success\":false,\"error\":\"缺少参数\"}");
  }
}

// 404处理
void handleNotFound() {
  server.send(404, "application/json", "{\"error\":\"未找到\",\"path\":\""
               + server.uri() + "\"}");
}

// ==================== UPS通信函数 ====================

// 读取UPS数据
void readUPSData() {
  Serial.println("[UPS] 读取数据...");
  
  // 这里需要根据实际UPS的通信协议来实现
  // 下面提供一个模拟数据的示例，实际使用时替换为真实的UPS通信
  
  // 示例：使用模拟数据用于测试
  // 实际使用时，请根据你的UPS通信协议进行修改
  static int simulatedBattery = 85;
  static int simulatedLoad = 45;
  
  currentStatus.voltage = 218.5 + random(-50, 50) / 10.0;
  currentStatus.current = 2.3 + random(-20, 20) / 10.0;
  currentStatus.power = (int)(currentStatus.voltage * currentStatus.current);
  currentStatus.battery = simulatedBattery;
  currentStatus.inputVoltage = 220.0 + random(-30, 30) / 10.0;
  currentStatus.outputStatus = "normal";
  currentStatus.upsMode = "online";
  currentStatus.loadPercent = simulatedLoad;
  currentStatus.temperature = 32.0 + random(0, 80) / 10.0;
  currentStatus.runtimeRemaining = simulatedBattery * 20;
  currentStatus.timestamp = millis() / 1000;
  
  Serial.println("[UPS] 数据更新成功（模拟数据）");
  
  // 更新状态指示
  updateUPSStatus();
}

// 向UPS发送控制命令
void sendUPSCommand(String command) {
  String upsCommand = "";
  
  if (command == "shutdown") {
    // 关闭UPS（电池模式关机）
    upsCommand = "S00\r";
    Serial.println("[UPS] 发送关机命令");
  } else if (command == "restart") {
    // 重启UPS
    upsCommand = "R\r";
    Serial.println("[UPS] 发送重启命令");
  } else if (command == "test") {
    // 自检
    upsCommand = "T\r";
    Serial.println("[UPS] 发送自检命令");
  } else if (command == "bypass") {
    // 旁路模式
    upsCommand = "Q\r";
    Serial.println("[UPS] 发送旁路模式命令");
  } else if (command == "beep_on") {
    // 开启蜂鸣器
    upsCommand = "L1\r";
    Serial.println("[UPS] 开启蜂鸣器");
  } else if (command == "beep_off") {
    // 关闭蜂鸣器
    upsCommand = "L0\r";
    Serial.println("[UPS] 关闭蜂鸣器");
  } else {
    Serial.print("[UPS] 未知命令: ");
    Serial.println(command);
    return;
  }
  
  // 如果有硬件串口连接UPS，在这里发送命令
  // Serial1.print(upsCommand);  // 使用Serial1或其他UART
  Serial.print("[UPS] 已发送命令: ");
  Serial.println(upsCommand);
}

// 更新UPS状态
void updateUPSStatus() {
  // 根据UPS状态更新LED
  
  if (currentStatus.outputStatus == "normal" && currentStatus.upsMode == "online") {
    // 正常状态：绿色LED亮
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_RED, HIGH);
  } else if (currentStatus.battery < 20) {
    // 电池电量低：红色LED亮
    digitalWrite(LED_GREEN, HIGH);
    digitalWrite(LED_RED, LOW);
  } else if (currentStatus.upsMode == "battery") {
    // 电池供电：黄色LED（红+绿）
    digitalWrite(LED_GREEN, LOW);
    digitalWrite(LED_RED, LOW);
  }
}

// 获取状态描述字符串
String getStatusString() {
  if (currentStatus.upsMode == "online") {
    if (currentStatus.outputStatus == "normal") {
      return "市电正常";
    } else if (currentStatus.outputStatus == "overload") {
      return "过载";
    }
  } else if (currentStatus.upsMode == "battery") {
    return "电池供电";
  } else if (currentStatus.upsMode == "bypass") {
    return "旁路模式";
  } else if (currentStatus.upsMode == "standby") {
    return "待机";
  }
  
  return "未知状态";
}

// LED更新（用于状态指示）
void updateLED() {
  // 基础LED控制逻辑
  // 在主循环中调用，用于各种状态指示
  
  // WiFi断开时蓝色LED闪烁
  if (!wifiConnected) {
    static unsigned long lastBlink = 0;
    if (millis() - lastBlink > 500) {
      digitalWrite(LED_BLUE, !digitalRead(LED_BLUE));
      lastBlink = millis();
    }
  }
}

// LED闪烁函数
void blinkLED(int pin, int times, int delayMs) {
  for (int i = 0; i < times; i++) {
    digitalWrite(pin, LOW);
    delay(delayMs);
    digitalWrite(pin, HIGH);
    delay(delayMs);
  }
}
