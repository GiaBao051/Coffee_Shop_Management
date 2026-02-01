CREATE DATABASE QL_QUANCAFE
USE QL_QUANCAFE

CREATE TABLE Customers
(
	CustomerID CHAR(5) NOT NULL,
	CustomerName NVARCHAR(50) NOT NULL,
	Phone VARCHAR(10) NOT NULL,
	LoyaltyPoints INT NOT NULL,

	-------------------------------RÀNG BUỘC KHÓA BẢNG Customers-------------------------------

	CONSTRAINT PK_Customers PRIMARY KEY(CustomerID),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG Customers-------------------------------

	--Check mỗi số điện thoại chỉ thuộc về một khách hàng
	CONSTRAINT UQ_Customers_Phone UNIQUE (Phone),

	--Giá trị mặc định của điểm tích lũy luôn là 0
	CONSTRAINT DF_Customers_LoyaltyPoints DEFAULT (0) FOR LoyaltyPoints,

	--Điểm tích lũy luôn lớn hơn hoặc bằng 0
	CONSTRAINT CHK_Customers_LoyaltyPoints CHECK (LoyaltyPoints >= 0),

	--Fomat CustomerID = KHxxx (VD: KH0001)
	CONSTRAINT CHK_Customers_CustomerID CHECK (CustomerID LIKE 'KH[0-9][0-9][0-9][0-9]'),

	--Fomat Phone luôn nhận kí tự số
	CONSTRAINT CHK_Customers_Phone CHECK (Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

CREATE TABLE Orders
(
	OrderID CHAR(5) NOT NULL,
	BranchID CHAR(5) NOT NULL,
	EmployeeID CHAR(5) NOT NULL,
	CustomerID CHAR(5) NOT NULL,
	TotalAmount DECIMAL NOT NULL,
	Discount DECIMAL NOT NULL,
	PaymentMethod NVARCHAR(50) NOT NULL,
	CreateAt DATETIME NOT NULL,

	-------------------------------RÀNG BUỘC KHÓA BẢNG Orders-------------------------------

	CONSTRAINT PK_Orders PRIMARY KEY(OrderID),
	CONSTRAINT FK_Orders_Branches FOREIGN KEY(BranchID) REFERENCES Branches(BranchID),
	CONSTRAINT FK_Orders_Employees FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID),
	CONSTRAINT FK_Orders_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG Orders-------------------------------

	--Giá trị mặc định của thành tiền luôn là 0
	CONSTRAINT DF_Orders_TotalAmount DEFAULT (0) FOR TotalAmount,

	--Giá trị mặc định của giảm giá luôn là 0
    CONSTRAINT DF_Orders_Discount    DEFAULT (0) FOR Discount,

	--Gía trị mặc định của ngày và giờ khi tạo đơn hàng luôn là ngày và giờ lúc thực hiện giao dịch
    CONSTRAINT DF_Orders_CreateAt DEFAULT (SYSDATETIME()) FOR CreateAt,

	--Phương thức thanh toán mặc định luôn là "Tiền mặt"
    CONSTRAINT DF_Orders_PaymentMethod DEFAULT (N'Tiền mặt') FOR PaymentMethod,

	--Mã đơn hàng phải bắt đầu từ DHxxx (VD: DH0001)
	CONSTRAINT CK_Orders_OrderID CHECK (OrderID LIKE 'DH[0-9][0-9][0-9][0-9]'),

	--Thành tiền phải lớn hơn hoặc bằng 0
    CONSTRAINT CHK_Orders_TotalAmount CHECK (TotalAmount >= 0),

	--Giảm giá phải lớn hơn hoặc bàng 0 và vé hơn hoặc bằng thành tiền
    CONSTRAINT CHK_Orders_Discount CHECK (Discount >= 0 AND Discount <= TotalAmount),

	--Ngày và giờ khi tạo đơn hàng luôn bé hơn hoặc bằng ngày và giờ hiện tại
    CONSTRAINT CHK_Orders_CreateAt CHECK (CreateAt <= GETDATE()),

	--Phương thức thanh toán chỉ được nhận một trong các phương thức sau
    CONSTRAINT CHK_Orders_PaymentMethod
	CHECK (PaymentMethod IN (N'Tiền mặt', N'Thẻ', N'Chuyển khoản', N'QR', N'Ví điện tử'))

)

CREATE TABLE OrderDetails
(
	DetailID CHAR(5) NOT NULL,
	OrderID CHAR(5) NOT NULL, 
	VariantID CHAR(5) NOT NULL,
	Quantity INT NOT NULL,
	UnitPrice MONEY NOT NULL,

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG OrderDetails-------------------------------

	CONSTRAINT PK_OrderDetails PRIMARY KEY(DetailID),
	CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT FK_OrderDetails_ProductVariants FOREIGN KEY(VariantID) REFERENCES ProductVariants(VariantID),

	-------------------------------RÀNG BUỘC GIÁ TRỊ BẢNG OrderDetails-------------------------------

	--Một đơn hàng không được có 2 dòng cùng Variant
    CONSTRAINT UQ_OrderDetails_Order_Variant UNIQUE (OrderID, VariantID),

	--Số lượng mặc định của một Product luôn là 1
	CONSTRAINT DF_OrderDetails_Quantity DEFAULT (1) FOR Quantity,

	--Mã chi tiết đơn hàng luôn bắt đầu bằng CTDHxxxx (VD: CDH0001)
	CONSTRAINT CHK_OrderDetails_DetailID CHECK (DetailID LIKE 'D[0-9][0-9][0-9][0-9]'),

	--Số lượng luôn lớn hơn 0
    CONSTRAINT CHK_OrderDetails_Quantity CHECK (Quantity > 0),

	--Đơn giá luôn lớn hơn hoặc bằng 0
    CONSTRAINT CHK_OrderDetails_UnitPrice CHECK (UnitPrice >= 0)
)

	-------------------------------TRIGGER-------------------------------

	--Tự động cập nhật 
