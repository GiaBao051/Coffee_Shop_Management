# Hướng Dẫn Đổi Mật Khẩu với Xác Thực Email

## Tính năng đã được cập nhật

Hệ thống đổi mật khẩu đã được cải tiến để sử dụng xác thực qua email thay vì nhập OTP. Người dùng sẽ nhận email xác thực và click vào link để hoàn tất việc đổi mật khẩu.

## Cách hoạt động

### 1. Truy cập trang Tài khoản
- Đăng nhập vào tài khoản của bạn
- Vào trang `account.html` hoặc click vào tên người dùng > "Tài khoản của tôi"

### 2. Chuyển sang tab Bảo mật
- Click vào tab "Bảo mật" trong trang tài khoản
- Điền form đổi mật khẩu:
  - Mật khẩu hiện tại
  - Mật khẩu mới (tối thiểu 6 ký tự)
  - Xác nhận mật khẩu mới

### 3. Xác thực qua Email
Khi bạn submit form:

1. **Kiểm tra mật khẩu cũ** - Hệ thống xác minh mật khẩu hiện tại đúng không

2. **Lưu yêu cầu tạm thời** - Thông tin đổi mật khẩu được lưu vào sessionStorage:
   - User ID
   - Email
   - Mật khẩu cũ và mới (đã mã hóa)
   - Token xác thực duy nhất
   - Timestamp (thời gian tạo)

3. **Popup xác nhận** - Hiển thị popup yêu cầu gửi email xác thực:
   - Hiển thị email đã che (vd: abc***@gmail.com)
   - Nút "Gửi email xác thực"
   - Nút "Hủy"

4. **Gửi email** - Khi click "Gửi email xác thực":
   - Email được gửi qua Firebase Authentication
   - Email chứa link xác thực với token duy nhất
   - Link có hiệu lực trong 15 phút

5. **Xác thực từ email** - Người dùng:
   - Mở email trong hộp thư
   - Click vào link xác thực
   - Được chuyển về trang account.html với token

6. **Hoàn tất đổi mật khẩu** - Hệ thống:
   - Kiểm tra token hợp lệ
   - Kiểm tra thời gian chưa hết hạn (15 phút)
   - Thực hiện đổi mật khẩu
   - Tự động đăng xuất
   - Chuyển về trang đăng nhập

## Ưu điểm của phương pháp này

### 1. Bảo mật cao hơn
- Không cần nhập OTP thủ công (tránh bị nhìn trộm)
- Token xác thực duy nhất, không thể đoán
- Link chỉ sử dụng được một lần
- Tự động hết hạn sau 15 phút

### 2. Trải nghiệm người dùng tốt hơn
- Không cần nhớ và nhập mã OTP 6 số
- Chỉ cần click vào link trong email
- Giảm thiểu lỗi nhập sai OTP

### 3. Tích hợp Firebase
- Sử dụng Firebase Authentication để gửi email
- Email chuyên nghiệp từ Firebase
- Tự động xử lý retry và error

## Cấu hình Firebase

File `account.html` đã được cấu hình với Firebase:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyCnHG40t4WN230Alu4ia0cvzKhfndeBfpE",
  authDomain: "coffee-a718c.firebaseapp.com",
  projectId: "coffee-a718c",
  storageBucket: "coffee-a718c.firebasestorage.app",
  messagingSenderId: "37237991343",
  appId: "1:37237991343:web:035a77871af9b41476315a",
  measurementId: "G-YSS8HXMN6R",
};
```

## Các file đã được cập nhật

### 1. `js/account.js`
- **bindPasswordSave()**: 
  - Lưu yêu cầu đổi mật khẩu vào sessionStorage
  - Gọi hàm gửi email xác thực
  - Không còn sử dụng OTP popup
  
- **init()**:
  - Kiểm tra query parameter `verify_password_change`
  - Gọi hàm xác thực nếu có token

### 2. `js/main.js`
- **generateVerificationToken()**: Tạo token xác thực duy nhất
- **sendPasswordChangeVerificationEmail()**: Gửi email xác thực qua Firebase
- **showPasswordChangeVerificationPopup()**: Hiển thị popup yêu cầu gửi email
- **verifyAndChangePassword()**: Xác thực token và thực hiện đổi mật khẩu

## Cấu trúc dữ liệu

### Request trong sessionStorage
```javascript
{
  userId: 1234567890,
  email: "user@example.com",
  oldPassword: "******",
  newPassword: "******",
  timestamp: 1711234567890,
  token: "abc123xyz789def456"
}
```

### URL xác thực
```
https://yourdomain.com/account.html?verify_password_change=abc123xyz789def456
```

## Quy trình chi tiết

```
[User] Nhập form đổi mật khẩu
   ↓
[System] Kiểm tra mật khẩu cũ
   ↓
[System] Lưu request vào sessionStorage
   ↓
[System] Hiển thị popup xác nhận
   ↓
[User] Click "Gửi email xác thực"
   ↓
[Firebase] Gửi email với link xác thực
   ↓
[User] Mở email, click link
   ↓
[Browser] Mở account.html?verify_password_change=TOKEN
   ↓
[System] Kiểm tra token và thời gian
   ↓
[System] Thực hiện đổi mật khẩu
   ↓
[System] Đăng xuất và chuyển về login
```

## Xử lý lỗi

### Token không hợp lệ
- Hiển thị: "Link xác thực không đúng. Vui lòng thử lại."
- Người dùng cần thực hiện lại yêu cầu đổi mật khẩu

### Token hết hạn (> 15 phút)
- Hiển thị: "Link xác thực đã hết hạn (15 phút). Vui lòng thực hiện lại yêu cầu đổi mật khẩu."
- Xóa request khỏi sessionStorage

### Không tìm thấy request
- Hiển thị: "Không tìm thấy yêu cầu đổi mật khẩu hoặc yêu cầu đã hết hạn."
- Có thể do:
  - SessionStorage đã bị xóa
  - Trình duyệt đã đóng
  - Request đã được xử lý

### Firebase không gửi được email
- Hiển thị thông báo lỗi cụ thể
- Người dùng có thể thử lại

## Lưu ý quan trọng

### Bảo mật
- Token được tạo ngẫu nhiên, không thể đoán
- Request lưu trong sessionStorage (tự động xóa khi đóng tab)
- Link chỉ có hiệu lực 15 phút
- Tự động đăng xuất sau khi đổi mật khẩu

### SessionStorage vs LocalStorage
- **SessionStorage**: Dữ liệu bị xóa khi đóng tab/trình duyệt
- Phù hợp cho yêu cầu tạm thời như đổi mật khẩu
- Bảo mật hơn LocalStorage

### Email từ Firebase
- Email được gửi từ Firebase Authentication
- Có thể rơi vào thư mục Spam/Junk
- Người dùng cần kiểm tra cả thư mục Spam

## So sánh với phương pháp OTP cũ

| Tiêu chí | OTP (Cũ) | Email Link (Mới) |
|----------|----------|------------------|
| Bảo mật | Trung bình | Cao |
| Dễ sử dụng | Trung bình | Cao |
| Tốc độ | Nhanh | Trung bình |
| Lỗi nhập sai | Có thể | Không |
| Hết hạn | 5 phút | 15 phút |
| Sử dụng lại | Không | Không |

## Cải tiến trong tương lai

1. **Custom Email Template** - Tùy chỉnh giao diện email từ Firebase
2. **SMS Verification** - Thêm tùy chọn xác thực qua SMS
3. **Biometric Authentication** - Xác thực bằng vân tay/khuôn mặt
4. **Activity Log** - Ghi lại lịch sử đổi mật khẩu

## Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra email trong thư mục Spam/Junk
2. Đảm bảo link chưa hết hạn (15 phút)
3. Thử thực hiện lại yêu cầu đổi mật khẩu
4. Kiểm tra kết nối internet
5. Liên hệ hỗ trợ nếu vẫn gặp lỗi

---

**Phát triển bởi**: Nhóm GIBOR Coffee Shop
**Ngày cập nhật**: 2026-03-25
**Phiên bản**: 2.0 - Email Verification
