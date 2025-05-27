# Smart_Garden_Project
# 🌱 Smart Garden v2.1 (AVR)

### 👨‍💻 MCU: ATmega328P  
### 🧠 IDE: CodeVisionAVR  
### 📅 Dự án cuối kỳ — Hệ thống vườn thông minh bán tự động

---

## 📌 Tính năng chính

- 👏 **Điều khiển LED bằng 2 tiếng vỗ tay (KY-037)**
- 🚪 **Mở cổng servo khi phát hiện vật cản (FC-51)**
- 🌡️ **Đo và hiển thị nhiệt độ/độ ẩm bằng DHT11**
- 📟 **Hiển thị thông tin trên màn hình OLED SSD1306**
- 🚨 **Cảnh báo nhiệt độ cao bằng buzzer**
- ⏱️ **Hiển thị thời gian hoạt động hệ thống (uptime)**

---

## ⚙️ Phần cứng sử dụng

| Thiết bị                  | Mô tả                         |
|--------------------------|-------------------------------|
| ATmega328P               | Vi điều khiển chính           |
| DHT11                    | Cảm biến nhiệt độ và độ ẩm    |
| KY-037                   | Cảm biến âm thanh (vỗ tay)    |
| FC-51                    | Cảm biến vật cản hồng ngoại   |
| Servo SG90               | Đóng/mở cổng thông minh       |
| OLED SSD1306 (I2C)       | Hiển thị dữ liệu              |
| Buzzer                   | Cảnh báo nhiệt độ cao         |
| LED                      | Phản hồi khi vỗ tay           |

---

## 🧠 Mô tả chi tiết hoạt động

### 1. 👏 **Vỗ tay bật/tắt đèn**
- Khi phát hiện **2 tiếng vỗ tay liên tiếp**, hệ thống bật/tắt LED.
- Debounce chống nhiễu âm thanh được tích hợp.

### 2. 🚪 **Cảm biến vật cản mở cổng**
- FC-51 phát hiện người/động vật → điều khiển servo mở cửa trong 5 giây → tự đóng.

### 3. 🌡️ **Đo nhiệt độ và cảnh báo**
- Dữ liệu nhiệt độ/độ ẩm được đo mỗi 2 giây.
- Nếu nhiệt độ vượt ngưỡng (mặc định >38°C), buzzer phát cảnh báo chớp nháy.

### 4. 📟 **OLED hiển thị**
- Thông tin được cập nhật:
  - Nhiệt độ
  - Độ ẩm
  - Trạng thái cảnh báo
  - Uptime tính theo `giờ:phút:giây`

---

## 🧾 Sơ đồ kết nối (Pinout)

| Thiết bị     | ATmega328P Pin |
|--------------|----------------|
| KY-037       | PD4 (Digital)  |
| FC-51        | PD5 (Digital)  |
| DHT11        | PD6 (Digital)  |
| Servo        | PD3 (OC2B PWM) |
| OLED (SCL)   | PC5 (A5)       |
| OLED (SDA)   | PC4 (A4)       |
| Buzzer       | PB0 (Digital)  |
| LED          | PB1 (Digital)  |

---

## 💻 Cấu trúc chương trình

```c
- main()
  ├── init_all()
  ├── while(1)
       ├── check_clap_switch()
       ├── check_obstacle_sensor()
       ├── check_dht_and_update_display()
       └── update_uptime_display()
