CREATE DATABASE QL_QUANCAFE;
GO
USE QL_QUANCAFE;
GO

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
	DiemTichLuy INT NOT NULL,

	-------------------------------RÀNG BUỘC KHÓA BẢNG KhachHang-------------------------------

	CONSTRAINT PK_KhachHang PRIMARY KEY(MaKH),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG KhachHang-------------------------------

	-- Mỗi số điện thoại chỉ thuộc về một khách hàng
	CONSTRAINT UQ_KhachHang_SoDienThoai UNIQUE (SoDienThoai),

	-- Giá trị mặc định của điểm tích lũy luôn là 0
	CONSTRAINT DF_KhachHang_DiemTichLuy DEFAULT (0),

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
	MaChiNhanh CHAR(5) NOT NULL,
	MaNhanVien CHAR(5) NOT NULL,
	MaKH CHAR(6) NOT NULL,
	TongTien DECIMAL(18,2) NOT NULL,       -- Tổng tiền từ chi tiết đơn
	GiamGia DECIMAL(18,2) NOT NULL,        -- Giảm giá (mô hình: đổi điểm)
	PhuongThucThanhToan NVARCHAR(50) NOT NULL,
	NgayTao DATETIME2(0) NOT NULL,

	-------------------------------RÀNG BUỘC KHÓA BẢNG DonHang-------------------------------

	CONSTRAINT PK_DonHang PRIMARY KEY(MaDH),
	CONSTRAINT FK_DonHang_ChiNhanh FOREIGN KEY(MaChiNhanh) REFERENCES Branches(BranchID),
	CONSTRAINT FK_DonHang_NhanVien FOREIGN KEY(MaNhanVien) REFERENCES Employees(EmployeeID),
	CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG DonHang-------------------------------

	-- Giá trị mặc định của tổng tiền luôn là 0
	CONSTRAINT DF_DonHang_TongTien DEFAULT (0),

	-- Giá trị mặc định của giảm giá luôn là 0
    CONSTRAINT DF_DonHang_GiamGia DEFAULT (0),

	-- Giá trị mặc định của ngày giờ tạo đơn là thời điểm hiện tại
    CONSTRAINT DF_DonHang_NgayTao DEFAULT (SYSDATETIME()),

	-- Phương thức thanh toán mặc định là "Tiền mặt"
    CONSTRAINT DF_DonHang_PhuongThucThanhToan DEFAULT (N'Tiền mặt'),

	-- Format MaDH = DHxxxx (VD: DH0001)
	CONSTRAINT CHK_DonHang_MaDH CHECK (MaDH LIKE 'DH[0-9][0-9][0-9][0-9]'),

	-- Tổng tiền phải >= 0
    CONSTRAINT CHK_DonHang_TongTien CHECK (TongTien >= 0),

	-- Giảm giá phải >= 0 và <= Tổng tiền
    CONSTRAINT CHK_DonHang_GiamGia CHECK (GiamGia >= 0 AND GiamGia <= TongTien),

	-- Ngày tạo <= thời điểm hiện tại
    CONSTRAINT CHK_DonHang_NgayTao CHECK (NgayTao <= SYSDATETIME()),

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
	MaBienThe CHAR(5) NOT NULL,
	SoLuong INT NOT NULL,
	DonGia MONEY NOT NULL,

	-------------------------------RÀNG BUỘC KHÓA BẢNG ChiTietDonHang-------------------------------

	CONSTRAINT PK_ChiTietDonHang PRIMARY KEY(MaCTDH),
	CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY(MaDH) REFERENCES DonHang(MaDH),
	CONSTRAINT FK_ChiTietDonHang_BienThe FOREIGN KEY(MaBienThe) REFERENCES BienTheSanPham(MaBienThe),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG ChiTietDonHang-------------------------------

	-- Một đơn hàng không được có 2 dòng cùng biến thể
    CONSTRAINT UQ_ChiTietDonHang_MaDH_MaBienThe UNIQUE (MaDH, MaBienThe),

	-- Số lượng mặc định là 1
	CONSTRAINT DF_ChiTietDonHang_SoLuong DEFAULT (1),

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


