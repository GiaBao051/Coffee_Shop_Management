# ☕ GIBOR COFFEE SHOP

> Website đặt hàng và giới thiệu thương hiệu cà phê **GIBOR** — hương vị nguyên bản, mộc mạc từ nông trại đến tách cà phê.

---

## 📌 Giới thiệu

**GIBOR Coffee** là đồ án môn học xây dựng website thương mại điện tử cho một quán cà phê. Website cung cấp đầy đủ chức năng từ xem menu, đặt hàng, quản lý giỏ hàng đến thanh toán, cùng hệ thống xác thực người dùng tích hợp Firebase.

- **Địa chỉ quán:** 140 Lê Trọng Tấn, Tân Phú, TP.HCM  
- **Hệ thống chi nhánh:** 15 chi nhánh trên toàn quốc (TP.HCM, Hà Nội, Đà Nẵng)
- **Giờ mở cửa:** 07:00 – 22:00 hàng ngày
- **Năm thực hiện:** 2025 – 2026

---

## 👥 Thành viên nhóm

| STT | Thành viên | Vai trò | Phụ trách chính |
|:---:|---|---|---|
| 1 | **Trần Gia Bảo** | Frontend Developer – Leader | Trang chủ, CSS chung, logic chung (`main.js`), trang giới thiệu, trang liên hệ, giao diện dark mode |
| 2 | **Trần Dương Gia Bảo** | Frontend Developer | Quản lý dữ liệu & người dùng (`data.js`), giỏ hàng (`cart.js`), trang thanh toán (`payment.html`, `payment.js`), hệ thống điểm tích lũy |
| 3 | **Nguyễn Thế Anh** | Firebase Integration | Đăng nhập / Đăng ký (`login.html`, `register.html`, `loginregister.js`), cấu hình Firebase (`firebase.js`) |
| 4 | **Nguyễn Hoàng Bảo** | Frontend Developer | Trang menu (`menu.html`), hệ thống popup & thông báo (`popup.css`) |

> *Team 3 – Đồ án Kỳ 4 (2025–2026)*  
> *Trường Đại học Công Thương TP. Hồ Chí Minh (HUIT)*

---

## 🗂️ Cấu trúc thư mục

```
GIBOR-COFFEE-SHOP_GIABAO/
├── index.html              # Trang chủ                    [Trần Gia Bảo]
├── menu.html               # Trang menu sản phẩm          [Nguyễn Hoàng Bảo]
├── about.html              # Giới thiệu về quán           [Trần Gia Bảo]
├── contact.html            # Liên hệ                      [Trần Gia Bảo]
├── cart.html               # Giỏ hàng                     [Trần Dương Gia Bảo]
├── login.html              # Đăng nhập                    [Nguyễn Thế Anh]
├── register.html           # Đăng ký tài khoản            [Nguyễn Thế Anh]
├── payment.html            # Thanh toán                   [Trần Dương Gia Bảo]
│
├── css/
│   ├── style.css           # CSS chung                    [Trần Gia Bảo + Trần Dương Gia Bảo]
│   ├── home.css            # Trang chủ                    [Trần Gia Bảo]
│   ├── menu.css            # Trang menu                   [Nguyễn Hoàng Bảo]
│   ├── about.css           # Trang giới thiệu             [Trần Gia Bảo]
│   ├── contact.css         # Trang liên hệ                [Trần Gia Bảo]
│   ├── cart.css            # Giỏ hàng                     [Trần Dương Gia Bảo]
│   ├── login.css           # Đăng nhập                    [Nguyễn Thế Anh]
│   ├── register.css        # Đăng ký                      [Nguyễn Thế Anh]
│   ├── payment.css         # Thanh toán                   [Trần Gia Bảo + Trần Dương Gia Bảo]
│   ├── popup.css           # Popup & thông báo            [Nguyễn Hoàng Bảo]
│   └── mobile.css          # Responsive mobile            [Trần Gia Bảo]
│
├── js/
│   ├── data.js             # Quản lý dữ liệu & tài khoản [Trần Dương Gia Bảo]
│   ├── firebase.js         # Cấu hình Firebase            [Nguyễn Thế Anh]
│   ├── auth.js             # Xác thực người dùng
│   ├── loginregister.js    # Logic đăng nhập / đăng ký    [Nguyễn Thế Anh]
│   ├── cart.js             # Logic giỏ hàng               [Trần Dương Gia Bảo]
│   ├── payment.js          # Logic thanh toán             [Trần Dương Gia Bảo + Trần Gia Bảo]
│   ├── main.js             # Logic chung toàn trang       [Trần Gia Bảo + Nguyễn Hoàng Bảo + Trần Dương Gia Bảo]
│   ├── mobile.js           # Hành vi responsive mobile    [Trần Gia Bảo]
│   ├── about.js            # Logic trang giới thiệu       [Trần Gia Bảo]
│   └── contact.js          # Logic trang liên hệ          [Trần Gia Bảo]
│
├── images/
│   ├── logo/               # Logo thương hiệu
│   ├── banner/             # Ảnh banner trang chủ
│   ├── menu/               # Ảnh sản phẩm menu
│   └── about/              # Ảnh trang giới thiệu
│
└── DataBase/
    ├── DB_DA_QuanLyQuanCF.sql   # Script tạo CSDL
    └── Diagram.drawio           # Sơ đồ quan hệ thực thể (ERD)
```

---

## ✨ Tính năng chính

### 🏠 Trang chủ *(Trần Gia Bảo)*
- Màn hình loading (preloader) với logo thương hiệu
- Banner hero với call-to-action đặt hàng
- Giới thiệu triết lý cà phê nguyên bản
- Banner khuyến mãi (Mua 2 Tặng 1 Bạc Xỉu)
- Tích hợp Google Maps vị trí quán

### ☕ Menu *(Nguyễn Hoàng Bảo)*
- Hiển thị danh sách sản phẩm theo danh mục
- Thêm sản phẩm vào giỏ hàng trực tiếp

### 🛒 Giỏ hàng *(Trần Dương Gia Bảo)*
- Quản lý giỏ hàng lưu trữ bằng localStorage
- Cập nhật số lượng, xóa sản phẩm
- Hiển thị tổng tiền theo thời gian thực

### 💳 Thanh toán *(Trần Dương Gia Bảo + Trần Gia Bảo)*
- Quy trình thanh toán hoàn chỉnh
- Xác nhận đơn hàng và lưu lịch sử

### 👤 Tài khoản người dùng *(Nguyễn Thế Anh + Trần Dương Gia Bảo)*
- Đăng ký tài khoản với email & mật khẩu
- Đăng nhập bằng email/mật khẩu (localStorage) hoặc Google (Firebase)
- Dropdown thông tin tài khoản trên header
- Hệ thống điểm tích lũy
- Xem lịch sử đơn hàng

### 🔔 Hệ thống thông báo Popup *(Nguyễn Hoàng Bảo)*
- Popup thông báo thành công / lỗi
- Xác nhận hành động (xóa, đặt hàng, ...)

### 🎨 Giao diện & UX *(Trần Gia Bảo)*
- **Dark Mode** — chuyển đổi sáng/tối, lưu tùy chọn vào localStorage
- **Responsive Design** — tương thích desktop, tablet, mobile
- **Hamburger Menu** — điều hướng trên thiết bị di động
- **Sticky Header** — thanh điều hướng cố định khi cuộn trang
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
| Font Awesome 6.5.1 | Bộ icon giao diện |
| Google Fonts | Typography (Montserrat, Playfair Display) |
| Google Maps Embed API | Bản đồ vị trí quán |

---

## 🗄️ Cơ sở dữ liệu

| File | Mô tả |
|---|---|
| `DataBase/DB_DA_QuanLyQuanCF.sql` | Script tạo và khởi tạo dữ liệu CSDL |
| `DataBase/Diagram.drawio` | Sơ đồ quan hệ thực thể (ERD) |

---

## 🚀 Hướng dẫn chạy dự án

Dự án là website tĩnh thuần HTML/CSS/JS, **không cần cài đặt** phụ thuộc nào.

### Cách 1: Mở trực tiếp
Mở file `index.html` bằng trình duyệt web (Chrome / Edge / Firefox).

### Cách 2: Dùng Live Server *(khuyến nghị)*
1. Cài extension **Live Server** trong VS Code
2. Click chuột phải vào `index.html` → **Open with Live Server**
3. Trình duyệt tự động mở tại `http://127.0.0.1:5500`

> ⚠️ **Lưu ý:** Chức năng đăng nhập Google (Firebase) yêu cầu chạy qua server HTTP. Không hoạt động khi mở trực tiếp bằng `file://`.

---

## 📱 Hỗ trợ thiết bị

| Thiết bị | Kích thước | Trạng thái |
|---|---|---|
| Desktop | ≥ 1024px | ✅ Đầy đủ |
| Tablet | 768px – 1023px | ✅ Đầy đủ |
| Mobile | < 768px | ✅ Đầy đủ |

---

## 📄 Bản quyền

© 2026 **GIBOR COFFEE**. Đồ án học thuật — Team 3, Kỳ 4 (2025–2026).  
Trường Đại học Công Thương TP. Hồ Chí Minh (HUIT).
