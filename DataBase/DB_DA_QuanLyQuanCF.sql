-- Đồ án quản lý chuỗi cửa hàng cà phê --

---- Tạo cơ sở dữ liệu ----
CREATE DATABASE QuanLyChuoiCaPhe
ON PRIMARY
(
	NAME = 'DB_QuanLyChuoiCaPhe',
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DB_QuanLyChuoiCaPhe.mdf',
	SIZE = 10MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 10%
)
LOG ON
(
	NAME = 'DB_QuanLyChuoiCaPhe_Log',
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DB_QuanLyChuoiCaPhe_Log.ldf',
	SIZE = 10MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 10%
)
GO
--Update---

-- Sử dụng cơ sở dữ liệu --
USE QuanLyChuoiCaPhe
GO

/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN THẾ ANH --

/* =============================================================================================================== */

/*=================================================== 1. Quản lý Hệ Thống ======================================*/

CREATE TABLE HeThongTaiKhoan
(
	MaTK char (10) not null,
	TenTK char (50),
	MatKhauTK varchar(50) not null,
	TrangThai BIT DEFAULT 1,

					---KHÓA---
	CONSTRAINT PK_HTTK PRIMARY KEY (MaTK),

					---Giá Trị---
	CONSTRAINT CHK_HeThongTaiKhoan_TrangThai CHECK (TrangThai IN (0,1))

	/*
			Chức năng
	•	Quản lý các tài khoản đăng nhập vào hệ thống quản lý quán cà phê.
	•	Lưu trữ thông tin tài khoản, mật khẩu.
	•	Xác định trạng thái hoạt động của tài khoản (còn hoạt động hoặc bị khóa).

			Đặc điểm
	•	Mỗi tài khoản có một mã duy nhất (MaTK) làm khóa chính.
	•	Có phân quyền thông qua trường ChucVu (Quản lý, Nhân viên,…).
	•	Có ràng buộc kiểm tra giá trị trạng thái chỉ nhận 0 hoặc 1.

	*/
)
GO

CREATE TABLE DuLieuHeThong
(
    MaDuLieu char (25) not null, --DL001
    MaTK char (10) not null,
    HanhDong nvarchar (100),-- đăng ký, xóa/ thêm tk
    TenBang nvarchar (100), -- người dùng/
    SoLuongHanhDong int,
    NoiDung nvarchar (150), -- người dùng đăng nhập sai 5 lần,...
    ThoiGian datetime default getdate(),

						--KHÓA--
    CONSTRAINT PK_DLHT PRIMARY KEY (MaDuLieu),
    CONSTRAINT FK_DLHT_HTTK FOREIGN KEY (MaTK) REFERENCES HeThongTaiKhoan(MaTK)

	/*
			Chức năng
	•	Lưu trữ nhật ký hoạt động của hệ thống.
	•	Ghi nhận các hành động như thêm, sửa, xóa dữ liệu trên các bảng quan trọng.
	•	Theo dõi thời gian và nội dung của từng thao tác.

			Đặc điểm
	•	Mỗi bản ghi có mã dữ liệu (MaDuLieu) làm khóa chính.
	•	Liên kết với bảng HeThongTaiKhoan thông qua khóa ngoại MaTK.
	•	Thời gian được tự động ghi nhận bằng GETDATE().

	*/
)
GO

/*=================================================== 2. Quản Lý Chi Nhánh ======================================*/

CREATE TABLE KhuVuc
(
	MaKhuVuc char (25) not null, --KV001
    TenKhuVuc nvarchar (50),
			    --KHÓA--
    CONSTRAINT PK_KV PRIMARY KEY (MaKhuVuc)

	/*
			Chức năng
	•	Quản lý các khu vực địa lý của hệ thống quán cà phê.
	•	Làm cơ sở để phân chia và quản lý các chi nhánh.

			Đặc điểm
	•	Mỗi khu vực có mã riêng (MaKhuVuc) làm khóa chính.
	•	Thiết kế đơn giản, dễ mở rộng khi thêm khu vực mới.

	*/
)
GO

CREATE TABLE ChiNhanh
(
	MaChiNhanh char (25) not null, -- 001CN
    MaKhuVuc char (25) not null,
    TenChiNhanh nvarchar(50),
    SoDienThoai nvarchar(10), -- số điện thoại của chi nhánh đó
    TrangThai BIT DEFAULT 1, -- 1: hoạt động , 0: không còn hoạt động
    NgayThanhLap DATE DEFAULT GETDATE(),

			    --KHÓA-
    CONSTRAINT PK_CN PRIMARY KEY (MaChiNhanh),
    CONSTRAINT FK_KV_CN FOREIGN KEY (MaKhuVuc) REFERENCES KhuVuc(MaKhuVuc),

			    --Giá Trị
    CONSTRAINT CHK_ChiNhanh_TrangThai CHECK (TrangThai IN (0,1))

	/*
			Chức năng
	•	Quản lý thông tin các chi nhánh của quán cà phê.
	•	Lưu trữ thông tin liên hệ, trạng thái hoạt động và ngày thành lập.

			Đặc điểm
	•	Mỗi chi nhánh có mã riêng (MaChiNhanh) làm khóa chính.
	•	Có khóa ngoại liên kết với bảng KhuVuc.
	•	Ngày thành lập được tự động gán giá trị mặc định.
	•	Có ràng buộc kiểm tra giá trị trạng thái chỉ nhận 0 hoặc 1.

	*/
)
GO

CREATE TABLE TaiKhoanNhanVien
(
    MaTK char (10) not null,
    MaNV char (10) not null,
    CONSTRAINT PK_NVCN PRIMARY KEY (MaTK, MaNV),
    CONSTRAINT FK_HTTK_NVCN FOREIGN KEY (MaTK) REFERENCES HeThongTaiKhoan(MaTK),
    CONSTRAINT FK_TK_NV FOREIGN KEY (MaNV) REFERENCES ThongTinNhanVien(MaNV)
)

/*=================================================== 3. Trigger ======================================*/
CREATE TRIGGER TR_HeThongTaiKhoan_NhatKy
ON HeThongTaiKhoan
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- 1. Tối ưu hiệu năng
    SET NOCOUNT ON;

    DECLARE @HanhDong NVARCHAR(50), 
            @NoiDung NVARCHAR(255), 
            @SoLuong INT,
            @MaNgay CHAR(10);

    -- 2. Xác định dữ liệu dựa trên các bảng ảo inserted và deleted
    -- 
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @HanhDong = N'Sửa tài khoản', 
               @NoiDung = N'Cập nhật thông tin tài khoản hệ thống', 
               @SoLuong = COUNT(*) FROM inserted;
    END
    ELSE IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT @HanhDong = N'Thêm tài khoản', 
               @NoiDung = N'Thêm tài khoản mới vào hệ thống', 
               @SoLuong = COUNT(*) FROM inserted;
    END
    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @HanhDong = N'Xóa tài khoản', 
               @NoiDung = N'Xóa tài khoản khỏi hệ thống', 
               @SoLuong = COUNT(*) FROM deleted;
    END
    ELSE RETURN; -- Không có gì thay đổi thì thoát sớm

    -- 3. Chuẩn bị mã dữ liệu (DL + yyyymmdd)
    SET @MaNgay = 'DL' + CONVERT(CHAR(8), GETDATE(), 112);

    -- 4. Insert vào bảng Nhật ký
    INSERT INTO DuLieuHeThong (MaDuLieu, MaTK, HanhDong, TenBang, SoLuongHanhDong, NoiDung)
    SELECT 
        @MaNgay + RIGHT('000' + CAST(ISNULL((SELECT COUNT(*) FROM DuLieuHeThong WHERE MaDuLieu LIKE @MaNgay + '%'), 0) + 1 AS VARCHAR), 3),
        SUSER_SNAME(),
        @HanhDong,
        N'HeThongTaiKhoan',
        @SoLuong,
        @NoiDung;
END
GO

CREATE TRIGGER TRG_ChiNhanh_NhatKy
ON ChiNhanh
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @HanhDong NVARCHAR(50), 
            @NoiDung NVARCHAR(255), 
            @SoLuong INT,
            @MaPrefix CHAR(10) = 'DL' + CONVERT(CHAR(8), GETDATE(), 112);

    -- 1. Phân loại hành động và lấy số lượng dòng bị tác động
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @HanhDong = N'Sửa dữ liệu', 
               @NoiDung = N'Cập nhật thông tin chi nhánh', 
               @SoLuong = COUNT(*) FROM inserted;
    END
    ELSE IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT @HanhDong = N'Thêm dữ liệu', 
               @NoiDung = N'Thêm chi nhánh mới', 
               @SoLuong = COUNT(*) FROM inserted;
    END
    ELSE
    BEGIN
        SELECT @HanhDong = N'Xóa dữ liệu', 
               @NoiDung = N'Xóa chi nhánh', 
               @SoLuong = COUNT(*) FROM deleted;
    END

    -- 2. Ghi nhật ký vào bảng DuLieuHeThong
    INSERT INTO DuLieuHeThong (MaDuLieu, MaTK, HanhDong, TenBang, SoLuongHanhDong, NoiDung)
    VALUES (
        @MaPrefix + RIGHT('000' + CAST(ISNULL((SELECT COUNT(*) FROM DuLieuHeThong WHERE MaDuLieu LIKE @MaPrefix + '%'), 0) + 1 AS VARCHAR), 3),
        SUSER_SNAME(),
        @HanhDong,
        N'ChiNhanh',
        @SoLuong,
        @NoiDung
    );
END
GO

/*=================================================== 4. Dữ liệu và test ======================================*/

-- 1. Chèn tài khoản Admin (để tránh lỗi khóa ngoại khi trigger chạy)
DECLARE @CurrentUserName VARCHAR(50) = CAST(SUSER_SNAME() AS VARCHAR(50));
INSERT INTO HeThongTaiKhoan (MaTK, TenTK, MatKhauTK, TrangThai)
VALUES (LEFT(@CurrentUserName, 10), 'Admin', 'admin123', 1)

select * from HeThongTaiKhoan

-- 2. Chèn dữ liệu vào bảng KhuVuc
INSERT INTO KhuVuc (MaKhuVuc, TenKhuVuc) 
VALUES 
('KV001', N'Quận 1'),
('KV002', N'Quận 2'),
('KV003', N'Quận 3'),
('KV004', N'Tân Phú'),
('KV005', N'Thủ Đức')

select * from KhuVuc

-- 3. Chèn dữ liệu vào bảng HeThongTaiKhoan
INSERT INTO HeThongTaiKhoan (MaTK, TenTK, MatKhauTK, TrangThai) VALUES
('TK001', 'Nguyen The Anh', '123456', 1),
('TK002', 'Tran Gia Bao', '654321', 1),
('TK003', 'Tran Duong Gia Bao', '111111', 1),
('TK004', 'Le Quang Bao', '222222', 1),
('TK005', 'Nguyen Ngoc Chau', '222222', 1)

Select * from HeThongTaiKhoan

-- 4. Chèn dữ liệu vào bảng ChiNhanh
INSERT INTO ChiNhanh (MaChiNhanh, MaKhuVuc, TenChiNhanh, SoDienThoai, TrangThai) VALUES 
('001CN', 'KV001', N'Cà Phê Gibor Q1', '0909686868', 1),
('002CN', 'KV002', N'Cà Phê Gibor Q2', '0909686868', 1),
('003CN', 'KV003', N'Cà Phê Gibor Q3', '0909686868', 1),
('004CN', 'KV004', N'Cà Phê Gibor Tân Phú', '0909686868', 1),
('005CN', 'KV005', N'Cà Phê Gibor Thủ Đức', '0909686868', 0)

Select * from ChiNhanh

-- 5. Chèn dữ liệu vào bảng TaiKhoanNhanVien
INSERT INTO TaiKhoanNhanVien (MaTK,MaChiNhanh) VALUES
('TK001','001CN'),
('TK002','001CN'),
('TK003','001CN'),
('TK004','001CN'),
('TK005','001CN'),
('TK002','004CN'),
('TK003','003CN'),
('TK004','002CN'),
('TK005','005CN')

-- 6. Xem nhật kí dữ kiệu hệ thống
Select * from DuLieuHeThong

-- TEST 1: Cập nhật thông tin chi nhánh (Kiểm tra TRG_ChiNhanh_NhatKy)
UPDATE ChiNhanh 
SET TrangThai = 1 
WHERE MaChiNhanh = '005CN'

Select * from DuLieuHeThong

-- TEST 2: Xóa một tài khoản (Kiểm tra TR_HeThongTaiKhoan_NhatKy)
DELETE FROM TaiKhoanNhanVien 
WHERE MaTK = 'TK004'
DELETE FROM HeThongTaiKhoan 
WHERE MaTK = 'TK004'

Select * from DuLieuHeThong ORDER BY ThoiGian DESC

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

/* ========================= 1. DANH MỤC CƠ BẢN ========================== */
CREATE TABLE ChucVuNhanVien
(
	MaChucVu CHAR (10), -- QL, NV,…
	ChucVu NVARCHAR (50), -- Quản lí cấp 1, Quản lí cấp 2, Nhân viên cấp 1, Nhân viên cấp 2,…
	LuongCoBan DECIMAL(18,2) -- tính theo giờ (ví dụ 50k/h)

    -- Khóa --
	CONSTRAINT PK_ChucVuNV PRIMARY KEY (MaChucVu),

    -- Ràng buộc --
    CONSTRAINT CHK_LuongCoBan CHECK (LuongCoBan > 0)
    /*
            Chức năng:
    •	Lưu trữ danh sách các chức vụ trong hệ thống.
    •	Mỗi chức vụ gắn với một mức lương cơ bản theo giờ.

            Đặc điểm:
    •	Khóa chính: MaChucVu.
    •	Ràng buộc lương cơ bản luôn > 0.
    •	Là cơ sở để tính lương thực tế khi chấm công.
    */
)
GO

CREATE TABLE CaLamViec 
(
    MaCa CHAR(10), -- Ca01, Ca02, Ca03, PT, ..
    LoaiCa INT, -- 1: Fulltime, 2: Parttime
    TenCa NVARCHAR(30), -- Sáng, Chiều, Đêm, Part-time
    HeSoCa DECIMAL(5,2) DEFAULT 1.0, -- Ca sáng, chiều 1.0, ca đêm 1.5. Lễ tết Ca sáng, chiều 3.0, đêm 4.0
    GioBatDau TIME,
    GioKetThuc TIME,

	-- Khóa --
    CONSTRAINT PK_CaLamViec PRIMARY KEY (MaCa),

    -- Ràng buộc --
    CONSTRAINT CHK_LoaiCa CHECK (LoaiCa IN (1, 2))

    /*
            Chức năng:
    •	Quản lý các ca làm việc: sáng, chiều, đêm, part-time.
    •	Xác định loại ca (Fulltime / Parttime).
    •	Xác định hệ số ca (ca đêm, ca lễ có hệ số cao hơn).
        
            Đặc điểm:
    •	Khóa chính: MaCa.
    •	Ràng buộc loại ca chỉ nhận giá trị hợp lệ (1 hoặc 2).
    •	Lưu giờ bắt đầu – kết thúc để xác định đi muộn / về sớm.

    */
)
GO

-- Bảng ngày đặc biệt: để nhân tiền thưởng tết
CREATE TABLE NgayDacBiet
(
    Ngay DATE PRIMARY KEY,
    TenNgay NVARCHAR(100),
    HeSoLuong DECIMAL(5,2) -- 1.0, 2.0, 3.0

    /*
            Chức năng:
    •	Lưu các ngày lễ, Tết, ngày đặc biệt.
    •	Áp dụng hệ số lương cao hơn trong những ngày này.
            
            Ý nghĩa:
    •	Phục vụ tính thưởng lễ, Tết.
    •	Kết hợp trực tiếp với tính lương trong bảng chấm công.

    */
)

/* ========================= 2. NHÂN SỰ =========================  */
CREATE TABLE ThongTinNhanVien
(
	MaNV CHAR(10), -- tạo tự động
    LoaiNV INT, -- 1: Fulltime, 2: Parttime
	HoTenNV NVARCHAR (50),
	MaChucVu CHAR (10),
    NgayVaoLam DATE,
    NgayNghiViec DATE NULL,
    SoDienThoai VARCHAR(15),
    SoCanCuoc CHAR (15),
    TrangThai BIT CONSTRAINT DF_TrangThai DEFAULT 1, -- 1: Đang làm, 0: Nghỉ làm
    MaChiNhanh CHAR(25)

	-- KHÓA --
	CONSTRAINT PK_ThongTinNV PRIMARY KEY (MaNV),
	CONSTRAINT FK_ThongTinNV_ChucVu FOREIGN KEY (MaChucVu) REFERENCES ChucVuNhanVien (MaChucVu),
    CONSTRAINT FK_NV_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES ChiNhanh(MaChiNhanh),

    -- Ràng buộc --
    CONSTRAINT CHK_NgayLamViec CHECK (NgayNghiViec IS NULL OR NgayNghiViec >= NgayVaoLam),
    CONSTRAINT UQ_SoCanCuoc UNIQUE (SoCanCuoc),
    CONSTRAINT CHK_LoaiNV CHECK (LoaiNV IN (1, 2)),
    CONSTRAINT CHK_SDT CHECK (LEN(SoDienThoai) BETWEEN 9 AND 11)

    /*
                Chức năng:
        •	Quản lý thông tin cá nhân và tình trạng làm việc của nhân viên.
        •	Phân loại nhân viên Fulltime / Parttime.
        •	Liên kết với chi nhánh và chức vụ.
        
                Đặc điểm:
        •	Khóa chính: MaNV.
        •	Ràng buộc:
            o	CCCD là duy nhất.
            o	Ngày nghỉ việc ≥ ngày vào làm.
            o	Số điện thoại hợp lệ.
        •	Trạng thái nhân viên tự động cập nhật (đang làm / nghỉ).

    */
)
GO

-- SEQUENCE sinh số tăng cho MaNV
CREATE SEQUENCE SEQ_MaNV START WITH 1 INCREMENT BY 1;
GO

-- RESET SỐ TỰ ĐỘNG
ALTER SEQUENCE SEQ_MaNV RESTART WITH 1;

-- Tự sinh MaNV
CREATE OR ALTER TRIGGER TRG_TaoMaNV
ON ThongTinNhanVien
AFTER INSERT
AS
BEGIN
    UPDATE nv
    SET MaNV =
    LEFT(i.MaChiNhanh,3)
    + RIGHT('0'+CAST(i.LoaiNV AS VARCHAR),1)
    + RIGHT(CAST(YEAR(i.NgayVaoLam) AS CHAR(4)),2)
    + RIGHT('0000'+CAST(NEXT VALUE FOR SEQ_MaNV AS VARCHAR),4)
    FROM ThongTinNhanVien nv
    JOIN inserted i ON nv.MaNV = i.MaNV;
END;

/*
        Cơ chế:
    •	Sử dụng SEQUENCE + TRIGGER.
    •	Mã nhân viên được tạo dựa trên:
        o	Chi nhánh
        o	Loại nhân viên
        o	Năm vào làm
        o	Số thứ tự tăng dần

*/
GO

-- Cập nhật trạng thái nghỉ việc
CREATE OR ALTER TRIGGER TRG_CapNhatTrangThaiNV
ON ThongTinNhanVien
AFTER UPDATE
AS
BEGIN
UPDATE nv
SET TrangThai = CASE WHEN i.NgayNghiViec IS NULL THEN 1 ELSE 0 END
FROM ThongTinNhanVien nv
JOIN inserted i ON nv.MaNV = i.MaNV;
END;
GO

/* ========================= 3. LỊCH PHÂN CÔNG ========================= */

CREATE TABLE LichPhanCong 
(
    MaLich CHAR(15),
    MaNV CHAR(10),
    MaCa CHAR(10),
    NgayLamViec DATE,
    TrangThai NVARCHAR(20), -- Đã phân công, hủy ca, nghỉ phép
    GhiChu NVARCHAR(200)

	-- KHÓA --
    CONSTRAINT PK_LichPhanCa PRIMARY KEY (MaLich),
    CONSTRAINT FK_Lich_NV FOREIGN KEY (MaNV) REFERENCES ThongTinNhanVien(MaNV),
    CONSTRAINT FK_Lich_Ca FOREIGN KEY (MaCa) REFERENCES CaLamViec(MaCa),

	-- RÀNG BUỘC --
	CONSTRAINT UNI_LICH_NV UNIQUE (MaNV, MaCa, NgayLamViec),
    CONSTRAINT CHK_TrangThai_Lich CHECK (TrangThai IN (N'Đã phân công', N'Hủy ca', N'Nghỉ phép'))

    /*
                Chức năng:
        •	Phân ca làm việc cho nhân viên theo từng ngày.
        •	Ghi nhận trạng thái ca: đã phân công, hủy ca, nghỉ phép.

                Ràng buộc nghiệp vụ:
        •	Một nhân viên không được trùng ca trong cùng ngày.
        •	Không phân ca cho nhân viên đã nghỉ việc.
        •	Không phân ca trước ngày vào làm.
    */

)
GO

-- SEQUENCE sinh số tăng cho MaLich
CREATE SEQUENCE SEQ_MaLich START WITH 1 INCREMENT BY 1;
GO

-- Tự sinh mã lịch
CREATE OR ALTER TRIGGER TRG_TaoMaLich
ON LichPhanCong
AFTER INSERT
AS
BEGIN
UPDATE l
SET MaLich =
LEFT(nv.MaChiNhanh,3)
+ CAST(c.LoaiCa AS CHAR(1))
+ FORMAT(i.NgayLamViec,'ddMMyy')
+ RIGHT('00'+CAST(NEXT VALUE FOR SEQ_MaLich AS VARCHAR),2)
FROM LichPhanCong l
JOIN inserted i ON l.MaNV=i.MaNV AND l.MaCa=i.MaCa AND l.NgayLamViec=i.NgayLamViec
JOIN ThongTinNhanVien nv ON i.MaNV=nv.MaNV
JOIN CaLamViec c ON i.MaCa=c.MaCa;
END;

/*
        Cơ chế:
    •	Trigger tự động tạo MaLich dựa trên:
        o	Chi nhánh
        o	Loại ca
        o	Ngày làm việc
        o	Số ngẫu nhiên tăng dần
*/

GO

-- Cập nhật trạng thái tự động
CREATE TRIGGER TRANGTHAI_PC
ON LichPhanCong
AFTER INSERT
AS
BEGIN

    UPDATE LichPhanCong
    SET TrangThai = N'Đã phân công'
    FROM LichPhanCong
    INNER JOIN inserted ON LichPhanCong.MaLich = inserted.MaLich;
END
GO

-- Không phân ca cho NV nghỉ việc
CREATE TRIGGER TRG_KhongPhanCa_NV_Nghi
ON LichPhanCong
AFTER INSERT,UPDATE
AS
BEGIN
IF EXISTS (
SELECT 1 FROM inserted i
JOIN ThongTinNhanVien nv ON i.MaNV=nv.MaNV
WHERE nv.TrangThai=0
)
BEGIN
RAISERROR (N'Không thể phân ca cho nhân viên đã nghỉ.',16,1);
ROLLBACK;
END
END;
GO

-- Không cho phân ca trước ngày vào làm --
CREATE TRIGGER TRG_KhongPhanCa_TruocNgayVaoLam
ON LichPhanCong
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN ThongTinNhanVien nv ON i.MaNV = nv.MaNV
        WHERE i.NgayLamViec < nv.NgayVaoLam
    )
    BEGIN
        RAISERROR (N'Ngày làm việc phải >= ngày vào làm.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

/* ========================= 4. CHẤM CÔNG ========================= */
CREATE TABLE ChamCong 
(
    MaChamCong CHAR (10),
    MaNV CHAR(10),
    MaLich CHAR(15),
    GioVao DATETIME,
    GioRa DATETIME,
    TrangThai NVARCHAR(20), -- Hợp lệ, Đi muộn, Về sớm
    HeSoNgay DECIMAL(5,2),
    HeSoCa DECIMAL(5,2),
    LuongThucTe DECIMAL(18,2),

	-- Số giờ thực tế: Tính theo đơn vị Giờ, làm tròn 2 chữ số thập phân --
    SoGioThucTe AS (CASE 
    WHEN GioRa < GioVao 
    THEN DATEDIFF(MINUTE, GioVao, DATEADD(DAY,1,GioRa)) / 60.0
    ELSE DATEDIFF(MINUTE, GioVao, GioRa) / 60.0
    END),

	-- Khóa --
    CONSTRAINT PK_ChamCong PRIMARY KEY (MaChamCong),
    CONSTRAINT FK_CC_NhanVien FOREIGN KEY (MaNV) REFERENCES ThongTinNhanVien(MaNV),
    CONSTRAINT FK_CC_Lich FOREIGN KEY (MaLich) REFERENCES LichPhanCong(MaLich),

    -- Ràng buộc --
    CONSTRAINT UQ_CC UNIQUE (MaNV, MaLich),
    CONSTRAINT CHK_TrangThai_ChamCong CHECK (TrangThai IN (N'Hợp lệ', N'Đi muộn', N'Về sớm'))

    /*
            Chức năng:
    •	Ghi nhận giờ vào – giờ ra của nhân viên.
    •	Tự động tính số giờ làm việc thực tế.
    •	Xác định trạng thái: hợp lệ, đi muộn, về sớm.
            
            Đặc điểm:
    •	Không cho chấm công ca đã hủy hoặc nghỉ phép.
    •	Tự động xử lý ca qua đêm.
    •	Liên kết chặt chẽ với lịch phân công.

    */
)
GO

-- Không chấm công ca hủy/nghỉ
CREATE TRIGGER TRG_KhongChamCong_CaHuy
ON ChamCong
AFTER INSERT
AS
BEGIN
IF EXISTS (
SELECT 1 FROM inserted i
JOIN LichPhanCong l ON i.MaLich=l.MaLich
WHERE l.TrangThai IN (N'Hủy ca',N'Nghỉ phép')
)
BEGIN
RAISERROR (N'Không thể chấm công cho ca không hợp lệ.',16,1);
ROLLBACK;
END
END;
GO

/* ========================= 5. PHẠT ĐI MUỘN ========================= */
CREATE TABLE PhatDiMuon 
(
    MaChamCong CHAR(10),
    MaNV CHAR(10) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL,
    NgayPhat DATE NOT NULL,

    CONSTRAINT PK_PHAT PRIMARY KEY (MaChamCong),
    CONSTRAINT FK_Phat_CC FOREIGN KEY (MaChamCong) REFERENCES ChamCong(MaChamCong),
    CONSTRAINT FK_Phat_NV FOREIGN KEY (MaNV) REFERENCES ThongTinNhanVien(MaNV)

    /*
            Chức năng:
    •	Lưu thông tin phạt khi nhân viên đi muộn.
    •	Mức phạt cố định: 30.000 VNĐ / lần.
        
            Tự động hóa:
    •	Tạo bản ghi phạt khi trạng thái chuyển sang “Đi muộn”.
    •	Tự động xóa phạt nếu sửa lại chấm công hợp lệ.
    */
)
GO

/* ========================= 6. BẢNG LƯƠNG ========================= */
-- Bảng lương tổng hợp hàng tháng
CREATE TABLE BangLuong (
    MaBangLuong CHAR(15) NOT NULL,
    MaNV CHAR(10),
    Thang INT,
    Nam INT,
    TongGioThucTe DECIMAL(10,4) DEFAULT 0,
    TongLuongCa DECIMAL(18,2) DEFAULT 0,
    TongThuong DECIMAL(18,2) DEFAULT 0,
    TongKhauTru DECIMAL(18,2) DEFAULT 0,
    TrangThai NVARCHAR(30) CONSTRAINT DF_TrangThaiBL DEFAULT N'Tạm tính', -- Tạm tính, Đã thanh toán
    ThucLinh AS (TongLuongCa + TongThuong - TongKhauTru),

    -- Khóa --
    CONSTRAINT PK_BangLuong PRIMARY KEY (MaBangLuong,MaNV, Thang,Nam),
    CONSTRAINT FK_BangLuong_NV FOREIGN KEY (MaNV) REFERENCES ThongTinNhanVien(MaNV),

    -- Ràng buộc --
    CONSTRAINT UQ_NV_Thang_Nam UNIQUE (MaNV, Thang, Nam),
    CONSTRAINT CHK_Thang CHECK (Thang BETWEEN 1 AND 12),
    CONSTRAINT CHK_Nam CHECK (Nam >= 2026),
    CONSTRAINT CHK_TongLuongCa CHECK (TongLuongCa >= 0),
    CONSTRAINT CHK_Thuong CHECK (TongThuong >= 0),
    CONSTRAINT CHK_KhauTru CHECK (TongKhauTru >= 0)
);
GO

-- SIÊU TRIGGER: Xử lý Chấm công -> Tính lương ca -> Phạt -> Đồng bộ Bảng lương
CREATE OR ALTER TRIGGER TRG_XuLyChamCongToanPhan
ON ChamCong
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF (SELECT TRIGGER_NESTLEVEL()) > 1 RETURN;

    -- 1. Cập nhật Trạng thái và Lương chi tiết cho bản ghi mới/sửa
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE cc
        SET 
            cc.TrangThai = CASE 
                WHEN nv.LoaiNV = 2 THEN N'Hợp lệ'
                WHEN nv.LoaiNV = 1 AND cc.GioVao > DATEADD(MINUTE, 10, CAST(CAST(l.NgayLamViec AS DATETIME) + CAST(c.GioBatDau AS DATETIME) AS DATETIME)) THEN N'Đi muộn'
                WHEN nv.LoaiNV = 1 AND cc.GioRa < DATEADD(MINUTE, -10, CAST(CAST(l.NgayLamViec AS DATETIME) + CAST(c.GioKetThuc AS DATETIME) AS DATETIME)) THEN N'Về sớm'
                ELSE N'Hợp lệ'
            END,
            cc.HeSoNgay = ISNULL(ndb.HeSoLuong, 1.0),
            cc.HeSoCa = c.HeSoCa,
            cc.LuongThucTe = (CASE 
                                WHEN cc.GioRa < cc.GioVao THEN DATEDIFF(MINUTE, cc.GioVao, DATEADD(DAY, 1, cc.GioRa)) / 60.0
                                ELSE DATEDIFF(MINUTE, cc.GioVao, cc.GioRa) / 60.0 
                             END) * cv.LuongCoBan * ISNULL(ndb.HeSoLuong, 1.0) * c.HeSoCa
        FROM ChamCong cc
        JOIN inserted i ON cc.MaChamCong = i.MaChamCong
        JOIN LichPhanCong l ON cc.MaLich = l.MaLich
        JOIN CaLamViec c ON l.MaCa = c.MaCa
        JOIN ThongTinNhanVien nv ON cc.MaNV = nv.MaNV
        JOIN ChucVuNhanVien cv ON nv.MaChucVu = cv.MaChucVu
        LEFT JOIN NgayDacBiet ndb ON l.NgayLamViec = ndb.Ngay;

        -- 2. Quản lý bảng PHẠT
        DELETE FROM PhatDiMuon WHERE MaChamCong IN (SELECT MaChamCong FROM inserted);
        INSERT INTO PhatDiMuon (MaChamCong, MaNV, SoTien, NgayPhat)
        SELECT MaChamCong, MaNV, 30000, CAST(GioVao AS DATE)
        FROM ChamCong
        WHERE MaChamCong IN (SELECT MaChamCong FROM inserted) AND TrangThai = N'Đi muộn';
    END

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        DELETE FROM PhatDiMuon WHERE MaChamCong IN (SELECT MaChamCong FROM deleted);
    END

    -- 3. Đồng bộ sang BẢNG LƯƠNG tháng
    DECLARE @AffectedUsers TABLE (MaNV CHAR(15), Thang INT, Nam INT);
    INSERT INTO @AffectedUsers
    SELECT MaNV, MONTH(GioVao), YEAR(GioVao) FROM inserted UNION
    SELECT MaNV, MONTH(GioVao), YEAR(GioVao) FROM deleted;

    UPDATE bl
    SET 
        bl.TongGioThucTe = ISNULL(Data.Gio, 0),
        bl.TongLuongCa = ISNULL(Data.Tien, 0),
        bl.TongKhauTru = ISNULL((SELECT SUM(SoTien) FROM PhatDiMuon p WHERE p.MaNV = bl.MaNV AND MONTH(p.NgayPhat) = bl.Thang AND YEAR(p.NgayPhat) = bl.Nam), 0)
    FROM BangLuong bl
    OUTER APPLY (
        SELECT SUM(SoGioThucTe) as Gio, SUM(LuongThucTe) as Tien
        FROM ChamCong cc
        WHERE cc.MaNV = bl.MaNV AND MONTH(cc.GioVao) = bl.Thang AND YEAR(cc.GioVao) = bl.Nam
    ) Data
    WHERE EXISTS (SELECT 1 FROM @AffectedUsers a WHERE a.MaNV = bl.MaNV AND a.Thang = bl.Thang AND a.Nam = bl.Nam)
      AND bl.TrangThai <> N'Đã thanh toán';
END;
GO

-- Khóa bảng lương đã thanh toán
CREATE OR ALTER TRIGGER TRG_KhoaBangLuong
ON BangLuong
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu dòng dữ liệu cũ đã có trạng thái 'Đã thanh toán'
    IF EXISTS (
        SELECT 1 FROM deleted d 
        WHERE d.TrangThai = N'Đã thanh toán'
    )
    BEGIN
        -- Ngoại lệ: Cho phép nếu chỉ là rollback trạng thái (nếu cần) hoặc báo lỗi
        RAISERROR (N'LỖI: Bảng lương đã ở trạng thái [Đã thanh toán]. Không thể chỉnh sửa dữ liệu!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Nếu hợp lệ (đang từ Tạm tính -> Đã thanh toán hoặc sửa Tạm tính), tiến hành cập nhật
    UPDATE bl
    SET 
        bl.TongThuong = i.TongThuong,
        bl.TongKhauTru = i.TongKhauTru,
        bl.TrangThai = i.TrangThai,
        bl.TongLuongCa = i.TongLuongCa,
        bl.TongGioThucTe = i.TongGioThucTe
    FROM BangLuong bl
    JOIN inserted i ON bl.MaBangLuong = i.MaBangLuong;
END;
GO

/* ========================= 7. KHỞI TẠO BẢNG LƯƠNG ========================= */
CREATE PROCEDURE SP_KhoiTaoBangLuong
@Thang INT,
@Nam INT
AS
BEGIN
INSERT INTO BangLuong (MaBangLuong,MaNV,Thang,Nam)
SELECT
RIGHT('BL'+CAST(ROW_NUMBER() OVER(ORDER BY MaNV) AS VARCHAR),10),
MaNV,@Thang,@Nam
FROM ThongTinNhanVien
WHERE TrangThai=1
AND NOT EXISTS (
SELECT 1 FROM BangLuong bl
WHERE bl.MaNV=ThongTinNhanVien.MaNV
AND bl.Thang=@Thang AND bl.Nam=@Nam
);
END;
GO

/* ========================= 8. Dữ liệu và test  ========================= */
-- Chức vụ
INSERT INTO ChucVuNhanVien (MaChucVu, ChucVu, LuongCoBan) VALUES 
('QL01', N'Quản lý cấp 1', 100000),
('QL02', N'Quản lý cấp 2', 150000),
('NV01', N'Nhân viên cấp 1', 30000),
('NV02', N'Nhân viên cấp 2', 35000),
('BV01', N'Bảo vệ', 20000);

-- Ca làm việc
INSERT INTO CaLamViec (MaCa, LoaiCa, TenCa, HeSoCa, GioBatDau, GioKetThuc) VALUES 
('SANG', 1, N'Ca Sáng Fulltime', 1.0, '06:00:00', '14:00:00'),
('CHIEU', 1, N'Ca Chiều Fulltime', 1.0, '14:00:00', '22:00:00'),
('DEM', 1, N'Ca Đêm Fulltime', 1.5, '22:00:00', '06:00:00'),
('PT01', 2, N'Part-time Sáng', 1.0, '08:00:00', '12:00:00'),
('PT02', 2, N'Part-time Tối', 1.1, '18:00:00', '22:00:00')

select * from CaLamViec

-- Ngày đặc biệt
INSERT INTO NgayDacBiet (Ngay, TenNgay, HeSoLuong) VALUES 
('2026-01-01', N'Tết Dương Lịch', 3.0),
('2026-02-14', N'Valentine (Thưởng)', 1.2)

select * from NgayDacBiet

-- Nhân viên (Trigger TRG_TaoMaNV sẽ tự sinh MaNV)
INSERT INTO ThongTinNhanVien (MaNV,LoaiNV, HoTenNV, MaChucVu, NgayVaoLam, SoDienThoai, SoCanCuoc, TrangThai, MaChiNhanh) VALUES 
('TEMP1',1, N'Trần Gia Bảo', 'QL02', '2026-01-01', '0911111111', '123456789001', 1, '001CN'),
('TEMP2',1, N'Nguyễn Thế Anh', 'NV01', '2026-01-01', '0922222222', '123456789002', 1, '001CN'),
('TEMP3',2, N'Lê Quang Bảo', 'BV01', '2026-01-05', '0933333333', '123456789003', 1, '001CN'),
('TEMP4',2, N'Trần Dương Gia Bảo', 'NV02', '2026-01-10', '0944444444', '123456789004', 1, '001CN'),
('TEMP5',1, N'Nguyễn Ngọc Châu', 'NV01', '2026-01-15', '0955555555', '123456789005', 1, '001CN')

select * from ThongTinNhanVien ORDER BY MaNV

-- Phân lịch (Trigger TRG_TaoMaLich tự sinh MaLich)
INSERT INTO LichPhanCong (MaLich, MaNV, MaCa, NgayLamViec) VALUES
('L1', '0011260001', 'SANG', '2026-02-01'), 
('L2', '0011260004', 'SANG', '2026-02-01'),
('L3', '0011260005', 'SANG', '2026-02-01'),
('L4', '0012260002', 'DEM', '2026-02-02'),
('L5', '0012260002', 'SANG', '2026-02-01')

SELECT * FROM LichPhanCong

-- Khởi tạo bảng lương cho tất cả nhân viên đang làm việc trong tháng 2/2026
EXEC SP_KhoiTaoBangLuong @Thang = 2, @Nam = 2026;

SELECT * FROM BangLuong

-- Chấm công
-- Ca 1: Đi làm đúng giờ
INSERT INTO ChamCong (MaChamCong, MaNV, MaLich, GioVao, GioRa) 
VALUES ('CC01', '0011260004', '001101022601','2026-02-01 06:00:00', '2026-02-01 14:00:00')

select * from ChamCong

-- Ca 2: Đi muộn (Để test Trigger phạt 30k)
INSERT INTO ChamCong (MaChamCong, MaNV, MaLich, GioVao, GioRa) 
VALUES ('CC02', '0011260004', '001101022602', '2026-02-01 06:15:00', '2026-02-01 14:00:00') -- Muộn 15p (>10p)
select * from ChamCong

-- Test bảng lương       
UPDATE BANGLUONG
SET
    TONGTHUONG = 150000
WHERE MABANGLUONG = 'BL1' 

SELECT *
FROM BangLuong

UPDATE BANGLUONG
SET
    TRANGTHAI = N'Đã thanh toán'
WHERE MABANGLUONG = 'BL1' 

/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN NGỌC CHÂU --

/* =============================================================================================================== */

/*
=================== SẢN PHẨM_CHI NHÁNH ===================
*/
-- CODE BỞI TRẦN GIA BẢO --
CREATE TABLE SanPham_ChiNhanh
(
    MaChiNhanh CHAR(25) NOT NULL,
    MaSanPham  CHAR(10) NOT NULL,

    -- Giá bán thực tế tại chi nhánh
    GiaBan DECIMAL(18,2) NOT NULL,

    TrangThai BIT DEFAULT 1, -- 1: Còn bán, 0: Ngừng bán

    -- KHÓA
    CONSTRAINT PK_SanPham_ChiNhanh PRIMARY KEY (MaChiNhanh, MaSanPham),
    CONSTRAINT FK_SPCN_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_SPCN_SanPham FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham),

    -- RÀNG BUỘC
    CONSTRAINT CHK_SPCN_GiaBan CHECK (GiaBan > 0),
    CONSTRAINT CHK_SPCN_TrangThai CHECK (TrangThai IN (0,1))
);


/*
=================== DANH MỤC SẢN PHẨM ===================
*/
CREATE TABLE DanhMuc
(
    MaDanhMuc CHAR(10) not null,
    TenDanhMuc NVARCHAR(100), -- Cà phê, Trà, Bánh...
    MoTa NVARCHAR(255),

    -- KHÓA
    CONSTRAINT PK_DanhMuc PRIMARY KEY (MaDanhMuc),

    -- RÀNG BUỘC
    CONSTRAINT UQ_TenDanhMuc UNIQUE (TenDanhMuc)
)

/*
=================== SẢN PHẨM ===================
*/
CREATE TABLE SanPham
(
    MaSanPham CHAR(10) not null,
    MaDanhMuc CHAR(10),
    TenSanPham NVARCHAR(150),
    GiaCoBan DECIMAL(18,2),
    TrangThai BIT DEFAULT 1, -- 1: Còn, 0: Hết
    MoTa NVARCHAR(255),

    -- KHÓA
    CONSTRAINT PK_SanPham PRIMARY KEY (MaSanPham),
    CONSTRAINT FK_SanPham_DanhMuc FOREIGN KEY (MaDanhMuc) REFERENCES DanhMuc(MaDanhMuc),

    -- RÀNG BUỘC
    CONSTRAINT CHK_SanPham_GiaCB CHECK (GiaCoBan > 0),
    CONSTRAINT CHK_SanPham_TrangThai CHECK (TrangThai IN (0,1))
)

/*
========================= BIẾN THỂ SẢN PHẨM (Size) =========================
*/
CREATE TABLE BienTheSanPham
(
    MaBienThe CHAR(10) not null,
    MaSanPham CHAR(10) not null,
    Size NVARCHAR(10), -- Nhỏ, Vừa, Lớn
    GiaCongThem DECIMAL(18,2) DEFAULT 0,
    TrangThai BIT DEFAULT 1, -- 1: Còn size, 0: Hết size

    -- KHÓA
    CONSTRAINT PK_BienThe PRIMARY KEY (MaBienThe),
    CONSTRAINT FK_BienThe_SanPham FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham),

    -- RÀNG BUỘC
    CONSTRAINT CHK_BienThe_Size CHECK (Size IN (N'Nhỏ', N'Vừa', N'Lớn')),
    CONSTRAINT CHK_BienThe_GiaCongThem CHECK (GiaCongThem >= 0),
    CONSTRAINT CHK_BienThe_Size_GiaCongThem
        CHECK
        (
            (Size = N'Nhỏ' AND GiaCongThem = 0)
            OR
            (Size IN (N'Vừa', N'Lớn') AND GiaCongThem >= 0)
        ),
    CONSTRAINT CHK_BienThe_TrangThai CHECK (TrangThai IN (0,1)),

    -- Mỗi sản phẩm chỉ có 1 size Nhỏ / Vừa / Lớn
    CONSTRAINT UQ_SanPham_Size UNIQUE (MaSanPham, Size)
)

/*
======================== TÙY CHỌN THÊM (Topping) ========================
*/
CREATE TABLE TuyChonThem
(
    MaTuyChon CHAR(10) not null,
    TenTuyChon NVARCHAR(100), -- Trân châu, Thạch, Kem cheese, Kem trứng...
    GiaCongThem DECIMAL(18,2),
    TrangThai BIT DEFAULT 1, -- 1: Còn, 0: Hết

    -- KHÓA
    CONSTRAINT PK_TuyChonThem PRIMARY KEY (MaTuyChon),

    -- RÀNG BUỘC
    CONSTRAINT UQ_TenTuyChon UNIQUE (TenTuyChon),
    CONSTRAINT CHK_TuyChon_Gia CHECK (GiaCongThem >= 0),
    CONSTRAINT CHK_TuyChon_TrangThai CHECK (TrangThai IN (0,1))
)
/*
===================================== BẢNG TRUNG GIAN GIỮA SanPham_TuyChon =====================================
*/
CREATE TABLE SanPham_TuyChon
(
    MaSanPham CHAR(10) not null,
    MaTuyChon CHAR(10) not null,

    -- KHÓA
    CONSTRAINT PK_SanPham_TuyChon PRIMARY KEY (MaSanPham, MaTuyChon),
    CONSTRAINT FK_SPTC_SanPham FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham),
    CONSTRAINT FK_SPTC_TuyChon FOREIGN KEY (MaTuyChon) REFERENCES TuyChonThem(MaTuyChon)
)

/*
===================================== Dữ liệu và test =====================================
*/

INSERT INTO SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai)
VALUES
-- CN01
('001CN', 'SP01', 30000, 1),
('001CN', 'SP02', 25000, 1),
('001CN', 'SP03', 35000, 1),
('001CN', 'SP04', 40000, 1),

-- CN02 (giá khác + có SP ngừng bán)
('002CN', 'SP01', 28000, 1),
('002CN', 'SP02', 23000, 1),
('002CN', 'SP03', 34000, 0); -- Ngừng bán



INSERT INTO DanhMuc (MaDanhMuc, TenDanhMuc, MoTa)
VALUES
('DM01', N'Cà phê', N'Các loại cà phê pha chế'),
('DM02', N'Trà', N'Trà trái cây, trà sữa'),
('DM03', N'Bánh', N'Bánh ngọt, bánh mặn');

INSERT INTO SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa)
VALUES
('SP01', 'DM01', N'Cà phê sữa', 25000, 1, N'Cà phê sữa truyền thống'),
('SP02', 'DM01', N'Cà phê đen', 20000, 1, N'Cà phê nguyên chất'),
('SP03', 'DM02', N'Trà đào', 30000, 1, N'Trà đào cam sả'),
('SP04', 'DM03', N'Bánh tiramisu', 35000, 1, N'Bánh ngọt Ý');

INSERT INTO BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai)
VALUES
-- SP01
('BT01', 'SP01', N'Nhỏ', 0, 1),
('BT02', 'SP01', N'Vừa', 5000, 1),
('BT03', 'SP01', N'Lớn', 10000, 1),

-- SP02
('BT04', 'SP02', N'Nhỏ', 0, 1),
('BT05', 'SP02', N'Vừa', 4000, 1),
('BT06', 'SP02', N'Lớn', 8000, 1),

-- SP03
('BT07', 'SP03', N'Nhỏ', 0, 1),
('BT08', 'SP03', N'Vừa', 6000, 1),
('BT09', 'SP03', N'Lớn', 12000, 1);


INSERT INTO TuyChonThem (MaTuyChon, TenTuyChon, GiaCongThem, TrangThai)
VALUES
('TC01', N'Trân châu', 5000, 1),
('TC02', N'Thạch trái cây', 4000, 1),
('TC03', N'Kem cheese', 7000, 1),
('TC04', N'Kem trứng', 8000, 1);

INSERT INTO SanPham_TuyChon (MaSanPham, MaTuyChon)
VALUES
('SP01', 'TC01'),
('SP01', 'TC03'),

('SP02', 'TC01'),

('SP03', 'TC01'),
('SP03', 'TC02'),
('SP03', 'TC04');

/* Truy vấn MENU THEO CHI NHÁNH */
SELECT 
    cn.TenChiNhanh,
    dm.TenDanhMuc,
    sp.TenSanPham,
    spcn.GiaBan
FROM SanPham_ChiNhanh spcn
JOIN SanPham sp ON spcn.MaSanPham = sp.MaSanPham
JOIN DanhMuc dm ON sp.MaDanhMuc = dm.MaDanhMuc
JOIN ChiNhanh cn ON spcn.MaChiNhanh = cn.MaChiNhanh
WHERE spcn.TrangThai = 1
ORDER BY dm.TenDanhMuc;

/* =============================================================================================================== */

                                            -- CODE BỞI LÊ QUANG BẢO --

/* =============================================================================================================== */
/*
=========================
1.NHÀ CUNG CẤP
=========================
*/
CREATE TABLE NhaCungCap 
(
    MaNCC char(10) not null,
    TenNCC nvarchar(50),
    DienThoai varchar(15),
    Email varchar(50),
    DiaChi nvarchar(50),
	TrangThai nvarchar(20), ---Trạng Thái (Đang Hợp Tác, Ngừng Hợp Tác)---
	---Khóa--- 
	CONSTRAINT PK_NCC PRIMARY KEY(MaNCC),
	---Ràng buộc---
    CONSTRAINT UQ_TenNCC UNIQUE (TenNCC),
    CONSTRAINT UQ_DienThoai UNIQUE (DienThoai),
	CONSTRAINT UQ_Email UNIQUE (Email),
	CONSTRAINT CK_TrangThai_NCC CHECK (TrangThai IN (N'Đang Hợp Tác', N'Ngừng Hợp Tác'))
);
/*
=========================
2.NGUYÊN LIỆU
=========================
*/
CREATE TABLE NguyenLieu (
    MaNguyenLieu char(10) not null,
    TenNguyenLieu nvarchar(50),
    DonViTinh nvarchar(20),
    GiaNhap DECIMAL(12,2),
    MaNCC char(10) not null,
    CoHanSuDung BIT CONSTRAINT DF_HanSD DEFAULT 0,--- 0:Không có hạn sử dụng, 1:Có hạn sử dụng
    TrangThai nvarchar(20), ---Trạng Thái (Đang Sử Dụng, Ngưng Sử Dụng)---
	---Khóa---
	CONSTRAINT PK_NL PRIMARY KEY(MaNguyenLieu),
    CONSTRAINT FK_NL_NCC FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),
	---Ràng buộc---
	CONSTRAINT CK_TrangThai_NL CHECK (TrangThai IN (N'Đang Sử Dụng', N'Ngưng Sử Dụng')),
	CONSTRAINT UQ_TenNL UNIQUE (TenNguyenLieu),
	CONSTRAINT CK_GiaNhap CHECK(GiaNhap>0),
	CONSTRAINT CK_DonViTinh CHECK (DonViTinh in ('g', 'ml', 'kg', 'chai', N'gói', 'lon'))
);
/*
=========================
3.TỒN KHO NGUYÊN LIỆU
- Mỗi chi nhánh có kho riêng
- Không tồn kho âm
- Có mức cảnh báo hết hàng
=========================
*/
CREATE TABLE TonKhoNguyenLieu (
    MaChiNhanh char(25) not null,
    MaNguyenLieu char(10) not null,
    SoLuongTon DECIMAL(12,2) not null CONSTRAINT DF_SoLuongTon DEFAULT 0,
    MucCanhBao DECIMAL(12,2) not null CONSTRAINT DF_MucCanhBao DEFAULT 0,
	---Khóa---
    CONSTRAINT PK_TKNL PRIMARY KEY (MaChiNhanh, MaNguyenLieu),
    CONSTRAINT FK_TK_NL FOREIGN KEY (MaNguyenLieu) REFERENCES NguyenLieu(MaNguyenLieu),
	CONSTRAINT FK_TK_CN FOREIGN KEY (MaChiNhanh) REFERENCES ChiNhanh(MaChiNhanh),
	CONSTRAINT CK_SoLuongTon CHECK (SoLuongTon >= 0),
	CONSTRAINT CK_MucCanhBao CHECK (MucCanhBao >= 0)
);
/*
=========================
4.CÔNG THỨC 
=========================
*/
CREATE TABLE CongThucPhaChe (
    MaCongThuc char(10) not null,
    MaBienThe char(10),
    MaNguyenLieu char(10),
    SoLuongSuDung DECIMAL(10,2),

	---Khóa---
	CONSTRAINT PK_CTPC PRIMARY KEY (MaCongThuc,MaNguyenLieu),
    CONSTRAINT FK_CTPC_NL FOREIGN KEY (MaNguyenLieu) REFERENCES NguyenLieu(MaNguyenLieu),
	CONSTRAINT FK_CTPC_BTSP FOREIGN KEY (MaBienThe) REFERENCES BienTheSanPham(MaBienThe),
	---Ràng buộc---
	CONSTRAINT CK_SoLuongSuDung CHECK (SoLuongSuDung > 0)
);
/*
=========================
5.LỊCH SỬ KHO
=========================
*/
CREATE TABLE LichSuKho (
    LogID char(10) not null,
    MaChiNhanh char(25) not null,
    MaNguyenLieu char(10),
    LoaiGiaoDich nvarchar(20),
    SoLuong DECIMAL(12,2),
    ThoiGian datetime CONSTRAINT DF_ThoiGian DEFAULT CURRENT_TIMESTAMP,
    GhiChu nvarchar(255),

	---Khóa---
	CONSTRAINT PK_LSK PRIMARY KEY (LogID),
    CONSTRAINT fk_ls_nguyenlieu FOREIGN KEY (MaNguyenLieu) REFERENCES NguyenLieu(MaNguyenLieu),
	CONSTRAINT FK_LSK_CN FOREIGN KEY (MaChiNhanh) REFERENCES ChiNhanh(MaChiNhanh),
	---Ràng buộc---
	CONSTRAINT CK_LoaiGiaoDich CHECK (LoaiGiaoDich in (N'Nhập', N'Xuất', N'Hao Hụt', N'Hết Hạn')),
	CONSTRAINT CK_SoLuong CHECK (SoLuong>0)
);

/*
============================
CÁC TRIGGER
============================
*/
---1.Xử Lý Kho Tổng Hợp
CREATE TRIGGER TRG_XuLyKhoTongHop
ON LichSuKho
AFTER INSERT
AS
BEGIN
    -- Kiểm tra nếu là các loại làm GIẢM kho mà không đủ hàng thì báo lỗi
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN TonKhoNguyenLieu tk ON tk.MaNguyenLieu = i.MaNguyenLieu AND tk.MaChiNhanh = i.MaChiNhanh
        WHERE i.LoaiGiaoDich IN (N'Xuất', N'Hao Hụt', N'Hết Hạn')
          AND tk.SoLuongTon < i.SoLuong
    )
    BEGIN
        RAISERROR (N'Lỗi: Kho không đủ hàng để Xuất/Trừ hao hụt!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Cập nhật số lượng tồn: Nhập thì cộng (+), còn lại thì trừ (-)
    UPDATE tk
    SET tk.SoLuongTon = tk.SoLuongTon + 
        CASE 
            WHEN i.LoaiGiaoDich = N'Nhập' THEN i.SoLuong 
            ELSE -i.SoLuong 
        END
    FROM TonKhoNguyenLieu tk
    JOIN inserted i ON tk.MaChiNhanh = i.MaChiNhanh AND tk.MaNguyenLieu = i.MaNguyenLieu;
END;

/*
===================================== Dữ liệu và test =====================================
*/

-- DỮ LIỆU TEST – NHÀ CUNG CẤP
INSERT INTO NhaCungCap (MaNCC, TenNCC, DienThoai, Email, DiaChi, TrangThai)
VALUES
('NCC01', N'Công ty Cà Phê Việt', '0901111111', 'caphe@viet.com', N'HCM', N'Đang Hợp Tác'),
('NCC02', N'Công ty Nguyên Liệu Trà', '0902222222', 'tra@viet.com', N'HCM', N'Đang Hợp Tác');

-- DỮ LIỆU TEST – NGUYÊN LIỆU
INSERT INTO NguyenLieu
(MaNguyenLieu, TenNguyenLieu, DonViTinh, GiaNhap, MaNCC, CoHanSuDung, TrangThai)
VALUES
('NL01', N'Cà phê hạt', 'kg', 120000, 'NCC01', 0, N'Đang Sử Dụng'),
('NL02', N'Sữa tươi', 'ml', 15000, 'NCC01', 1, N'Đang Sử Dụng'),
('NL03', N'Trà đen', 'g', 80000, 'NCC02', 0, N'Đang Sử Dụng'),
('NL04', N'Đường', 'kg', 20000, 'NCC02', 0, N'Đang Sử Dụng');

-- DỮ LIỆU TEST – TỒN KHO NGUYÊN LIỆU (BAN ĐẦU)
INSERT INTO TonKhoNguyenLieu
(MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao)
VALUES
('001CN', 'NL01', 0, 5),
('001CN', 'NL02', 0, 1000),
('001CN', 'NL03', 0, 3),

('002CN', 'NL01', 0, 5),
('002CN', 'NL04', 0, 2);

-- DỮ LIỆU TEST – CÔNG THỨC PHA CHẾ
INSERT INTO CongThucPhaChe
(MaCongThuc, MaBienThe, MaNguyenLieu, SoLuongSuDung)
VALUES
('CT01', 'BT01', 'NL01', 0.02), -- 20g cà phê
('CT01', 'BT01', 'NL02', 50),   -- 50ml sữa
('CT01', 'BT01', 'NL04', 0.01); -- 10g đường

-- TEST TRIGGER – NHẬP KHO 
INSERT INTO LichSuKho
(LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, GhiChu)
VALUES
('LS01', '001CN', 'NL01', N'Nhập', 10, N'Nhập cà phê hạt'),
('LS02', '001CN', 'NL02', N'Nhập', 2000, N'Nhập sữa'),
('LS03', '001CN', 'NL04', N'Nhập', 5, N'Nhập đường');

SELECT * FROM TonKhoNguyenLieu WHERE MaChiNhanh = '001CN';

-- TEST TRIGGER – XUẤT KHO
INSERT INTO LichSuKho
(LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, GhiChu)
VALUES
('LS04', '001CN', 'NL01', N'Xuất', 2, N'Pha chế cà phê'),
('LS05', '001CN', 'NL02', N'Xuất', 500, N'Pha chế cà phê');

-- TEST TRIGGER – LỖI KHÔNG ĐỦ HÀNG
INSERT INTO LichSuKho
(LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong)
VALUES
('LS06', '001CN', 'NL01', N'Xuất', 100);

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN DƯƠNG GIA BẢO --

/* =============================================================================================================== */

/*=========================================== KhachHang ===========================================*/
CREATE TABLE KhachHang
(
    ID_KhachHang INT IDENTITY(1,1) NOT NULL,
	MaKH AS (
        CAST(
            CONCAT('KH', RIGHT(CONCAT('0000', CAST(ID_KhachHang AS VARCHAR(10))), 4))
            AS CHAR(6)
        )
    ) PERSISTED,      -- KH0001
	TenKH NVARCHAR(50) NOT NULL,
	SoDienThoai VARCHAR(10) NOT NULL,
	DiemTichLuy INT NOT NULL -- Giá trị mặc định của điểm tích lũy luôn là 0
    CONSTRAINT DF_KhachHang_DiemTichLuy DEFAULT 0,

	-------------------------------RÀNG BUỘC KHÓA BẢNG KhachHang-------------------------------

	CONSTRAINT PK_KhachHang PRIMARY KEY(MaKH),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG KhachHang-------------------------------

	-- Mỗi số điện thoại chỉ thuộc về một khách hàng
	CONSTRAINT UQ_KhachHang_SoDienThoai UNIQUE (SoDienThoai),

	

	-- Điểm tích lũy luôn lớn hơn hoặc bằng 0
	CONSTRAINT CHK_KhachHang_DiemTichLuy CHECK (DiemTichLuy >= 0),

	-- Format MaKH = KHxxxx (VD: KH0001)
	CONSTRAINT CHK_KhachHang_MaKH CHECK (MaKH LIKE 'KH[0-9][0-9][0-9][0-9]'),

	-- Format SĐT: chỉ nhận ký tự số và đủ 10 số
	CONSTRAINT CHK_KhachHang_SoDienThoai CHECK (SoDienThoai LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO


/*=========================================== DonHang ===========================================*/
CREATE TABLE DonHang
(
    ID_DonHang INT IDENTITY(1,1) NOT NULL,
	MaDH AS (
        CAST(
            CONCAT('DH', RIGHT(CONCAT('0000', CAST(ID_DonHang AS VARCHAR(10))), 4))
            AS CHAR(6)
        )
    ) PERSISTED,                -- DH0001
	MaChiNhanh CHAR(25) NOT NULL,
	MaNV CHAR(10) NOT NULL,
	MaKH CHAR(6) NOT NULL,
	TongTien DECIMAL(18,2) NOT NULL -- Giá trị mặc định của tổng tiền luôn là 0
	CONSTRAINT DF_DonHang_TongTien DEFAULT (0),       -- Tổng tiền từ chi tiết đơn
	GiamGia DECIMAL(18,2) NOT NULL -- Giá trị mặc định của giảm giá luôn là 0
    CONSTRAINT DF_DonHang_GiamGia DEFAULT (0),    -- Giảm giá (mô hình: đổi điểm)
	PhuongThucThanhToan NVARCHAR(50) NOT NULL -- Phương thức thanh toán mặc định là "Tiền mặt"
    CONSTRAINT DF_DonHang_PhuongThucThanhToan DEFAULT (N'Tiền mặt'),
	NgayTao DATETIME2(0) NOT NULL 	-- Giá trị mặc định của ngày giờ tạo đơn là thời điểm hiện tại
    CONSTRAINT DF_DonHang_NgayTao DEFAULT (SYSDATETIME()),

	-------------------------------RÀNG BUỘC KHÓA BẢNG DonHang-------------------------------

	CONSTRAINT PK_DonHang PRIMARY KEY(MaDH),
	CONSTRAINT FK_DonHang_ChiNhanh FOREIGN KEY(MaChiNhanh) REFERENCES ChiNhanh(MaChiNhanh),
	CONSTRAINT FK_DonHang_NhanVien FOREIGN KEY(MaNV) REFERENCES ThongTinNhanVien(MaNV),
	CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG DonHang-------------------------------

	-- Format MaDH = DHxxxx (VD: DH0001)
	CONSTRAINT CHK_DonHang_MaDH CHECK (MaDH LIKE 'DH[0-9][0-9][0-9][0-9]'),

	-- Tổng tiền phải >= 0
    CONSTRAINT CHK_DonHang_TongTien CHECK (TongTien >= 0),

	-- Giảm giá phải >= 0 và <= Tổng tiền
    CONSTRAINT CHK_DonHang_GiamGia CHECK (GiamGia >= 0 AND GiamGia <= TongTien),

	-- Ngày tạo <= thời điểm hiện tại
    
    -- CONSTRAINT CHK_DonHang_NgayTao CHECK (NgayTao <= SYSDATETIME()),

	-- Chỉ nhận 1 trong các phương thức sau
    CONSTRAINT CHK_DonHang_PhuongThucThanhToan
	CHECK (PhuongThucThanhToan IN (N'Tiền mặt', N'Thẻ', N'Chuyển khoản', N'QR', N'Ví điện tử')),

	-- Giảm giá tối đa 50% giá trị đơn: GiamGia <= 50% TongTien
	CONSTRAINT CHK_DonHang_GiamGia_ToiDa50PhanTram CHECK (GiamGia * 2 <= TongTien)
);
GO


/*=========================================== ChiTietDonHang ===========================================*/
CREATE TABLE ChiTietDonHang
(
    ID_ChiTietDonHang INT IDENTITY(1,1) NOT NULL,
	MaCTDH AS (
        CAST(
            CONCAT('CTDH', RIGHT(CONCAT('0000', CAST(ID_ChiTietDonHang AS VARCHAR(10))), 4))
            AS CHAR(8)
        )
    ) PERSISTED,               -- CTDH0001 (8 ký tự)
	MaDH CHAR(6) NOT NULL,
	MaBienThe CHAR(10) NOT NULL,
	SoLuong INT NOT NULL-- Số lượng mặc định là 1
	CONSTRAINT DF_ChiTietDonHang_SoLuong DEFAULT (1),

	DonGia MONEY NOT NULL,

	-------------------------------RÀNG BUỘC KHÓA BẢNG ChiTietDonHang-------------------------------

	CONSTRAINT PK_ChiTietDonHang PRIMARY KEY(MaCTDH),
	CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY(MaDH) REFERENCES DonHang(MaDH),
	CONSTRAINT FK_ChiTietDonHang_BienThe FOREIGN KEY(MaBienThe) REFERENCES BienTheSanPham(MaBienThe),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG ChiTietDonHang-------------------------------

	-- Một đơn hàng không được có 2 dòng cùng biến thể
    CONSTRAINT UQ_ChiTietDonHang_MaDH_MaBienThe UNIQUE (MaDH, MaBienThe),

	

	-- Format MaCTDH = CTDHxxxx (VD: CTDH0001)
	CONSTRAINT CHK_ChiTietDonHang_MaCTDH CHECK (MaCTDH LIKE 'CTDH[0-9][0-9][0-9][0-9]'),

	-- Số lượng > 0
    CONSTRAINT CHK_ChiTietDonHang_SoLuong CHECK (SoLuong > 0),

	-- Đơn giá >= 0
    CONSTRAINT CHK_ChiTietDonHang_DonGia CHECK (DonGia >= 0)
);
GO


/*=========================================== TRIGGER ===========================================*/

-- Tự động cập nhật TongTien của DonHang khi thêm/sửa/xóa ChiTietDonHang
CREATE TRIGGER TR_ChiTietDonHang_CapNhatTongTien
ON ChiTietDonHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH DonHangBiAnhHuong AS
    (
        SELECT MaDH FROM inserted
        UNION
        SELECT MaDH FROM deleted
    ),
    TongTienMoi AS
    (
        SELECT CT.MaDH,
               SUM(CAST(CT.SoLuong AS DECIMAL(18,2)) * CAST(CT.DonGia AS DECIMAL(18,2))) AS TongTien
        FROM ChiTietDonHang CT
        JOIN DonHangBiAnhHuong DH ON DH.MaDH = CT.MaDH
        GROUP BY CT.MaDH
    )
    UPDATE DH
    SET DH.TongTien = ISNULL(TT.TongTien, 0)
    FROM DonHang DH
    LEFT JOIN TongTienMoi TT ON TT.MaDH = DH.MaDH
    WHERE DH.MaDH IN (SELECT MaDH FROM DonHangBiAnhHuong);

    -- Nếu sau khi tính lại mà GiamGia > TongTien thì báo lỗi
    IF EXISTS
    (
        SELECT 1
        FROM DonHang DH
        WHERE DH.MaDH IN (SELECT MaDH FROM inserted UNION SELECT MaDH FROM deleted)
          AND DH.GiamGia > DH.TongTien
    )
    BEGIN
        THROW 52001, N'Giảm giá đang lớn hơn tổng tiền sau khi cập nhật chi tiết đơn hàng.', 1;
    END
END;
GO

--  + Điểm cộng: FLOOR((TongTien - GiamGia) / 10000)
--  + Điểm đã dùng: GiamGia/1000  (GiamGia phải là bội 1000)
--  + Điểm thay đổi = (điểm mới - điểm dùng mới) - (điểm cũ - điểm dùng cũ)
CREATE TRIGGER TR_DonHang_CapNhatDiemTichLuy
ON DonHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    --1 điểm = 1000đ
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE NOT (
            GiamGia = CONVERT(DECIMAL(18,2), CONVERT(INT, GiamGia)))
        OR NOT (
            (CONVERT(INT, GiamGia) % 1000) = 0)
    )
    BEGIN
        PRINT(N'Giảm giá phải là bội số của 1000 (1 điểm = 1000).')
    END;

    -- GiamGia tối đa 50% TongTien
    IF EXISTS (SELECT 1 FROM inserted WHERE GiamGia * 2 > TongTien)
    BEGIN
        PRINT(N'Giảm giá (đổi điểm) không được vượt quá 50% giá trị đơn hàng.')
    END;

    ;WITH TinhCu AS
    (
        SELECT  MaKH,
                SUM(CONVERT(INT, FLOOR((TongTien - GiamGia) / 10000.0))) AS DiemCong,
                SUM(CONVERT(INT, GiamGia / 1000.0)) AS DiemDung
        FROM deleted
        GROUP BY MaKH
    ),
    TinhMoi AS
    (
        SELECT  MaKH,
                SUM(CONVERT(INT, FLOOR((TongTien - GiamGia) / 10000.0))) AS DiemCong,
                SUM(CONVERT(INT, GiamGia / 1000.0)) AS DiemDung
        FROM inserted
        GROUP BY MaKH
    ),
    ChenhLech AS
    (
        -- Trừ theo trạng thái cũ
        SELECT MaKH, (0 - DiemCong + DiemDung) AS DiemThayDoi FROM TinhCu
        UNION ALL
        -- Cộng theo trạng thái mới
        SELECT MaKH, (DiemCong - DiemDung) AS DiemThayDoi FROM TinhMoi
    ),
    TongChenhLech AS
    (
        SELECT MaKH, SUM(DiemThayDoi) AS DiemThayDoi
        FROM ChenhLech
        WHERE MaKH IS NOT NULL
        GROUP BY MaKH
    )
    UPDATE KH
    SET KH.DiemTichLuy = KH.DiemTichLuy + TL.DiemThayDoi
    FROM KhachHang KH
    JOIN TongChenhLech TL ON TL.MaKH = KH.MaKH;

    IF EXISTS (SELECT 1 FROM KhachHang WHERE DiemTichLuy < 0)
    BEGIN
        PRINT(N'Điểm tích lũy bị âm sau khi cập nhật đơn hàng. Kiểm tra giảm giá/điểm khách.')
    END
END;
GO


/*
===================================== Dữ liệu và test =====================================
*/
-- Khách hàng
INSERT INTO KhachHang (TenKH, SoDienThoai)
VALUES
(N'Trần Gia Bảo', '0901234567'),
(N'Nguyễn Thị B', '0912345678');

-- Đơn hàng
INSERT INTO DonHang
(MaChiNhanh, MaNV, MaKH)
VALUES
('001CN', '0012260002', 'KH0001');

-- Thêm chi tiết đơn hàng
INSERT INTO ChiTietDonHang
(MaDH, MaBienThe, SoLuong, DonGia)
VALUES
('DH0005', 'BT01', 2, 30000),  -- 60.000
('DH0005', 'BT02', 1, 40000);  -- 40.000

SELECT * FROM DonHang;

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

/*
===================================== TEST TOÀN HỆ THỐNG =====================================
*/

-- Kiểm tra chi nhánh đang hoạt động
SELECT MaChiNhanh, TenChiNhanh, TrangThai
FROM ChiNhanh
WHERE TrangThai = 1;

-- Kiểm tra nhân viên theo chi nhánh
SELECT cn.TenChiNhanh, nv.MaNV, nv.HoTenNV
FROM ThongTinNhanVien nv , ChiNhanh cn 
Where nv.MaChiNhanh = cn.MaChiNhanh and TenChiNhanh = 'Cà Phê Gibor Q1'

-- MENU chi nhánh 001CN
SELECT 
    cn.TenChiNhanh,
    sp.MaSanPham,
    sp.TenSanPham,
    dm.TenDanhMuc,
    spcn.GiaBan,
    spcn.TrangThai
FROM SanPham_ChiNhanh spcn
JOIN ChiNhanh cn ON spcn.MaChiNhanh = cn.MaChiNhanh
JOIN SanPham sp ON spcn.MaSanPham = sp.MaSanPham
JOIN DanhMuc dm ON sp.MaDanhMuc = dm.MaDanhMuc
WHERE spcn.MaChiNhanh = '001CN';

-- Size của 1 sản phẩm
SELECT 
    sp.TenSanPham,
    bt.Size,
    bt.GiaCongThem
FROM BienTheSanPham bt
JOIN SanPham sp ON bt.MaSanPham = sp.MaSanPham
WHERE sp.MaSanPham = 'SP01';

-- Topping được phép dùng cho sản phẩm
SELECT 
    sp.TenSanPham,
    tc.TenTuyChon,
    tc.GiaCongThem
FROM SanPham_TuyChon sptc
JOIN SanPham sp ON sptc.MaSanPham = sp.MaSanPham
JOIN TuyChonThem tc ON sptc.MaTuyChon = tc.MaTuyChon;

-- Xem lịch phân công
SELECT 
    nv.HoTenNV,
    c.TenCa,
    l.NgayLamViec,
    l.TrangThai
FROM LichPhanCong l
JOIN ThongTinNhanVien nv ON l.MaNV = nv.MaNV
JOIN CaLamViec c ON l.MaCa = c.MaCa
ORDER BY l.NgayLamViec;

-- Xem chấm công
SELECT 
    nv.HoTenNV,
    cc.GioVao,
    cc.GioRa,
    cc.TrangThai
FROM ChamCong cc
JOIN ThongTinNhanVien nv ON cc.MaNV = nv.MaNV;

-- Kiểm tra phạt đi muộn
SELECT *
FROM PhatDiMuon;

-- Xem bảng lương tháng
SELECT 
    nv.HoTenNV,
    bl.Thang,
    bl.Nam,
    bl.TongGioThucTe,
    bl.TongLuongCa,
    bl.TongThuong,
    bl.TongKhauTru,
    bl.ThucLinh,
    bl.TrangThai
FROM BangLuong bl
JOIN ThongTinNhanVien nv ON bl.MaNV = nv.MaNV;

-- Thử sửa bảng lương đã thanh toán 
UPDATE BangLuong
SET TongThuong = 999999
WHERE TrangThai = N'Đã thanh toán';
