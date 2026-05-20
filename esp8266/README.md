# BL602 UPS WiFi 服务器 (Ai-WB2-12F)

基于安信可 Ai-WB2-12F (BL602芯片) 的WiFi固件，用于将UPS数据通过HTTP接口提供给APP。

## 硬件信息

| 项目 | 规格 |
|------|------|
| **模块** | Ai-WB2-12F |
| **芯片** | BL602 (RISC-V架构) |
| **WiFi** | 802.11 b/g/n |
| **蓝牙** | BLE 5.0 |
| **主频** | 120MHz |
| **RAM** | 276KB |
| **电压** | 3.3V |

## 硬件连接

```
Ai-WB2-12F        UPS主板
----------        --------
GPIO10 (RX)  ───► TX (数据发送)
GPIO11 (TX)  ───► RX (数据接收)
GND           ───► GND
```

**注意**：
- 根据UPS主板的串口电平，可能需要电平转换（3.3V ↔ 5V）
- BL602是3.3V系统，不要直接连接5V设备

## 软件需求

- Arduino IDE 1.8+ 或 VS Code + PlatformIO
- BL602开发板支持包
- ArduinoJson 库

## 安装步骤

### 1. 安装Arduino IDE
下载并安装：https://www.arduino.cc/en/software

### 2. 安装BL602开发板支持包

**方法一：通过开发板管理器**

1. 打开 Arduino IDE
2. 文件 → 首选项 → 附加开发板管理器网址
3. 添加以下URL（点击右侧图标粘贴）：
```
https://github.com/Ai-Thinker-Open/Ai-Thinker-WB2/releases/download/package_ai-thinker_wb2_index.json
```

4. 工具 → 开发板 → 开发板管理器
5. 搜索"Ai-Thinker WB2"并安装

**方法二：手动安装**

如果方法一失败，可以下载SDK包：
- 下载地址：https://github.com/Ai-Thinker-Open/Ai-Thinker-WB2
- 按照仓库中的说明进行安装

### 3. 安装依赖库

1. Sketch → 加载库 → 管理库
2. 安装：ArduinoJson  by Benoit Blanchon

### 4. 选择开发板

在 Arduino IDE 中：
1. 工具 → 开发板 → 选择 "Ai-Thinker WB2 Series"
2. 选择具体型号（如 Ai-WB2-12F）

### 5. 烧录固件

1. 打开 `ups_wifi_server.ino`
2. 修改WiFi配置（SSID和密码）
3. 连接Ai-WB2-12F模块到电脑
4. 点击上传

## WiFi配置

在代码中修改以下配置（第13-14行）：

```cpp
const char* ssid = "你的WiFi名称";
const char* password = "你的WiFi密码";
```

## 引脚定义

```cpp
// BL602引脚
const int LED_BLUE = 22;   // 板载LED
const int LED_GREEN = 21;  // 绿色LED
const int LED_RED = 23;    // 红色LED

// 串口引脚
const int UPS_RX_PIN = 10;  // 连接UPS的TX
const int UPS_TX_PIN = 11;  // 连接UPS的RX
```

**注意**：不同开发板引脚定义可能不同，请根据实际板子调整。

## API接口

### 获取UPS状态
```
GET http://<设备IP>/status

响应：
{
  "success": true,
  "data": {
    "voltage": 220.5,
    "current": 2.5,
    "power": 550,
    "battery": 85,
    "input_voltage": 220,
    "output_status": "normal",
    "ups_mode": "online",
    "load_percent": 45,
    "temperature": 35.2,
    "runtime_remaining": 1800,
    "timestamp": 1704067200
  }
}
```

### 控制UPS
```
POST http://<设备IP>/control

请求：
{
  "command": "shutdown"  // shutdown | restart | test | bypass | beep_on | beep_off
}

响应：
{
  "success": true,
  "message": "命令已发送"
}
```

### 获取设备信息
```
GET http://<设备IP>/info

响应：
{
  "success": true,
  "data": {
    "model": "UPS-WiFi-BL602",
    "firmware": "2.0.0",
    "module": "Ai-WB2-12F",
    "chip": "BL602",
    "wifi_rssi": -45,
    "ip_address": "192.168.1.100",
    "uptime_seconds": 3600
  }
}
```

### 健康检查
```
GET http://<设备IP>/health

响应：
{
  "success": true,
  "uptime": 3600,
  "wifi_rssi": -45,
  "wifi_quality": "good"
}
```

## LED指示

| 状态 | LED表现 |
|------|---------|
| 系统启动 | 蓝色闪烁5次 |
| WiFi连接中 | 蓝色闪烁 |
| WiFi已连接 | 绿色常亮 |
| WiFi连接失败 | 红色常亮 |
| UPS正常 | 绿色常亮 |
| 电池电量低 | 红色闪烁 |
| 电池供电 | 黄色亮起 |
| 收到控制命令 | 绿色闪烁 |

## 与ESP8266版本对比

| 项目 | ESP8266版本 | BL602版本 |
|------|-------------|-----------|
| 库引用 | ESP8266WiFi.h | WiFi.h |
| Web服务器 | ESP8266WebServer | WebServer |
| WiFi断开重连 | 需手动处理 | 内置自动重连 |
| 蓝牙支持 | 无 | BLE 5.0 (可选) |
| RAM | 160KB | 276KB |
| CPU架构 | Tensilica | RISC-V |

## 故障排除

### 1. 找不到开发板
- 检查是否正确添加了开发板URL
- 尝试重新启动Arduino IDE
- 检查USB驱动是否安装

### 2. WiFi连接失败
- 确认SSID和密码正确
- 检查路由器是否正常
- 确保WiFi是2.4G频段（BL602不支持5G WiFi）

### 3. 串口通信失败
- 检查TX/RX接线是否正确
- 确认电平匹配（3.3V ↔ 5V）
- 检查波特率是否匹配

### 4. 上传失败
- 按住BOOT按钮，再按RESET进入下载模式
- 或检查是否有其他设备占用串口

## 后续扩展

BL602支持蓝牙，可以考虑添加以下功能：

1. **蓝牙配网**：通过蓝牙配置WiFi
2. **蓝牙通知**：通过BLE发送告警到手机
3. **OTA升级**：通过WiFi远程升级固件

## 资料链接

- Ai-WB2系列资料：https://ai-thinker.com/product/wb2
- BL602官方文档：https://www.bouffalolab.com
- Arduino Core for BL602：https://github.com/Ai-Thinker-Open/Ai-Thinker-WB2
