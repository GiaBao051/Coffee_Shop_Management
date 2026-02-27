# ☕ GIBOR COFFEE SHOP

> Website đặt hàng và giới thiệu thương hiệu cà phê **GIBOR** — hương vị nguyên bản, mộc mạc từ nông trại đến tách cà phê.

---

## 📌 Giới thiệu

**GIBOR Coffee** là đồ án môn học xây dựng website thương mại điện tử cho một quán cà phê. Website cung cấp đầy đủ chức năng từ xem menu, đặt hàng, quản lý giỏ hàng đến thanh toán, cùng hệ thống xác thực người dùng tích hợp Firebase.

- **Địa chỉ quán:** 140 Lê Trọng Tấn, Tân Phú, TP.HCM  
- **Giờ mở cửa:** 07:00 – 22:00 hàng ngày  
- **Năm thực hiện:** 2026  

---

## 👥 Thành viên nhóm

| Thành viên | Vai trò |
|---|---|
| Trần Gia Bảo | Frontend Developer – Giao diện & Logic chính |
| Nguyễn Thế Anh | Firebase Integration – Xác thực & Cấu hình backend |

> *Team 3 – Đồ án Kỳ 4 (2025–2026)*

---

## 🗂️ Cấu trúc thư mục

```
GIBOR-COFFEE-SHOP_GIABAO/
├── index.html          # Trang chủ
├── menu.html           # Trang menu sản phẩm
├── about.html          # Giới thiệu về quán
├── contact.html        # Liên hệ
├── cart.html           # Giỏ hàng
├── login.html          # Đăng nhập
├── register.html       # Đăng ký tài khoản
├── payment.html        # Thanh toán
│
├── css/
│   ├── style.css       # CSS chung toàn trang
│   ├── home.css        # Trang chủ
│   ├── menu.css        # Trang menu
│   ├── about.css       # Trang giới thiệu
│   ├── contact.css     # Trang liên hệ
│   ├── cart.css        # Giỏ hàng
│   ├── login.css       # Đăng nhập
│   ├── register.css    # Đăng ký
│   ├── payment.css     # Thanh toán
│   ├── popup.css       # Popup thông báo
│   └── mobile.css      # Responsive cho mobile
│
├── js/
│   ├── data.js         # Quản lý người dùng & dữ liệu (localStorage)
│   ├── firebase.js     # Cấu hình & khởi tạo Firebase
│   ├── auth.js         # Xác thực người dùng
│   ├── loginregister.js# Xử lý đăng nhập / đăng ký
│   ├── cart.js         # Quản lý giỏ hàng
│   ├── payment.js      # Xử lý thanh toán
│   ├── main.js         # Logic dùng chung (navbar, dark mode, preloader)
│   ├── mobile.js       # Hành vi responsive mobile
│   ├── about.js        # Logic trang giới thiệu
│   └── contact.js      # Logic trang liên hệ
│
└── images/
    ├── logo/           # Logo thương hiệu
    ├── banner/         # Ảnh banner trang chủ
    ├── menu/           # Ảnh sản phẩm menu
    └── about/          # Ảnh trang giới thiệu
```

---

## ✨ Tính năng chính

### 🏠 Trang chủ
- Màn hình loading (preloader) với logo thương hiệu
- Banner hero với call-to-action đặt hàng
- Giới thiệu ngắn về triết lý cà phê nguyên bản
- Banner khuyến mãi (Mua 2 Tặng 1 Bạc Xỉu)
- Tích hợp Google Maps vị trí quán

### ☕ Menu
- Hiển thị danh sách sản phẩm theo danh mục
- Chức năng thêm sản phẩm vào giỏ hàng

### 🛒 Giỏ hàng & Thanh toán
- Quản lý giỏ hàng với localStorage
- Cập nhật số lượng, xóa sản phẩm
- Hiển thị tổng tiền theo thời gian thực
- Quy trình thanh toán hoàn chỉnh

### 👤 Tài khoản người dùng
- Đăng ký tài khoản với email & mật khẩu
- Đăng nhập bằng email/mật khẩu (localStorage) hoặc Google (Firebase)
- Dropdown thông tin tài khoản trên header
- Hệ thống điểm tích lũy (PointsManager)
- Xem lịch sử đơn hàng

### 🎨 Giao diện & UX
- **Dark Mode** — chuyển đổi sáng/tối, lưu tùy chọn
- **Responsive Design** — tương thích desktop, tablet, mobile
- **Hamburger Menu** — điều hướng trên thiết bị di động
- **Sticky Header** — thanh điều hướng cố định khi cuộn
- Font chữ: *Montserrat*, *Playfair Display*, *Mrs Saint Delafield*
- Icon: Font Awesome 6.5.1

---

## 🛠️ Công nghệ sử dụng

| Công nghệ | Mô tả |
|---|---|
| HTML5 | Cấu trúc trang web |
| CSS3 | Giao diện, animation, responsive |
| JavaScript (ES6+) | Logic frontend, DOM manipulation |
| Firebase Auth v10 | Xác thực người dùng qua Google OAuth |
| localStorage | Lưu trữ dữ liệu người dùng, giỏ hàng, theme |
| Font Awesome 6.5.1 | Bộ icon |
| Google Fonts | Typography |
| Google Maps Embed | Bản đồ vị trí quán |

---

## 🗄️ Cơ sở dữ liệu

File SQL: [`DataBase/DB_DA_QuanLyQuanCF.sql`](DataBase/DB_DA_QuanLyQuanCF.sql)

Sơ đồ CSDL: [`DataBase/Diagram.drawio`](DataBase/Diagram.drawio)

---

## 🚀 Hướng dẫn chạy dự án

Dự án là website tĩnh thuần HTML/CSS/JS, **không cần cài đặt** phụ thuộc nào.

### Cách 1: Mở trực tiếp
```
Mở file index.html bằng trình duyệt web (Chrome/Edge/Firefox)
```

### Cách 2: Dùng Live Server (khuyến nghị)
1. Cài extension **Live Server** trong VS Code
2. Click chuột phải vào `index.html` → **Open with Live Server**
3. Trình duyệt tự động mở tại `http://127.0.0.1:5500`

> ⚠️ **Lưu ý:** Chức năng đăng nhập Google (Firebase) yêu cầu chạy qua server (không thể mở file:// trực tiếp).

---

## 📱 Hỗ trợ thiết bị

| Thiết bị | Trạng thái |
|---|---|
| Desktop (≥ 1024px) | ✅ Đầy đủ |
| Tablet (768px – 1023px) | ✅ Đầy đủ |
| Mobile (< 768px) | ✅ Đầy đủ |

---

## 📄 Giấy phép

© 2026 **GIBOR COFFEE**. Đồ án học thuật — Team 4, Kỳ 4 (2025–2026).  
Trường Đại học Công Thương TP. Hồ Chí Minh (HUIT).
