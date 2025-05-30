# Smart_Garden_Project
# 🌱 Smart Garden v2.1 (AVR)
## ĐẶT VẤN ĐỀ
### Khái quát
Trong thời đại công nghệ, việc ứng dụng các hệ thống thông minh sử dụng cảm
biến đang trở thành xu hướng phổ biến. Các cảm biến được tích hợp giúp thu thập dữ
liệu về nhiệt độ, ánh sáng, chuyển động, và nhiều thông tin khác. Từ đó, vườn rau có
thể tự động điều khiển, mang lại sự tiện nghi, an toàn và tiết kiệm năng lượng.
### Lý do chọn đề tài
Việc thiết kế hệ thống vườn thông minh sử dụng các cảm biến là một đề tài có
nhiều tiềm năng ứng dụng trong thực tế. Các lý do chính khiến đề tài này được lựa
chọn bao gồm: Nhu cầu ngày càng tăng về sự tiện lợi, an toàn và tiết kiệm năng lượng
trong quá trình sản xuất; Tiềm năng thị trường lớn cho các giải pháp nông nghiệp
thông minh sử dụng cảm biến có giá thành hợp lý và dễ ứng dụng; Phù hợp với thời
gian nghiên cứu và mục tiêu môn học đề ra.

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
## Chi tiết hoạt động của dự án
### Khi bắt đầu chương trình 
https://github.com/user-attachments/assets/0a29f42b-ba93-440f-8400-c172d5bd55a2

### Khối mở cửa
https://github.com/user-attachments/assets/b30ab63e-868c-456a-b049-d4f57b4c9ab6

### Khối bật tắt đèn khi clap 2 lần 
https://github.com/user-attachments/assets/f04b529f-8dd0-40fd-a486-890ce29304f3

### Cảnh báo khi nhiệt độ > 38 độ C
https://github.com/user-attachments/assets/04ab473f-949c-4921-8430-c594595824e2

## 💻 Cấu trúc chương trình

```c
- main()
  ├── init_all()
  ├── while(1)
       ├── check_clap_switch()
       ├── check_obstacle_sensor()
       ├── check_dht_and_update_display()
       └── update_uptime_display()
